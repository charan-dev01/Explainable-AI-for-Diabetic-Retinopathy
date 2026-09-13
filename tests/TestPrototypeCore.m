classdef TestPrototypeCore < matlab.unittest.TestCase
    methods(Test)
        function qualityRejectsInvalidField(testCase)
            cfg=jsondecode(fileread(fullfile(fileparts(fileparts(mfilename('fullpath'))),'prototypeConfig.json')));
            q=checkImageQuality(zeros(128,128,3,'uint8'),cfg);
            testCase.verifyEqual(q.status,"REJECT");
        end
        function ruleGradingHasAuditTrail(testCase)
            c=struct('predictedGrade',0,'predictedClass',"No DR");
            l=struct('microaneurysm',stub(1),'hemorrhage',stub(0),'exudate',stub(0));
            s=struct('neovascularizationStatus',"INDETERMINATE"); cfg=struct();
            g=gradeDiabetesRetinopathyViaRules(c,l,s,cfg);
            testCase.verifyEqual(g.level,1); testCase.verifyNotEmpty(g.auditTrail);
        end
        function calibrationImprovesHeldoutNLL(testCase)
            z=[4 0;0 4;3 0;0 3]; labels=[0;1;1;0]; c=calibrateTemperatureScaling(z,labels);
            testCase.verifyGreaterThan(c.temperature,0); testCase.verifyLessThanOrEqual(c.calibratedNLL,c.uncalibratedNLL+1e-8);
        end
        function capacitySimulationRuns(testCase)
            root=fileparts(fileparts(mfilename('fullpath'))); cfg=jsondecode(fileread(fullfile(root,'prototypeConfig.json')));
            s=simulateScreeningCapacity(cfg,'AnnualPatients',100,'OperatingDays',1,'HoursPerDay',1);
            testCase.verifyEqual(numel(s.timeMinutes),60); testCase.verifyGreaterThan(s.captureCapacity,0);
        end
        function telemedicineWorkflowRuns(testCase)
            root=fileparts(fileparts(mfilename('fullpath'))); addpath(root);
            w=runTelemedicineWorkflow();
            testCase.verifyFalse(w.simulinkRan); testCase.verifyNotEmpty(w.bottleneck);
        end
    end
end
function x=stub(n), x=struct('subpixelCentroids',zeros(n,2),'modelUsed',true); end
