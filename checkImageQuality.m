function quality = checkImageQuality(imageInput, cfg)
    %CHECKIMAGEQUALITY Assess fundus image gradability.
    % Supports a filename or an already-loaded image.

    if ischar(imageInput) || isstring(imageInput)
        imageFile = string(imageInput);
        img = imread(imageFile);
    else
        imageFile = "<in-memory>";
        img = imageInput;
    end

    if ndims(img) == 2
        rgb = repmat(img,1,1,3);
    elseif ndims(img) == 3 && size(img,3) == 3
        rgb = img;
    else
        error("checkImageQuality:Input", "Expected a grayscale or RGB fundus image.");
    end

    rgb = im2uint8(rgb);
    gray = rgb2gray(rgb);
    grayD = im2double(gray);
    [h,w] = size(grayD);

    % Estimate the circular retinal field of view from the non-black region.
    retinaSeed = grayD > 0.04;
    retinaSeed = imclose(retinaSeed, strel("disk", max(3,round(min(h,w)/80))));
    retinaSeed = imfill(retinaSeed,"holes");
    retinaSeed = bwareafilt(retinaSeed,1);
    if ~any(retinaSeed(:))
        quality = struct("imageFile",imageFile,"sharpness",NaN,"brightness",NaN,"contrast",NaN, ...
        "illuminationVariation",NaN,"fovFraction",0,"clippedDark",1,"clippedBright",0,"score",0, ...
        "status","REJECT","isGood",false,"isBorderline",false,"retinaMask",retinaSeed, ...
        "reasons","no usable retinal field-of-view","message","Ungradable image: no usable retinal field-of-view detected");
        return;
    end
    fovFraction = nnz(retinaSeed)/(h*w);

    % Focus / contrast / exposure measurements.
    lap = imfilter(grayD,[0 -1 0; -1 4 -1; 0 -1 0],"replicate");
    sharpness = var(lap(retinaSeed));
    contrast = std(grayD(retinaSeed));
    brightness = mean(grayD(retinaSeed));

    % Illumination variation across a coarse grid, restricted to retinal pixels.
    blockMeans = nan(4,4);
    for r = 1:4
        for c = 1:4
            r1 = floor((r-1)*h/4)+1; r2 = floor(r*h/4);
            c1 = floor((c-1)*w/4)+1; c2 = floor(c*w/4);
            b = grayD(r1:r2,c1:c2);
            m = retinaSeed(r1:r2,c1:c2);
            if any(m(:)), blockMeans(r,c) = mean(b(m)); end
        end
    end
    vals=blockMeans(~isnan(blockMeans));
    if numel(vals)>1, illuminationVariation = std(vals); else, illuminationVariation=1; end

    clippedDark = mean(grayD(retinaSeed) <= 0.02);
    clippedBright = mean(grayD(retinaSeed) >= 0.98);

    % Each component contributes between 0 and 1.
    sharpGood = metricBand(sharpness,cfg.quality.sharpnessBorderline,cfg.quality.sharpnessGood);
    contrastGood = metricBand(contrast,cfg.quality.contrastBorderline,cfg.quality.contrastGood);
    brightnessGood = bandScore(brightness,cfg.quality.brightnessMin,cfg.quality.brightnessMax);
    fovGood = bandScore(fovFraction,cfg.quality.fovMinFraction,cfg.quality.fovMaxFraction);
    illumGood = max(0,min(1,1-illuminationVariation/max(cfg.quality.illuminationMax,eps)));
    exposureGood = max(0,1-clippedDark/max(cfg.quality.clippedDarkMax,eps)) ...
    * max(0,1-clippedBright/max(cfg.quality.clippedBrightMax,eps));

    score = 0.25*sharpGood + 0.15*contrastGood + 0.15*brightnessGood + ...
    0.20*fovGood + 0.15*illumGood + 0.10*exposureGood;

    hardBad = fovFraction < 0.20 || brightness < 0.04 || brightness > 0.96 || ...
    contrast < 0.03 || sharpness < cfg.quality.sharpnessBorderline;

    if hardBad || score < cfg.quality.borderlineScore
        status = "REJECT";
    elseif score < cfg.quality.acceptScore
        status = "BORDERLINE";
    else
        status = "ACCEPT";
    end

    reasons = strings(0,1);
    if sharpness < cfg.quality.sharpnessGood, reasons(end+1) = "low sharpness"; end
    if brightness < cfg.quality.brightnessMin || brightness > cfg.quality.brightnessMax, reasons(end+1) = "poor exposure"; end
    if contrast < cfg.quality.contrastGood, reasons(end+1) = "low contrast"; end
    if fovFraction < cfg.quality.fovMinFraction, reasons(end+1) = "insufficient fundus field-of-view"; end
    if fovFraction > cfg.quality.fovMaxFraction, reasons(end+1) = "edge/cropping artifact"; end
    if illuminationVariation > cfg.quality.illuminationMax, reasons(end+1) = "uneven illumination"; end
    if clippedDark > cfg.quality.clippedDarkMax, reasons(end+1) = "dark clipping"; end
    if clippedBright > cfg.quality.clippedBrightMax, reasons(end+1) = "bright clipping"; end

    if status == "ACCEPT"
        message = "Image gradability acceptable";
    elseif status == "BORDERLINE"
        message = "Borderline image: adaptive enhancement will be attempted";
    else
        if isempty(reasons), reasons = "multiple quality failures"; end
        message = "Ungradable image: " + strjoin(reasons,", ");
    end

    quality = struct( ...
    "imageFile",imageFile,"sharpness",sharpness,"brightness",brightness,"contrast",contrast, ...
    "illuminationVariation",illuminationVariation,"fovFraction",fovFraction, ...
    "clippedDark",clippedDark,"clippedBright",clippedBright,"score",score, ...
    "status",status,"isGood",status ~= "REJECT","isBorderline",status == "BORDERLINE", ...
    "retinaMask",retinaSeed,"reasons",reasons,"message",message);
end

function y = metricBand(x,borderline,good)
    if x >= good, y = 1; return; end
    if x <= borderline, y = 0; return; end
    y = (x-borderline)/(good-borderline);
end

function y = bandScore(x,lo,hi)
    if x >= lo && x <= hi
        y = 1;
    elseif x < lo
        y = max(0,x/max(lo,eps));
    else
        y = max(0,(1-x)/max(1-hi,eps));
    end
end
