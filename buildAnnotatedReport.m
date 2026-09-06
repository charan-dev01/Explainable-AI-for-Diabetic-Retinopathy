function report = buildAnnotatedReport(imageFile,original,usedImage,quality,result,lesions,structures,cam,cfg)

    % BUILDANNOTATEDREPORT
    % Creates PNG, TXT and PDF screening reports.
    % The PDF is automatically opened after it is created.

    %% Results directory

    resultsDir = fullfile(fileparts(mfilename('fullpath')),'results');

    if ~exist(resultsDir,'dir')
        mkdir(resultsDir);
    end

    [~,base,~] = fileparts(imageFile);

    %% ============================================================
    % CREATE ANNOTATED IMAGE
    % =============================================================

    overlay = usedImage;

    if isempty(overlay)
        overlay = original;
    end

    fig = figure('Visible','off','Color','w','Position',[100 100 1400 850]);

    tiledlayout(2,3,'Padding','compact','TileSpacing','compact');

    % Original
    nexttile;
    imshow(original);
    title('Original');

    % Image used for grading
    nexttile;
    imshow(usedImage);
    title('Image used for grading');

    % Structures
    nexttile;
    imshow(overlay);
    hold on;

    if any(~isnan(structures.opticDiscCentroid))
        plot(structures.opticDiscCentroid(1), ...
        structures.opticDiscCentroid(2), ...
        'r+','MarkerSize',14,'LineWidth',2);
    end

    if any(~isnan(structures.foveaCentroid))
        plot(structures.foveaCentroid(1), ...
        structures.foveaCentroid(2), ...
        'b+','MarkerSize',14,'LineWidth',2);
    end

    visboundaries(structures.vesselMask,'Color','w');

    title('Structures: disc/fovea/vessels');
    hold off;

    % Microaneurysm
    nexttile;

    maMask = resizeMaskForImage( ...
    lesions.microaneurysm.mask, ...
    size(original));

    lesionImage = labeloverlay( ...
    original, ...
    maMask, ...
    'Colormap',[1 0 0], ...
    'Transparency',0.65);

    imshow(lesionImage);

    title(sprintf('Microaneurysm %.3f%% | lesion evidence', ...
    lesions.microaneurysm.areaPercent));

    % Hemorrhage and exudate
    nexttile;

    heMask = resizeMaskForImage( ...
    lesions.hemorrhage.mask, ...
    size(original));

    exMask = resizeMaskForImage( ...
    lesions.exudate.mask, ...
    size(original));

    lesionImage = labeloverlay( ...
    original, ...
    heMask, ...
    'Colormap',[1 0.5 0], ...
    'Transparency',0.65);

    lesionImage = labeloverlay( ...
    lesionImage, ...
    exMask, ...
    'Colormap',[0 1 0], ...
    'Transparency',0.65);

    imshow(lesionImage);

    title('Hemorrhage + exudate | clinical lesion evidence');

    % Grad-CAM
    nexttile;

    if cam.success
        imshow(original);
        hold on;
        imagesc(cam.map,'AlphaData',0.45);
        axis image off;
        title('Grad-CAM');
        hold off;
    else
        imshow(original);
        title('Grad-CAM unavailable');
    end

    % Main title
    sgtitle(sprintf( ...
    'DR Screening | Grade %d: %s | Referable %.1f%%', ...
    result.predictedGrade, ...
    char(result.predictedClass), ...
    100 * result.referableProbability));

    % Bottom information
    annotation(fig,'textbox',[0.02 0.01 0.96 0.06], ...
    'String',sprintf( ...
    'Quality: %s (%.2f) | Confidence: %.1f%% | Review target: %ds | Structure/NV result is research-only', ...
    quality.status, ...
    quality.score, ...
    100 * result.confidence, ...
    cfg.report.reviewTargetSeconds), ...
    'EdgeColor','none', ...
    'HorizontalAlignment','center');

    %% ============================================================
    % SAVE PNG
    % =============================================================

    pngFile = fullfile(resultsDir,[base '_screening_report.png']);

    exportgraphics(fig,pngFile,'Resolution',150);

    close(fig);

    %% ============================================================
    % CREATE TXT REPORT
    % =============================================================

    reportText = fullfile(resultsDir,[base '_screening_report.txt']);

    fid = fopen(reportText,'w');

    if fid == -1
        error('Could not create text report.');
    end

    fprintf(fid,'DIABETIC RETINOPATHY SCREENING - RESEARCH PROTOTYPE\n\n');

    fprintf(fid,'Image: %s\n',imageFile);

    fprintf(fid,'Quality: %s (score %.3f)\n', ...
    quality.status,quality.score);

    fprintf(fid,'Quality message: %s\n\n',quality.message);

    fprintf(fid,'DR grade: %d (%s)\n', ...
    result.predictedGrade, ...
    char(result.predictedClass));

    fprintf(fid,'Classifier confidence: %.2f%%\n', ...
    100 * result.confidence);

    fprintf(fid,'Referable probability (grades 2-4): %.2f%%\n', ...
    100 * result.referableProbability);

    fprintf(fid,'Referable decision: %s\n\n', ...
    ternary(result.referable,'REFER','NON-REFER'));

    fprintf(fid,'Class probabilities: ');

    fprintf(fid,'%.4f ',result.probabilities);

    fprintf(fid,'\n\n');

    fprintf(fid,'Lesion evidence:\n');

    fprintf(fid,'  Microaneurysm: %s, area %.4f%%, components %d\n', ...
    ternary(lesions.microaneurysm.present,'present','not detected'), ...
    lesions.microaneurysm.areaPercent, ...
    size(lesions.microaneurysm.subpixelCentroids,1));

    fprintf(fid,'  Hemorrhage: %s, area %.4f%%, components %d\n', ...
    ternary(lesions.hemorrhage.present,'present','not detected'), ...
    lesions.hemorrhage.areaPercent, ...
    size(lesions.hemorrhage.subpixelCentroids,1));

    fprintf(fid,'  Exudate: %s, area %.4f%%, components %d\n', ...
    ternary(lesions.exudate.present,'present','not detected'), ...
    lesions.exudate.areaPercent, ...
    size(lesions.exudate.subpixelCentroids,1));

    fprintf(fid,'\n');

    fprintf(fid,'Optic disc centroid: [%.1f, %.1f]\n', ...
    structures.opticDiscCentroid(1), ...
    structures.opticDiscCentroid(2));

    fprintf(fid,'Fovea centroid: [%.1f, %.1f]\n', ...
    structures.foveaCentroid(1), ...
    structures.foveaCentroid(2));

    fprintf(fid,'Vessel density: %.4f\n', ...
    structures.vesselDensity);

    fprintf(fid,'NV heuristic: %s\n', ...
    ternary(structures.neovascularizationSuspicious, ...
    'suspicious','not suspicious'));

    fprintf(fid,'\n');

    fprintf(fid,['Clinical safety note: This is a decision-support prototype. ' ...
    'A referral decision must be confirmed by a qualified eye-care ' ...
    'professional, especially for ungradable or discordant cases.\n']);

    fclose(fid);

    %% ============================================================
    % CREATE PDF
    % =============================================================

    pdfFile = fullfile(resultsDir,[base '_screening_report.pdf']);

    pdfFig = figure( ...
    'Visible','off', ...
    'Color','white', ...
    'Units','inches', ...
    'Position',[0 0 8.5 11]);

    %% PDF title

    annotation(pdfFig,'textbox',[0.05 0.945 0.90 0.035], ...
    'String','DIABETIC RETINOPATHY SCREENING REPORT', ...
    'EdgeColor','none', ...
    'Color',[0 0 0], ...
    'HorizontalAlignment','center', ...
    'FontSize',18, ...
    'FontWeight','bold');

    annotation(pdfFig,'textbox',[0.05 0.915 0.90 0.025], ...
    'String','Research Prototype', ...
    'EdgeColor','none', ...
    'Color',[0.2 0.2 0.2], ...
    'HorizontalAlignment','center', ...
    'FontSize',10);

    %% PDF image

    imgAx = axes( ...
    'Parent',pdfFig, ...
    'Position',[0.06 0.49 0.88 0.40]);

    imshow(pngFile,'Parent',imgAx);

    axis(imgAx,'off');

    %% PDF text

    summary1 = sprintf('Image: %s\n',imageFile);

    summary2 = sprintf('Quality: %s (%.3f)\n', ...
    quality.status,quality.score);

    summary3 = sprintf('Quality message: %s\n',quality.message);

    summary4 = sprintf('DR Grade: %d (%s)\n', ...
    result.predictedGrade,char(result.predictedClass));

    summary5 = sprintf('Classifier confidence: %.2f%%\n', ...
    100 * result.confidence);

    summary6 = sprintf('Referable probability: %.2f%%\n', ...
    100 * result.referableProbability);

    summary7 = sprintf('Referable decision: %s\n\n', ...
    ternary(result.referable,'REFER','NON-REFER'));

    lesion1 = sprintf('Microaneurysm: %s | Area %.4f%% | Components %d\n', ...
    ternary(lesions.microaneurysm.present,'Present','Not detected'), ...
    lesions.microaneurysm.areaPercent, ...
    size(lesions.microaneurysm.subpixelCentroids,1));

    lesion2 = sprintf('Hemorrhage: %s | Area %.4f%% | Components %d\n', ...
    ternary(lesions.hemorrhage.present,'Present','Not detected'), ...
    lesions.hemorrhage.areaPercent, ...
    size(lesions.hemorrhage.subpixelCentroids,1));

    lesion3 = sprintf('Exudate: %s | Area %.4f%% | Components %d\n\n', ...
    ternary(lesions.exudate.present,'Present','Not detected'), ...
    lesions.exudate.areaPercent, ...
    size(lesions.exudate.subpixelCentroids,1));

    structure1 = sprintf('Optic disc centroid: [%.1f, %.1f]\n', ...
    structures.opticDiscCentroid(1), ...
    structures.opticDiscCentroid(2));

    structure2 = sprintf('Fovea centroid: [%.1f, %.1f]\n', ...
    structures.foveaCentroid(1), ...
    structures.foveaCentroid(2));

    structure3 = sprintf('Vessel density: %.4f\n', ...
    structures.vesselDensity);

    structure4 = sprintf('NV heuristic: %s\n\n', ...
    ternary(structures.neovascularizationSuspicious, ...
    'Suspicious','Not suspicious'));

    safetyText = ['CLINICAL SAFETY NOTE: This is a decision-support prototype. ' ...
    'A referral decision must be confirmed by a qualified eye-care professional.'];

    pdfText = [ ...
    'SCREENING SUMMARY' newline ...
    summary1 ...
    summary2 ...
    summary3 ...
    summary4 ...
    summary5 ...
    summary6 ...
    summary7 ...
    'LESION EVIDENCE' newline ...
    lesion1 ...
    lesion2 ...
    lesion3 ...
    'STRUCTURE ANALYSIS' newline ...
    structure1 ...
    structure2 ...
    structure3 ...
    structure4 ...
    safetyText];

    annotation(pdfFig,'textbox',[0.06 0.045 0.88 0.42], ...
    'String',pdfText, ...
    'EdgeColor',[0.7 0.7 0.7], ...
    'Color',[0 0 0], ...
    'FontSize',9, ...
    'VerticalAlignment','top', ...
    'Interpreter','none');

    %% Export PDF

    exportgraphics(pdfFig,pdfFile, ...
    'ContentType','image', ...
    'Resolution',150);

    close(pdfFig);

    %% ============================================================
    % RETURN REPORT
    % =============================================================

    report = struct( ...
    'pngFile',pngFile, ...
    'textFile',reportText, ...
    'pdfFile',pdfFile, ...
    'baseName',base);

    %% ============================================================
    % OPEN PDF AUTOMATICALLY
    % =============================================================

    if isfile(pdfFile)

        fprintf('\nPDF report created:\n%s\n',pdfFile);

        if ispc
            winopen(pdfFile);
        else
            open(pdfFile);
        end

    end

end


%% ============================================================
% HELPER: TERNARY
% ============================================================

function out = ternary(condition,valueTrue,valueFalse)

    if condition
        out = valueTrue;
    else
        out = valueFalse;
    end

end


%% ============================================================
% HELPER: RESIZE MASK
% ============================================================

function maskOut = resizeMaskForImage(maskIn,imageSize)

    if isempty(maskIn)

        maskOut = false(imageSize(1),imageSize(2));

        return;

    end

    maskIn = logical(maskIn);

    if isequal(size(maskIn),imageSize(1:2))

        maskOut = maskIn;

    else

        maskOut = imresize(maskIn,imageSize(1:2),'nearest');

    end

end
