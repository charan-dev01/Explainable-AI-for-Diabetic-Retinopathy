function outTable=batchScreeningFolder(imageDir,outputCsv)
%BATCHSCREENINGFOLDER Resilient integrated batch screening with per-image logs.
if ~isfolder(imageDir), error('batchScreeningFolder:Folder','Image directory not found: %s',imageDir); end
files=[dir(fullfile(imageDir,'*.jpg'));dir(fullfile(imageDir,'*.jpeg'));dir(fullfile(imageDir,'*.png'));dir(fullfile(imageDir,'*.tif'));dir(fullfile(imageDir,'*.tiff'))];
rows=cell(numel(files),8);
for i=1:numel(files)
    f=fullfile(files(i).folder,files(i).name);
    try
        r=screenFundusImage(f,'GenerateReport',true);
        if r.status=="UNGRADABLE", rows(i,:)={files(i).name,string(r.status),NaN,"UNGRADABLE",NaN,NaN,"NO_INFERENCE",r.recaptureFeedback};
        else, rows(i,:)={files(i).name,string(r.quality.status),r.finalGrade.level,r.finalGrade.label,r.confidence,r.referableProbability,r.screeningCategory,r.uncertainty}; end
    catch ME
        rows(i,:)={files(i).name,"ERROR",NaN,"ERROR",NaN,NaN,"FAILED",string(ME.message)};
    end
end
outTable=cell2table(rows,'VariableNames',{'Image','QualityStatus','DRGrade','Class','Confidence','ReferableProbability','ScreeningCategory','Message'});
if nargin>1 && strlength(string(outputCsv))>0, writetable(outTable,outputCsv); end
end
