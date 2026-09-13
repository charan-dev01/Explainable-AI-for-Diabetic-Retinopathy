function grade = gradeDiabetesRetinopathyViaRules(classifier, lesions, structures, cfg)
%GRADEDIABETESRETINOPATHYVIARULES
% Research screening fusion layer.
%
% The classifier prediction is the baseline grade.
% Lesion evidence may increase the grade when supported.
% Neovascularization may escalate to proliferative DR only when
% explicitly marked suspicious.
%
% This is NOT a clinical diagnostic standard.

    % Safe defaults
    if ~isfield(cfg,'grading')
        cfg.grading = struct();
    end

    if ~isfield(cfg.grading,'severeHemorrhageComponents')
        cfg.grading.severeHemorrhageComponents = 20;
    end

    % Evidence counts
    maN = getRegionCount(lesions,'microaneurysm');
    heN = getRegionCount(lesions,'hemorrhage');
    exN = getRegionCount(lesions,'exudate');

    % Structural evidence
    nv = false;
    if isfield(structures,'neovascularizationStatus')
        nv = strcmpi(string(structures.neovascularizationStatus),"SUSPICIOUS");
    end

    % -------------------------------------------------------------
    % 1. Start from the actual classifier prediction.
    % -------------------------------------------------------------
    classifierLevel = round(double(classifier.predictedGrade));
    classifierLevel = max(0,min(4,classifierLevel));

    level = classifierLevel;
    rationale = "Classifier prediction retained as baseline.";

    % -------------------------------------------------------------
    % 2. Strong structural evidence can escalate to Grade 4.
    % -------------------------------------------------------------
    if nv
        level = max(level,4);
        rationale = "Possible neovascularization supports escalation to proliferative DR screening.";
    end

    % -------------------------------------------------------------
    % 3. Hemorrhage burden can escalate to severe screening.
    % -------------------------------------------------------------
    if heN >= cfg.grading.severeHemorrhageComponents
        level = max(level,3);

        if classifierLevel < 3
            rationale = "High hemorrhage burden escalated the classifier baseline to severe screening.";
        end
    end

    % -------------------------------------------------------------
    % 4. Clear lesion evidence supports at least moderate screening.
    % -------------------------------------------------------------
    if heN > 0 || exN > 0 || maN >= 5
        level = max(level,2);

        if classifierLevel < 2
            rationale = "Retinal lesion evidence escalated the classifier baseline to moderate screening.";
        end
    end

    % -------------------------------------------------------------
    % 5. Microaneurysm-only evidence supports at least mild screening.
    % -------------------------------------------------------------
    if maN > 0
        level = max(level,1);

        if classifierLevel == 0
            rationale = "Microaneurysm evidence escalated the classifier baseline to mild screening.";
        end
    end

    % Clamp final grade.
    level = max(0,min(4,level));

    % Grade names
    levelNames = [ ...
        "No DR", ...
        "Mild NPDR", ...
        "Moderate NPDR", ...
        "Severe NPDR", ...
        "Proliferative DR"];

    % Agreement
    agree = classifierLevel == level;

    % Lesion model availability
    lesionModelsAvailable = true;

    if isfield(lesions,'microaneurysm') && ...
            isfield(lesions.microaneurysm,'modelUsed')
        lesionModelsAvailable = lesionModelsAvailable && ...
            logical(lesions.microaneurysm.modelUsed);
    end

    if isfield(lesions,'hemorrhage') && ...
            isfield(lesions.hemorrhage,'modelUsed')
        lesionModelsAvailable = lesionModelsAvailable && ...
            logical(lesions.hemorrhage.modelUsed);
    end

    if isfield(lesions,'exudate') && ...
            isfield(lesions.exudate,'modelUsed')
        lesionModelsAvailable = lesionModelsAvailable && ...
            logical(lesions.exudate.modelUsed);
    end

    uncertain = ~agree || ~lesionModelsAvailable;

    % Final result
    grade = struct( ...
        'level',level, ...
        'label',levelNames(level+1), ...
        'referable',level >= 2, ...
        'classifierLevel',classifierLevel, ...
        'classifierLabel',classifier.predictedClass, ...
        'agreement',agree, ...
        'uncertain',uncertain, ...
        'auditTrail',strings(0,1), ...
        'rationale',rationale);

    grade.auditTrail = [ ...
        "Detected evidence: MA=" + maN + ...
        ", HE=" + heN + ...
        ", EX=" + exN + ...
        ", NV=" + string(nv);

        "Classifier baseline: level " + classifierLevel + ...
        " (" + classifier.predictedClass + ").";

        "Rule interpretation: " + rationale;

        "Final screening grade: level " + level + ...
        " (" + grade.label + ")."];
end


function n = getRegionCount(lesions,field)
% Safely count lesion regions.

    n = 0;

    if ~isfield(lesions,field)
        return
    end

    L = lesions.(field);

    if isfield(L,'subpixelCentroids') && ...
            ~isempty(L.subpixelCentroids)

        n = size(L.subpixelCentroids,1);
    end
end