%% main_DR_Screening
% Human-in-the-loop rural diabetic retinopathy screening prototype.
clear; clc; close all;
rootDir=fileparts(mfilename("fullpath"));
addpath(rootDir); addpath(fullfile(rootDir,"validation")); addpath(fullfile(rootDir,"simulink"));
cfg=jsondecode(fileread(fullfile(rootDir,"prototypeConfig.json")));

modelFile=fullfile(rootDir,cfg.classifierModel);
lesionRoot=fullfile(rootDir,"models");
if ~isfile(modelFile), error("Classifier model missing: %s",modelFile); end

fprintf("Loading DR model...\n");
net=loadONNXModelCached(modelFile);
fprintf("Loaded: %s\n",modelFile);

[file,path]=uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff','Fundus Images'},'Select a Fundus Image');
if isequal(file,0), fprintf("No image selected.\n"); return; end
imageFile=fullfile(path,file);
original=imread(imageFile);

quality=checkImageQuality(original,cfg);
fprintf("\nQuality: %s | score=%.3f | sharp=%.6g | contrast=%.3f | FOV=%.3f\n",quality.status,quality.score,quality.sharpness,quality.contrast,quality.fovFraction);

if quality.status=="REJECT"
    fprintf("RECAPTURE: %s\n",quality.message);
    fprintf("Suggested action: refocus, center the retina, improve illumination, or recapture with sufficient field of view.\n");
    return;
end

usedImage=original;
if quality.isBorderline
    usedImage=enhanceFundusImage(original);
    post=checkImageQuality(usedImage,cfg);
    fprintf("Post-enhancement quality: %s | score=%.3f\n",post.status,post.score);
    if post.status=="REJECT"
        fprintf("RECAPTURE after unsuccessful enhancement: %s\n",post.message);
        return;
    end
    quality.postEnhancement=post;
end

result=screenFundusImage(net,usedImage,cfg);

% Lesion models intentionally use the original RGB image and their own 256x256 preprocessing.
lesionCfg=cfg;
lesions.microaneurysm=runLesionModel(fullfile(lesionRoot,"microaneurysm_model.onnx"),original,lesionCfg,"microaneurysm");
lesions.hemorrhage=runLesionModel(fullfile(lesionRoot,"hemorrhage_model.onnx"),original,lesionCfg,"hemorrhage");
lesions.exudate=runLesionModel(fullfile(lesionRoot,"exudate_model.onnx"),original,lesionCfg,"exudate");

structures=segmentRetinalStructures(original,quality);
cam=computeGradCAM(net,usedImage,result.predictedGrade+1,cfg);

fprintf("\nDR Grade: %d (%s)\n",result.predictedGrade,result.predictedClass);
fprintf("Confidence: %.2f%%\nReferable probability: %.2f%%\nDecision: %s\n",100*result.confidence,100*result.referableProbability,ternary(result.referable,"REFER TO OPHTHALMOLOGIST","ROUTINE/FOLLOW-UP PATHWAY"));
fprintf("Lesion evidence — MA %.3f%%, HE %.3f%%, EX %.3f%%\n",lesions.microaneurysm.areaPercent,lesions.hemorrhage.areaPercent,lesions.exudate.areaPercent);

% Optional validation-trained evidence fusion. Disabled until a locked validation set has fitted fusionModel.
if isfield(cfg,"fusion") && cfg.fusion.enabled && isfile(fullfile(rootDir,cfg.fusion.modelFile))
    S=load(fullfile(rootDir,cfg.fusion.modelFile),"fusionModel");
    [fusedP,~]=fuseReferableEvidence(result.referableProbability,lesions,structures,S.fusionModel);
    result.fusedReferableProbability=fusedP;
    result.fusedReferable=fusedP>=cfg.fusion.threshold;
    fprintf("Fused referable probability: %.2f%% (threshold %.2f)\n",100*fusedP,cfg.fusion.threshold);
else
    result.fusedReferableProbability=[]; result.fusedReferable=[];
end

fprintf("Grad-CAM: %s\n",cam.message);

report = buildAnnotatedReport(imageFile,original,usedImage,quality, ...
result,lesions,structures,cam,cfg);

result.lesionEvidence = lesions;
result.structures = structures;
result.gradcam = cam;
result.report = report;

save(fullfile(rootDir,'results', ...
[report.baseName '_screening_result.mat']), ...
'result','quality','report');

fprintf('\nReport written to: %s\n',report.pdfFile);

function out=ternary(c,a,b)
    if c
        out=a;
    else
        out=b;
    end
end
