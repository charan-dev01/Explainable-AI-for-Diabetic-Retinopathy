function [simOut, simPlan] = runSimulinkScenario(rootDir)
%RUNSIMULINKSCENARIO Run an 8-hour replay of the queue/capacity simulation.
%
% If this file is stored in the project's \simulink folder, the project
% root is inferred automatically. prototypeConfig.json is expected in the
% project root, not inside \simulink.

scriptDir = fileparts(mfilename('fullpath'));

if nargin < 1 || isempty(rootDir)
    rootDir = fileparts(scriptDir);
end

% Accept either the project root or its \simulink subfolder.
configFile = fullfile(rootDir, 'prototypeConfig.json');
if exist(configFile, 'file') ~= 2
    parentDir = fileparts(rootDir);
    parentConfig = fullfile(parentDir, 'prototypeConfig.json');
    if exist(parentConfig, 'file') == 2
        rootDir = parentDir;
        configFile = parentConfig;
    else
        error('runSimulinkScenario:MissingConfig', ...
            ['prototypeConfig.json was not found. Expected it in the project ', ...
             'root, for example: %s'], configFile);
    end
end

if exist('simulateScreeningCapacity', 'file') ~= 2
    % The simulator may live in the project root or in this folder.
    if exist(fullfile(rootDir, 'simulateScreeningCapacity.m'), 'file') == 2
        addpath(rootDir);
    elseif exist(fullfile(scriptDir, 'simulateScreeningCapacity.m'), 'file') == 2
        addpath(scriptDir);
    else
        error('runSimulinkScenario:MissingDependency', ...
            'simulateScreeningCapacity.m is not on the MATLAB path or project folder.');
    end
end

cfg = jsondecode(fileread(configFile));

simPlan = simulateScreeningCapacity( ...
    cfg, ...
    'AnnualPatients', cfg.simulation.annualPatients, ...
    'CaptureStations', cfg.simulation.captureStations);

nSteps = min(480, numel(simPlan.timeMinutes));
t = (0:nSteps - 1)';

% From Workspace expects N samples. Keep each signal as an N-by-1 vector.
assignin('base', 'captureQueueWS', ...
    timeseries(simPlan.captureQueue(1:nSteps), t));
assignin('base', 'uploadQueueWS', ...
    timeseries(simPlan.uploadQueue(1:nSteps), t));
assignin('base', 'processingQueueWS', ...
    timeseries(simPlan.processingQueue(1:nSteps), t));
assignin('base', 'reviewQueueWS', ...
    timeseries(simPlan.reviewQueue(1:nSteps), t));

assignin('base', 'captureCapacityWS', ...
    timeseries(repmat(simPlan.captureCapacity, nSteps, 1), t));
assignin('base', 'uploadCapacityWS', ...
    timeseries(repmat(simPlan.uplinkImageCapacityPerMinute, nSteps, 1), t));
assignin('base', 'processingCapacityWS', ...
    timeseries(repmat(simPlan.processedCapacity, nSteps, 1), t));
assignin('base', 'reviewCapacityWS', ...
    timeseries(repmat(simPlan.reviewCapacity, nSteps, 1), t));

% The Simulink model belongs in the \simulink folder.
modelFile = fullfile(rootDir, 'simulink', 'DR_Screening_Resource_Model.slx');
if exist(modelFile, 'file') ~= 2
    modelFile = fullfile(scriptDir, 'DR_Screening_Resource_Model.slx');
end
if exist(modelFile, 'file') ~= 2
    modelFile = buildScreeningWorkflowModel(rootDir);
end

load_system(modelFile);
cleanupModel = onCleanup(@() close_system(modelFile, 0)); %#ok<NASGU>
simOut = sim(modelFile, 'StopTime', '480');
end
