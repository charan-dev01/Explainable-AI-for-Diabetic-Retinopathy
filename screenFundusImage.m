function result = screenFundusImage(net, img, cfg)
    %SCREENFUNDUSIMAGE Run the supplied 5-class ONNX DR classifier.

    if ndims(img) == 2
        img = repmat(img,1,1,3);
    end
    if ndims(img) ~= 3 || size(img,3) ~= 3
        error("screenFundusImage:Input", "Expected an RGB image.");
    end

    x = im2single(imresize(img,cfg.classifier.inputSize));
    meanVal = reshape(single(cfg.classifier.mean),1,1,3);
    stdVal = reshape(single(cfg.classifier.std),1,1,3);
    x = (x - meanVal) ./ stdVal;

    % Imported ONNX networks can expose image data with or without an explicit batch.
    try
        dlX = dlarray(x,"SSC");
        scores = predict(net,dlX);
    catch
        dlX = dlarray(x,"SSCB");
        scores = predict(net,dlX);
    end

    logits = extractScores(scores);
    logits = double(logits(:));
    if numel(logits) ~= numel(cfg.classifier.classes)
        error("screenFundusImage:Output", ...
        "Classifier returned %d scores; expected %d.", numel(logits), numel(cfg.classifier.classes));
    end

    % Temperature scaling is 1.0 until validated and fitted.
    T = max(double(cfg.classifier.temperature),0.05);
    probs = softmaxStable(logits./T);
    [confidence,idx] = max(probs);
    predictedGrade = idx-1;
    referableProbability = sum(probs(cfg.classifier.referableGrades+1));
    referable = referableProbability >= cfg.classifier.referableThreshold;

    result = struct();
    result.probabilities = probs;
    result.logits = logits;
    result.predictedGrade = predictedGrade;
    result.predictedClass = string(cfg.classifier.classes(idx));
    result.confidence = confidence;
    result.referableProbability = referableProbability;
    result.referable = referable;
    result.temperature = T;
    result.inputImage = x;
end

function scores = extractScores(pred)
    if isa(pred,"dlarray")
        scores = gather(extractdata(pred));
    elseif isnumeric(pred)
        scores = pred;
    elseif iscell(pred)
        for i = 1:numel(pred)
            try
                candidate = extractScores(pred{i});
                if isnumeric(candidate) && numel(candidate) >= 5
                    scores = candidate; return;
                end
            catch
            end
        end
        error("screenFundusImage:Output", "Could not find numeric classifier scores in cell output.");
    elseif isstruct(pred)
        f = fieldnames(pred);
        for i = 1:numel(f)
            try
                candidate = extractScores(pred.(f{i}));
                if isnumeric(candidate) && numel(candidate) >= 5
                    scores = candidate; return;
                end
            catch
            end
        end
        error("screenFundusImage:Output", "Could not find numeric classifier scores in struct output.");
    else
        error("screenFundusImage:Output", "Unsupported classifier output type: %s",class(pred));
    end
end

function p = softmaxStable(z)
    z = z - max(z);
    e = exp(z);
    p = e/sum(e);
end
