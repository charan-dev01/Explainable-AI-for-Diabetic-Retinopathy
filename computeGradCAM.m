function camResult = computeGradCAM(net, img, classIndex, cfg)
    %COMPUTEGRADCAM Grad-CAM for the supplied imported classifier.
    % Uses the last 2-D convolutional layer exposed by the dlnetwork.
    arguments
        net
        img
        classIndex (1,1) double {mustBeInteger,mustBePositive}
        cfg struct
    end

    camResult=struct("success",false,"map",[],'layerName',"",'message',"");
    try
        x=im2single(imresize(img,cfg.classifier.inputSize));
        mu=reshape(single(cfg.classifier.mean),1,1,3);
        sd=reshape(single(cfg.classifier.std),1,1,3);
        x=(x-mu)./sd;
        dlX=dlarray(x,"SSC");

        if ~isa(net,"dlnetwork")
            camResult.message="Imported network is not a dlnetwork; Grad-CAM not available.";
            return;
        end
        layers=net.Layers;
        convIdx=find(arrayfun(@(L) isa(L,"nnet.cnn.layer.Convolution2DLayer"),layers));
        if isempty(convIdx)
            camResult.message="No 2-D convolution layer exposed by imported network.";
            return;
        end
        targetName=string(layers(convIdx(end)).Name);
        % Prefer MATLAB's native gradCAM implementation when available.
        % It handles the imported dlnetwork graph and layer/output paths for the
        % current MATLAB release.
        try
            [cam,featureLayer,reductionLayer]=gradCAM(net,dlX,classIndex, ...
            FeatureLayer=targetName, ...
            ReductionLayer=string(net.OutputNames{1}));
            if isa(cam,"dlarray")
                cam=gather(extractdata(cam));
            else
                cam=gather(cam);
            end
            cam=squeeze(cam);
            if ndims(cam)~=2
                error("computeGradCAM:NativeCAMShape","Native gradCAM returned size %s.",mat2str(size(cam)));
            end
            cam=mat2gray(cam);
            cam=imresize(cam,[size(img,1),size(img,2)],"Method","bilinear");
            cam=imgaussfilt(cam,2);
            camResult=struct("success",true,"map",cam, ...
            "layerName",string(featureLayer), ...
            "reductionLayer",string(reductionLayer), ...
            "message","Grad-CAM generated using MATLAB gradCAM");
            return;
        catch nativeME
            nativeMessage=string(nativeME.message);
        end

        outputName=string(net.OutputNames{1});
        [featureMap, logits]=dlfeval(@gradientsForCAM,net,dlX,targetName,outputName,classIndex);
        featureMap=gather(extractdata(featureMap));
        grads=gather(extractdata(logits));

        featureMap=squeeze(featureMap);
        if ndims(featureMap)~=3
            error("Unexpected feature-map dimensions: %s",mat2str(size(featureMap)));
        end
        % gradientsForCAM returns d(score)/d(featureMap) in the second output.
        weights=squeeze(mean(mean(grads,1),2));
        if numel(weights)~=size(featureMap,3)
            weights=reshape(weights,1,1,[]);
        else
            weights=reshape(weights,1,1,[]);
        end
        cam=max(0,sum(featureMap.*weights,3));
        cam=mat2gray(cam);
        cam=imresize(cam,[size(img,1),size(img,2)],"Method","bilinear");
        cam=imgaussfilt(cam,2);
        camResult=struct("success",true,"map",cam,"layerName",targetName,"message","Grad-CAM generated");
    catch ME
        camResult.success=false;
        camResult.map=[];
        if exist("nativeMessage","var") && strlength(nativeMessage)>0
            camResult.message="Grad-CAM unavailable for this imported ONNX graph/MATLAB release. Native gradCAM: "+nativeMessage+" | Manual fallback: "+string(ME.message);
        else
            camResult.message="Grad-CAM unavailable for this imported ONNX graph/MATLAB release: "+string(ME.message);
        end
    end
end

function [activations,gradient]=gradientsForCAM(net,dlX,targetName,outputName,classIndex)
    % R2025a+ accepts a string array for Outputs. Older releases accept a cell
    % array of character vectors, so use the latter for broad compatibility.
    outputs={char(targetName),char(outputName)};
    [activations,logits]=forward(net,dlX,"Outputs",outputs);
    score=logits(classIndex);
    gradient=dlgradient(score,activations,"RetainData",true);
end
