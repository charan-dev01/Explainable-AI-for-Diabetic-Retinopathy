function outTable=batchScreeningFolder(imageDir,outputCsv)
    %BATCHSCREENINGFOLDER Run the screening pipeline over a folder of fundus images.
    rootDir=fileparts(mfilename("fullpath"));
    cfg=jsondecode(fileread(fullfile(rootDir,"prototypeConfig.json")));
    net=loadONNXModelCached(fullfile(rootDir,cfg.classifierModel));
    files=[dir(fullfile(imageDir,"*.jpg"));dir(fullfile(imageDir,"*.jpeg"));dir(fullfile(imageDir,"*.png"));dir(fullfile(imageDir,"*.tif"));dir(fullfile(imageDir,"*.tiff"))];
    rows=cell(numel(files),7);
    for i=1:numel(files)
        filePath=fullfile(files(i).folder,files(i).name);
        try
            original=imread(filePath); q=checkImageQuality(original,cfg); used=original;
            if q.status=="BORDERLINE", used=enhanceFundusImage(original); end
            if q.status=="REJECT"
                rows(i,:)={files(i).name,string(q.status),NaN,"UNGRADABLE",NaN,NaN,q.message}; continue;
            end
            r=screenFundusImage(net,used,cfg);
            rows(i,:)={files(i).name,string(q.status),r.predictedGrade,char(r.predictedClass),r.confidence,r.referableProbability,"OK"};
        catch ME
            rows(i,:)={files(i).name,"ERROR",NaN,"ERROR",NaN,NaN,string(ME.message)};
        end
    end
    outTable=cell2table(rows,"VariableNames",{'Image','QualityStatus','DRGrade','Class','Confidence','ReferableProbability','Message'});
    if nargin>1 && strlength(string(outputCsv))>0
        writetable(outTable,outputCsv);
    end
    disp(outTable);
end
