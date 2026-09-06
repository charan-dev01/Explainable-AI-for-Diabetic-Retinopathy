function modelFile = buildScreeningWorkflowModel(rootDir)
%BUILDSCREENINGWORKFLOWMODEL Create the queue/capacity replay Simulink model.
%
% rootDir is the project root. The generated model is stored in
% <rootDir>\simulink\DR_Screening_Resource_Model.slx.

scriptDir = fileparts(mfilename('fullpath'));
if nargin < 1 || isempty(rootDir)
    rootDir = fileparts(scriptDir);
end

% If the caller supplied the \simulink directory, normalize to its parent.
if strcmpi(string(rootDir), string(scriptDir))
    rootDir = fileparts(scriptDir);
end

modelName = 'DR_Screening_Resource_Model';
modelDir = fullfile(rootDir, 'simulink');
if exist(modelDir, 'dir') ~= 7
    modelDir = scriptDir;
end
modelFile = fullfile(modelDir, [modelName '.slx']);

if exist(modelFile, 'file') == 2
    delete(modelFile);
end

new_system(modelName);
cleanupObj = onCleanup(@() close_system(modelName, 0)); %#ok<NASGU>
set_param(modelName, 'StopTime', '480', ...
    'Solver', 'FixedStepDiscrete', 'FixedStep', '1');

queueNames = {'CaptureQueue','UploadQueue','ProcessingQueue','ReviewQueue'};
queueVars = {'captureQueueWS','uploadQueueWS','processingQueueWS','reviewQueueWS'};
for i = 1:numel(queueNames)
    y = 30 + (i-1)*90;
    add_block('simulink/Sources/From Workspace', ...
        [modelName '/' queueNames{i}], 'VariableName', queueVars{i}, ...
        'Position', [30 y 175 y+25]);
end

add_block('simulink/Signal Routing/Mux', [modelName '/QueueMux'], ...
    'Inputs', '4', 'Position', [220 70 250 170]);
add_block('simulink/Sinks/Scope', [modelName '/QueueScope'], ...
    'Position', [300 70 470 180]);
for i = 1:numel(queueNames)
    add_line(modelName, [queueNames{i} '/1'], ['QueueMux/' num2str(i)]);
end
add_line(modelName, 'QueueMux/1', 'QueueScope/1');

capNames = {'CaptureCapacity','UploadCapacity','ProcessingCapacity','ReviewCapacity'};
capVars = {'captureCapacityWS','uploadCapacityWS','processingCapacityWS','reviewCapacityWS'};
for i = 1:numel(capNames)
    y = 420 + (i-1)*55;
    add_block('simulink/Sources/From Workspace', ...
        [modelName '/' capNames{i}], 'VariableName', capVars{i}, ...
        'Position', [30 y 175 y+25]);
end

add_block('simulink/Signal Routing/Mux', [modelName '/CapacityMux'], ...
    'Inputs', '4', 'Position', [220 450 250 530]);
add_block('simulink/Sinks/Scope', [modelName '/CapacityScope'], ...
    'Position', [300 420 470 550]);
for i = 1:numel(capNames)
    add_line(modelName, [capNames{i} '/1'], ['CapacityMux/' num2str(i)]);
end
add_line(modelName, 'CapacityMux/1', 'CapacityScope/1');

save_system(modelName, modelFile);
close_system(modelName, 0);
fprintf('Created replay/planning model: %s\n', modelFile);
end
