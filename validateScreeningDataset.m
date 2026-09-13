function metrics = validateScreeningDataset(imageDir, labelsTable, varargin)
%VALIDATESCREENINGDATASET Run locked labeled-image validation without claims.
p=inputParser; addParameter(p,'OutputFile',""); parse(p,varargin{:}); o=p.Results;
required={'Image','Grade'}; if ~all(ismember(required,labelsTable.Properties.VariableNames)), error('validateScreeningDataset:Labels','Table requires Image and zero-based Grade columns.'); end
pred=nan(height(labelsTable),1); ref=nan(height(labelsTable),1); failures=strings(height(labelsTable),1);
for i=1:height(labelsTable), try
 r=screenFundusImage(fullfile(imageDir,string(labelsTable.Image(i))),'GenerateReport',false); pred(i)=r.finalGrade.level; ref(i)=r.referableProbability;
 catch ME, failures(i)=string(ME.message); end, end
ok=isfinite(pred); cm=confusionmat(labelsTable.Grade(ok),pred(ok),'Order',0:4);
y=labelsTable.Grade(ok)>=2; yh=pred(ok)>=2; metrics=struct('nAttempted',height(labelsTable),'nProcessed',sum(ok),'confusionMatrix',cm,'sensitivity',safeRate(sum(yh&y),sum(y)),'specificity',safeRate(sum(~yh&~y),sum(~y)),'failures',failures,'note',"Measured values require independent, patient-level locked data and review of exclusions.");
if strlength(string(o.OutputFile))>0, save(char(o.OutputFile),'metrics'); end
end
function x=safeRate(a,b), if b==0,x=NaN;else,x=a/b;end,end
