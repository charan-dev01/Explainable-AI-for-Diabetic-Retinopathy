function enhanced = enhanceFundusImage(imageInput)
    %ENHANCEFUNDUSIMAGE Illumination normalization, CLAHE, and light denoising.
    if ischar(imageInput) || isstring(imageInput)
        img = imread(imageInput);
    else
        img = imageInput;
    end

    if ndims(img) == 2
        img = repmat(img,1,1,3);
    end
    img = im2uint8(img);

    % Work on LAB lightness for natural color preservation.
    lab = rgb2lab(img);
    L = mat2gray(lab(:,:,1));

    % Estimate slow illumination field and normalize the lightness channel.
    illum = imgaussfilt(L, max(7,round(min(size(L))/30)));
    Lnorm = mat2gray(L ./ max(illum,0.05));
    Lclahe = adapthisteq(Lnorm,"ClipLimit",0.01,"NumTiles",[8 8]);

    lab(:,:,1) = Lclahe * 100;
    enhanced = lab2rgb(lab);
    enhanced = im2uint8(enhanced);

    % Mild denoising; use bilateral if available.
    try
        enhanced = imbilatfilt(enhanced);
    catch
        enhanced = medfilt3(enhanced,[3 3 1]);
    end
end
