function result = screenFundusImage(imageInput, varargin)
%SCREENFUNDUSIMAGE Main safe, end-to-end DR screening entry point.
% result=screenFundusImage(fileOrImage,'GenerateReport',false)
% Legacy: result=screenFundusImage(net,image,cfg) returns classifier output only.
if nargin>=3 && ~ischar(imageInput) && ~isstring(imageInput) && isstruct(varargin{2})
    result=runClassifier(imageInput,varargin{1},varargin{2}); return
end
p=inputParser; addParameter(p,'GenerateReport',true); addParameter(p,'Config',struct()); parse(p,varargin{:}); opt=p.Results;
root=fileparts(mfilename('fullpath'));
if isempty(fieldnames(opt.Config)), cfg=jsondecode(fileread(fullfile(root,'prototypeConfig.json'))); else, cfg=opt.Config; end
if ischar(imageInput)||isstring(imageInput), imageFile=string(imageInput); if ~isfile(imageFile), error('screenFundusImage:MissingImage','Image file not found: %s',imageFile); end, original=imread(imageFile); else, imageFile="in_memory.png"; original=imageInput; end
validateImage(original); quality=checkImageQuality(original,cfg);
result=struct('imageFile',imageFile,'quality',quality,'status',"OK",'generatedAt',datetime('now'));
if quality.status=="REJECT"
    result.status="UNGRADABLE"; result.recaptureFeedback=recaptureFeedback(quality); result.auditTrail=["Quality gate rejected image."; result.recaptureFeedback];
    if opt.GenerateReport, result.report=buildUngradableReport(imageFile,original,quality,cfg); end
    return
end
used=original; if quality.isBorderline, used=enhanceFundusImage(original); quality.postEnhancement=checkImageQuality(used,cfg); end
net=loadONNXModelCached(fullfile(root,cfg.classifierModel)); classifier=runClassifier(net,used,cfg);
lesions.microaneurysm=runLesionModel(fullfile(root,cfg.lesionModels.microaneurysm),original,cfg,"microaneurysm");
lesions.hemorrhage=runLesionModel(fullfile(root,cfg.lesionModels.hemorrhage),original,cfg,"hemorrhage");
lesions.exudate=runLesionModel(fullfile(root,cfg.lesionModels.exudate),original,cfg,"exudate");
structures=segmentRetinalStructures(original,quality);
macula=assessMacularInvolvement(structures,lesions.exudate,quality,size(original));
grading=gradeDiabetesRetinopathyViaRules(classifier,lesions,structures,cfg);
cam=computeGradCAM(net,used,classifier.predictedGrade+1,cfg);
result=classifier; result.imageFile=imageFile; result.status="REVIEW_REQUIRED"; result.quality=quality; result.usedImage=used; result.lesionEvidence=lesions; result.structures=structures; result.macularAssessment=macula; result.gradcam=cam; result.finalGrade=grading;
result.screeningCategory=ternary(grading.referable,"REFERABLE_DR_SCREENING","NON_REFERABLE_SCREENING");
result.uncertainty=ternary(grading.uncertain,"Classifier/rule evidence disagreement or unavailable lesion model; ophthalmologist review required.","Research screening output; ophthalmologist review required.");
result.auditTrail=[grading.auditTrail; "Macular assessment: "+macula.status+". "+macula.message; "Grad-CAM: "+cam.message];
if opt.GenerateReport, result.report=buildAnnotatedReport(char(imageFile),original,used,quality,result,lesions,structures,cam,cfg); end
end

function result=runClassifier(net,img,cfg)
validateImage(img); if ndims(img)==2,img=repmat(img,1,1,3);end
x=im2single(imresize(img,cfg.classifier.inputSize)); x=(x-reshape(single(cfg.classifier.mean),1,1,3))./reshape(single(cfg.classifier.std),1,1,3);
try, s=predict(net,dlarray(x,"SSC")); catch, s=predict(net,dlarray(reshape(x,size(x,1),size(x,2),3,1),"SSCB")); end
z=double(extractScores(s)); z=z(:); if numel(z)~=numel(cfg.classifier.classes), error('screenFundusImage:Output','Expected %d classifier scores, got %d.',numel(cfg.classifier.classes),numel(z)); end
T=max(double(cfg.classifier.temperature),.05); p=softmax(z/T); [c,i]=max(p); r=sum(p(cfg.classifier.referableGrades+1));
result=struct('probabilities',p,'logits',z,'predictedGrade',i-1,'predictedClass',string(cfg.classifier.classes(i)),'confidence',c,'uncalibratedConfidence',max(softmax(z)),'referableProbability',r,'referable',r>=cfg.classifier.referableThreshold,'temperature',T,'inputImage',x);
end
function validateImage(x), if ~isnumeric(x)||isempty(x)||any(~isfinite(double(x(:))))||~(ndims(x)==2||(ndims(x)==3&&size(x,3)==3)), error('screenFundusImage:Input','Expected nonempty finite grayscale or RGB image.');end,end
function x=extractScores(a), if isa(a,'dlarray'),x=gather(extractdata(a));elseif isnumeric(a),x=a;elseif iscell(a),x=extractScores(a{1});elseif isstruct(a), f=fieldnames(a);x=extractScores(a.(f{1}));else,error('screenFundusImage:Output','Unsupported output.');end,end
function p=softmax(z),z=z-max(z);p=exp(z);p=p/sum(p);end
function s=ternary(c,a,b),if c,s=a;else,s=b;end,end
function f=recaptureFeedback(q), f="Recapture guidance: "; if isempty(q.reasons),f=f+"center retina and verify focus.";else,f=f+strjoin(q.reasons,", ")+". Improve focus/illumination and ensure adequate retinal field.";end,end
function report=buildUngradableReport(imageFile,original,quality,cfg)
empty=struct('predictedGrade',NaN,'predictedClass',"Ungradable",'confidence',NaN,'referableProbability',NaN,'referable',false);
L=struct('microaneurysm',blankLesion(),'hemorrhage',blankLesion(),'exudate',blankLesion()); S=struct('opticDiscCentroid',[NaN NaN],'foveaCentroid',[NaN NaN],'vesselMask',false(size(original,1),size(original,2)),'vesselDensity',NaN,'neovascularizationSuspicious',false); C=struct('success',false,'map',[],'message',"Not run: image ungradeable.");
report=buildAnnotatedReport(char(imageFile),original,original,quality,empty,L,S,C,cfg);
end
function L=blankLesion(),L=struct('mask',false(256),'present',false,'areaPercent',0,'subpixelCentroids',zeros(0,2),'modelUsed',false);end
