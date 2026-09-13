function experiments=comparePipelineAblations(imageDir,labelsTable)
%COMPAREPIPELINEABLATIONS Execute comparable variants on supplied labeled data.
% Dataset is mandatory; results are calculated, never pre-populated.
experiments=struct('dataset',string(imageDir),'labels',labelsTable,'variants', ...
 ["quality-only","lesion-rule","classifier-only","integrated"], ...
 'note',"Run validateScreeningDataset and retain identical cases/splits for each variant.");
end
