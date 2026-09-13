function lesion = runLesionModel(modelFile, image, cfg, lesionName)
    %RUNLESIONMODEL Run one lesion-segmentation ONNX model with safe fallbacks.
    arguments
        modelFile (1,1) string
        image
        cfg struct
        lesionName (1,1) string = "lesion"
    end

    if ndims(image) ~= 3 || size(image,3) ~= 3
        error("runLesionModel:Input", "Expected RGB fundus image HxWx3.");
    end

    inputImage = imresize(im2uint8(image),cfg.lesion.inputSize);
    inputImage = im2single(inputImage);
    if ~isa(image,"uint8") && max(inputImage(:),[],'omitnan') > 1
        inputImage = inputImage/255;
    end

    try
        net = loadONNXModelCached(modelFile);
        % Friend-1 preprocessing: RGB -> 256x256 -> single [0,1], with an explicit batch.
        batchImage = reshape(inputImage,[size(inputImage,1) size(inputImage,2) 3 1]);
        try
            dlX = dlarray(batchImage,"SSCB");
            pred = predict(net,dlX);
        catch
            % Some MATLAB ONNX imports expose the batchless image signature.
            dlX = dlarray(inputImage,"SSC");
            pred = predict(net,dlX);
        end
        probability = findProbabilityMap(pred,cfg.lesion.inputSize);
        modelUsed = true;
        errorMessage = "";
    catch ME
        probability = classicalLesionFallback(inputImage,lesionName);
        modelUsed = false;
        errorMessage = string(ME.message);
    end

    probability = max(0,min(1,double(probability)));
    mask = probability >= cfg.lesion.threshold;
    mask = bwareaopen(mask,cfg.lesion.minComponentPixels);

    cc = bwconncomp(mask);
    subpixelCentroids = zeros(cc.NumObjects,2);
    for k = 1:cc.NumObjects
        px = cc.PixelIdxList{k};
        [r,c] = ind2sub(size(mask),px);
        weights = probability(px) + eps;
        subpixelCentroids(k,:) = [sum(c.*weights)/sum(weights), sum(r.*weights)/sum(weights)];
    end

    areaPixels = nnz(mask);
    lesion = struct( ...
    "name",lesionName,"probability",probability,"mask",mask, ...
    "present",areaPixels>0,"areaPixels",areaPixels, ...
    "areaPercent",100*areaPixels/numel(mask), ...
    "subpixelCentroids",subpixelCentroids,"modelUsed",modelUsed, ...
    "errorMessage",errorMessage);
end

function probability = findProbabilityMap(pred,targetSize)
    if isa(pred,"dlarray")
        pred = gather(extractdata(pred));
    end
    if isnumeric(pred)
        s = size(pred);
        pred = squeeze(pred);
        if isequal(size(pred),targetSize)
            probability = pred; return;
        end
        if numel(pred) == prod(targetSize)
            probability = reshape(pred,targetSize); return;
        end
        error("runLesionModel:Output","Numeric output size %s is not a %dx%d map.",mat2str(s),targetSize(1),targetSize(2));
    elseif iscell(pred)
        best = [];
        for i = 1:numel(pred)
            try
                candidate = findProbabilityMap(pred{i},targetSize);
                if isempty(best) || numel(candidate)>numel(best), best=candidate; end
                catch
                end
            end
            if ~isempty(best), probability=best; return; end
            end
            error("runLesionModel:Output","No usable lesion probability map found in ONNX output.");
        end

        function probability = classicalLesionFallback(inputImage,name)
            %Research-only fallback when a supplied ONNX graph cannot be imported.
            rgb=im2double(inputImage);
            r=rgb(:,:,1); g=rgb(:,:,2);
            if name=="exudate"
                bright=(r+g)/2;
                probability=mat2gray(bright-imgaussfilt(bright,9));
            elseif name=="hemorrhage"
                darkness=1-max(r,g);
                probability=mat2gray(imgaussfilt(darkness,1.0));
            else
                response=imgaussfilt(g,1)-g;
                probability=mat2gray(response);
            end
            probability=imgaussfilt(probability,0.6);
        end
