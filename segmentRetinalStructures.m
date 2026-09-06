function structures = segmentRetinalStructures(image, quality)
    %SEGMENTRETINALSTRUCTURES Research-stage retinal structure extraction.
    % Produces vessel mask and approximate optic-disc/fovea locations.
    if ndims(image)==2, image=repmat(image,1,1,3); end
        rgb=im2double(im2uint8(image));
        [h,w,~]=size(rgb);
        if nargin<2 || ~isstruct(quality) || ~isfield(quality,"retinaMask")
            g=rgb2gray(rgb); fov=g>0.04; fov=imfill(bwareafilt(imclose(fov,strel("disk",max(3,round(min(h,w)/80)))),1),"holes");
        else
            fov=quality.retinaMask;
        end

        % Vessel segmentation: dark-ridge response on the green channel.
        g=rgb(:,:,2);
        bg=imgaussfilt(g,max(5,round(min(h,w)/35)));
        ridge=mat2gray(bg-g);
        ridge(~fov)=0;
        threshold=graythresh(ridge(fov));
        ves=imbinarize(ridge,threshold*0.9);
        ves=ves & fov;
        ves=bwareaopen(ves,max(8,round(0.00003*h*w)));
        ves=imopen(ves,strel("disk",1));

        % Optic disc: search for bright compact regions, suppressing the field edge.
        bright=mat2gray(rgb(:,:,1)+rgb(:,:,2)+rgb(:,:,3));
        bright=bright.*fov;
        bright=imgaussfilt(bright,max(3,round(min(h,w)/70)));
        cut=prctile(bright(fov),98.5);
        discMask=bright>=cut;
        discMask=bwareafilt(discMask,1);
        if nnz(discMask)<20
            opticDisc=[NaN NaN]; opticDiscRadius=NaN;
        else
            s=regionprops(discMask,"Centroid","EquivDiameter","Area");
            opticDisc=s.Centroid;
            opticDiscRadius=s.EquivDiameter/2;
        end

        % Fovea is deliberately labeled an approximation: temporal to disc, darker than local background.
        if any(isnan(opticDisc))
            fovea=[NaN NaN];
        else
            dirSign=sign((w/2)-opticDisc(1));
            if dirSign==0, dirSign=1; end
                dx=0.28*w*dirSign;
                dy=0;
                foveaGuess=[opticDisc(1)+dx, opticDisc(2)+dy];
                [X,Y]=meshgrid(1:w,1:h);
                sigma=0.12*w;
                roi=exp(-((X-foveaGuess(1)).^2+(Y-foveaGuess(2)).^2)/(2*sigma^2)).*fov;
                darkness=1-mat2gray(rgb2gray(rgb));
                score=roi.*darkness;
                [~,ix]=max(score(:));
                [fy,fx]=ind2sub([h,w],ix);
                fovea=[fx fy];
            end

            % Neovascularization: screening heuristic based on vessel density and fragmented/tortuous networks.
            edgeRing=imdilate(fov,strel("disk",max(2,round(min(h,w)/90)))) & ~imerode(fov,strel("disk",max(2,round(min(h,w)/18))));
            peripheralVesselDensity=nnz(ves & edgeRing)/max(nnz(edgeRing),1);
            branchProxy=nnz(bwmorph(ves,"branchpoints"))/max(nnz(ves),1);
            suspiciousNV=(peripheralVesselDensity>0.08 && branchProxy>0.001);

            structures=struct();
            structures.vesselMask=ves;
            structures.vesselDensity=nnz(ves&fov)/max(nnz(fov),1);
            structures.opticDiscCentroid=opticDisc;
            structures.opticDiscRadius=opticDiscRadius;
            structures.opticDiscMask=discMask;
            structures.foveaCentroid=fovea;
            structures.neovascularizationSuspicious=suspiciousNV;
            structures.neovascularizationNote="Heuristic only; no dedicated NV model was supplied.";
            structures.foveaNote="Approximate location; validate against IDRiD fovea annotations before clinical use.";
        end
