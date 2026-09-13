%% main_DR_Screening
% Human-in-the-loop entry script. screenFundusImage owns the full workflow.
clear; clc; close all;
rootDir=fileparts(mfilename('fullpath')); addpath(rootDir); addpath(fullfile(rootDir,'simulink'));
[file,path]=uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff','Fundus images'},'Select a fundus image');
if isequal(file,0), fprintf('No image selected.\n'); return; end
result=screenFundusImage(fullfile(path,file));
fprintf('\nStatus: %s\n',result.status);
if result.status=="UNGRADABLE"
    fprintf('%s\n',result.recaptureFeedback);
else
    fprintf('Evidence-rule grade: %d (%s)\n',result.finalGrade.level,result.finalGrade.label);
    fprintf('Screening category: %s | calibrated confidence %.1f%%\n',result.screeningCategory,100*result.confidence);
    fprintf('Macular assessment: %s\n',result.macularAssessment.status);
    fprintf('Report: %s\n',result.report.pdfFile);
end
