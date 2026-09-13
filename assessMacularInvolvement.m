function macula = assessMacularInvolvement(structures, exudate, quality, imageSize)
%ASSESSMACULARINVOLVEMENT Exudate-proximity screening assessment, not CSME diagnosis.
macula=struct('status',"INDETERMINATE",'message',"Insufficient anatomical or quality evidence.", ...
    'distancePixels',NaN,'macularRadiusPixels',NaN,'exudateNearMacula',false);
if quality.status=="REJECT" || any(~isfinite(structures.foveaCentroid)), return; end
scale=min(imageSize(1:2))/256;
fovea=structures.foveaCentroid/scale;
centroids=exudate.subpixelCentroids;
if isempty(centroids)
    macula.status="NOT_DETECTED"; macula.message="No exudate segmentation evidence in the approximate macular region."; return;
end
d=hypot(centroids(:,1)-fovea(1),centroids(:,2)-fovea(2))*scale;
macula.distancePixels=min(d); macula.macularRadiusPixels=0.12*min(imageSize(1:2));
macula.exudateNearMacula=macula.distancePixels<=macula.macularRadiusPixels;
if macula.exudateNearMacula
    macula.status="DETECTED"; macula.message="Exudate evidence lies within the approximate macular screening region; clinician review required.";
else
    macula.status="NOT_DETECTED"; macula.message="Exudate evidence is outside the approximate macular screening region.";
end
end
