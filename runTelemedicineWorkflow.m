function workflow = runTelemedicineWorkflow(varargin)
%RUNTELEMEDICINEWORKFLOW Execute the planning model behind rural screening.
% workflow=runTelemedicineWorkflow('UseSimulink',true) also replays queues
% through the supplied Simulink model when Simulink is licensed.
p=inputParser; addParameter(p,'UseSimulink',false,@islogical); parse(p,varargin{:});
root=fileparts(mfilename('fullpath')); cfg=jsondecode(fileread(fullfile(root,'prototypeConfig.json')));
workflow=struct('capacity',simulateScreeningCapacity(cfg),'simulinkRan',false,'simulinkOutput',[]);
if p.Results.UseSimulink
    addpath(fullfile(root,'simulink'));
    [workflow.simulinkOutput,workflow.capacity]=runSimulinkScenario(root);
    workflow.simulinkRan=true;
end
workflow.bottleneck=string(findBottleneck(workflow.capacity));
end
function name=findBottleneck(s)
[~,i]=max([s.maxCaptureQueue s.maxUploadQueue s.maxProcessingQueue s.maxReviewQueue]);
names=["capture","network upload","AI processing","ophthalmologist review"]; name=names(i);
end
