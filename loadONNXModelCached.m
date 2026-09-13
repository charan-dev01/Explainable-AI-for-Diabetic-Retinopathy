function net = loadONNXModelCached(modelFile)
    %LOADONNXMODELCACHED Import and cache an ONNX model.
    arguments
        modelFile (1,1) string
    end

    persistent cachePaths cacheNets
    if isempty(cachePaths)
        cachePaths = strings(0,1);
        cacheNets = cell(0,1);
    end

    modelFile = char(modelFile);
    if ~isfile(modelFile)
        error("loadONNXModelCached:MissingFile", "Model file not found: %s", modelFile);
    end

    idx = find(cachePaths == string(modelFile),1);
    if ~isempty(idx)
        net = cacheNets{idx};
        return;
    end

    net = importNetworkFromONNX(modelFile);
    cachePaths(end+1,1) = string(modelFile);
    cacheNets{end+1,1} = net;
end
