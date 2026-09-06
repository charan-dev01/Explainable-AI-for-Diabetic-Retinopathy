function setupPrototype()
    %SETUPPROTOTYPE Add prototype folders to the MATLAB path and validate files.
    rootDir = fileparts(mfilename('fullpath'));
    addpath(rootDir);
    addpath(fullfile(rootDir,"simulink"));
    addpath(fullfile(rootDir,"validation"));
    addpath(fullfile(rootDir,"models"));

    required = [ ...
    fullfile(rootDir,"models","aptos_dr_classifier.onnx")
    fullfile(rootDir,"models","microaneurysm_model.onnx")
    fullfile(rootDir,"models","hemorrhage_model.onnx")
    fullfile(rootDir,"models","exudate_model.onnx")
    ];
    for k = 1:numel(required)
        if ~isfile(required(k))
            error("Missing prototype model: %s", required(k));
        end
    end

    fprintf("DR screening prototype ready.\n");
    fprintf("Root: %s\n", rootDir);
    fprintf("Models: %d/4 found.\n", sum(isfile(required)));
end
