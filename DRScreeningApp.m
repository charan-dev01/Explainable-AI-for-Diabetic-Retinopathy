classdef DRScreeningApp < handle
    % DRScreeningApp
    % MATLAB R2026a-compatible programmatic UI for the diabetic
    % retinopathy screening prototype.
    %
    % Run:
    %   app = DRScreeningApp;
    %
    % Required project files/functions are the same ones used by
    % main_DR_Screening.m.

    properties
        % Main UI
        UIFigure
        MainGrid
        HeaderPanel
        InputPanel
        ResultsPanel
        ImagePanel
        LesionPanel
        StructurePanel
        FooterPanel

        % Header
        StatusLamp
        StatusLabel

        % Input
        SelectImageButton
        RunButton
        FileNameLabel
        QualityLabel

        % Image axes
        OriginalAxes
        GradingAxes
        StructuresAxes
        MicroaneurysmAxes
        HemorrhageAxes
        GradCAMAxes

        % Results
        GradeValue
        ConfidenceValue
        ReferableValue
        DecisionValue

        % Lesions / structures
        LesionTable
        OpticDiscLabel
        FoveaLabel
        VesselDensityLabel
        NVLabel

        % Footer
        GeneratePDFButton
        OpenPDFButton
        ClearButton

        % Application state
        SelectedImageFile = ""
        SelectedImage = []
        Net = []
        Config = struct()
        LastResult = []
        LastQuality = []
        LastLesions = []
        LastStructures = []
        LastCAM = []
        LastReport = []
        LastPDF = ""
    end

    methods
        function app = DRScreeningApp
            app.createUI();
        end

        function createUI(app)
            % Main window
            app.UIFigure = uifigure( ...
            'Name','Diabetic Retinopathy Screening', ...
            'Position',[40 40 1450 920], ...
            'Color',[0.96 0.97 0.98]);

            app.UIFigure.CloseRequestFcn = @(src,event)delete(app);

            % Main layout
            app.MainGrid = uigridlayout(app.UIFigure,[5 1]);
            app.MainGrid.RowHeight = {78,155,'1x',145,62};
            app.MainGrid.ColumnWidth = {'1x'};
            app.MainGrid.Padding = [12 12 12 12];
            app.MainGrid.RowSpacing = 10;

            % =========================================================
            % HEADER
            % =========================================================
            app.HeaderPanel = uipanel(app.MainGrid);
            app.HeaderPanel.BorderType = 'none';
            app.HeaderPanel.BackgroundColor = [0.08 0.16 0.24];

            hg = uigridlayout(app.HeaderPanel,[1 2]);
            hg.ColumnWidth = {'1x',220};
            hg.RowHeight = {'1x'};
            hg.Padding = [18 8 18 8];

            titleGrid = uigridlayout(hg,[2 1]);
            titleGrid.Layout.Row = 1;
            titleGrid.Layout.Column = 1;
            titleGrid.RowHeight = {'1x','1x'};
            titleGrid.Padding = [0 0 0 0];

            title = uilabel(titleGrid);
            title.Text = 'DIABETIC RETINOPATHY SCREENING';
            title.FontSize = 21;
            title.FontWeight = 'bold';
            title.FontColor = [1 1 1];
            title.Layout.Row = 1;
            title.Layout.Column = 1;

            sub = uilabel(titleGrid);
            sub.Text = 'Human-in-the-loop retinal image assessment prototype';
            sub.FontSize = 11;
            sub.FontColor = [0.82 0.88 0.93];
            sub.Layout.Row = 2;
            sub.Layout.Column = 1;

            statusGrid = uigridlayout(hg,[1 2]);
            statusGrid.Layout.Row = 1;
            statusGrid.Layout.Column = 2;
            statusGrid.ColumnWidth = {25,'1x'};
            statusGrid.Padding = [0 15 0 15];

            app.StatusLamp = uilamp(statusGrid);
            app.StatusLamp.Layout.Row = 1;
            app.StatusLamp.Layout.Column = 1;

            app.StatusLabel = uilabel(statusGrid);
            app.StatusLabel.Text = 'Ready';
            app.StatusLabel.FontColor = [1 1 1];
            app.StatusLabel.FontWeight = 'bold';
            app.StatusLabel.HorizontalAlignment = 'right';
            app.StatusLabel.Layout.Row = 1;
            app.StatusLabel.Layout.Column = 2;

            % =========================================================
            % INPUT PANEL
            % =========================================================
            app.InputPanel = uipanel(app.MainGrid);
            app.InputPanel.Title = 'Case Input & Image Quality';
            app.InputPanel.FontWeight = 'bold';

            ig = uigridlayout(app.InputPanel,[2 4]);
            ig.RowHeight = {45,45};
            ig.ColumnWidth = {150,'1x',150,'1x'};
            ig.Padding = [12 8 12 8];
            ig.RowSpacing = 8;
            ig.ColumnSpacing = 10;

            app.SelectImageButton = uibutton(ig,'push');
            app.SelectImageButton.Text = 'Select Fundus Image';
            app.SelectImageButton.FontWeight = 'bold';
            app.SelectImageButton.ButtonPushedFcn = @(src,event)app.selectImage();
            app.SelectImageButton.Layout.Row = 1;
            app.SelectImageButton.Layout.Column = 1;

            app.FileNameLabel = uilabel(ig);
            app.FileNameLabel.Text = 'No image selected';
            app.FileNameLabel.FontColor = [0.25 0.30 0.38];
            app.FileNameLabel.Layout.Row = 1;
            app.FileNameLabel.Layout.Column = 2;

            app.RunButton = uibutton(ig,'push');
            app.RunButton.Text = 'RUN SCREENING';
            app.RunButton.FontWeight = 'bold';
            app.RunButton.ButtonPushedFcn = @(src,event)app.runScreening();
            app.RunButton.Layout.Row = 1;
            app.RunButton.Layout.Column = 3;

            app.QualityLabel = uilabel(ig);
            app.QualityLabel.Text = 'Quality: --';
            app.QualityLabel.Layout.Row = 1;
            app.QualityLabel.Layout.Column = 4;

            helpLabel = uilabel(ig);
            helpLabel.Text = 'Select a retinal fundus image, then run the complete screening pipeline.';
            helpLabel.FontColor = [0.35 0.40 0.45];
            helpLabel.Layout.Row = 2;
            helpLabel.Layout.Column = [1 4];

            % =========================================================
            % CENTRAL IMAGE AREA
            % =========================================================
            app.ImagePanel = uipanel(app.MainGrid);
            app.ImagePanel.Title = 'Image Analysis';
            app.ImagePanel.FontWeight = 'bold';

            imageGrid = uigridlayout(app.ImagePanel,[2 3]);
            imageGrid.RowHeight = {'1x','1x'};
            imageGrid.ColumnWidth = {'1x','1x','1x'};
            imageGrid.Padding = [8 8 8 8];
            imageGrid.RowSpacing = 8;
            imageGrid.ColumnSpacing = 8;

            app.OriginalAxes = app.makeAxes(imageGrid,'Original Image',1,1);
            app.GradingAxes = app.makeAxes(imageGrid,'Image Used for Grading',1,2);
            app.StructuresAxes = app.makeAxes(imageGrid,'Retinal Structures',1,3);
            app.MicroaneurysmAxes = app.makeAxes(imageGrid,'Microaneurysm',2,1);
            app.HemorrhageAxes = app.makeAxes(imageGrid,'Hemorrhage + Exudate',2,2);
            app.GradCAMAxes = app.makeAxes(imageGrid,'Grad-CAM',2,3);

            % =========================================================
            % RESULTS + LESION + STRUCTURE AREA
            % =========================================================
            lowerGrid = uigridlayout(app.MainGrid,[1 3]);
            lowerGrid.ColumnWidth = {300,'1x',350};
            lowerGrid.Padding = [0 0 0 0];
            lowerGrid.ColumnSpacing = 10;

            % Results
            app.ResultsPanel = uipanel(lowerGrid);
            app.ResultsPanel.Title = 'Screening Results';
            app.ResultsPanel.FontWeight = 'bold';
            app.ResultsPanel.Layout.Row = 1;
            app.ResultsPanel.Layout.Column = 1;

            rg = uigridlayout(app.ResultsPanel,[4 2]);
            rg.RowHeight = {'1x','1x','1x','1x'};
            rg.ColumnWidth = {135,'1x'};
            rg.Padding = [12 10 12 10];
            rg.RowSpacing = 8;
            rg.ColumnSpacing = 8;

            lbl = uilabel(rg);
            lbl.Text = 'DR Grade';
            lbl.FontWeight = 'bold';
            lbl.Layout.Row = 1;
            lbl.Layout.Column = 1;

            app.GradeValue = uilabel(rg);
            app.GradeValue.Text = '--';
            app.GradeValue.FontSize = 18;
            app.GradeValue.FontWeight = 'bold';
            app.GradeValue.Layout.Row = 1;
            app.GradeValue.Layout.Column = 2;

            lbl = uilabel(rg);
            lbl.Text = 'Confidence';
            lbl.FontWeight = 'bold';
            lbl.Layout.Row = 2;
            lbl.Layout.Column = 1;

            app.ConfidenceValue = uilabel(rg);
            app.ConfidenceValue.Text = '--';
            app.ConfidenceValue.FontSize = 14;
            app.ConfidenceValue.Layout.Row = 2;
            app.ConfidenceValue.Layout.Column = 2;

            lbl = uilabel(rg);
            lbl.Text = 'Referable probability';
            lbl.FontWeight = 'bold';
            lbl.Layout.Row = 3;
            lbl.Layout.Column = 1;

            app.ReferableValue = uilabel(rg);
            app.ReferableValue.Text = '--';
            app.ReferableValue.FontSize = 14;
            app.ReferableValue.Layout.Row = 3;
            app.ReferableValue.Layout.Column = 2;

            lbl = uilabel(rg);
            lbl.Text = 'Decision';
            lbl.FontWeight = 'bold';
            lbl.Layout.Row = 4;
            lbl.Layout.Column = 1;

            app.DecisionValue = uilabel(rg);
            app.DecisionValue.Text = '--';
            app.DecisionValue.FontSize = 13;
            app.DecisionValue.FontWeight = 'bold';
            app.DecisionValue.Layout.Row = 4;
            app.DecisionValue.Layout.Column = 2;

            % Lesions
            app.LesionPanel = uipanel(lowerGrid);
            app.LesionPanel.Title = 'Lesion Evidence';
            app.LesionPanel.FontWeight = 'bold';
            app.LesionPanel.Layout.Row = 1;
            app.LesionPanel.Layout.Column = 2;

            app.LesionTable = uitable(app.LesionPanel);
            app.LesionTable.Position = [8 8 500 112];
            app.LesionTable.ColumnName = {'Finding','Status','Area (%)','Components'};
            app.LesionTable.Data = cell(0,4);

            % Structures
            app.StructurePanel = uipanel(lowerGrid);
            app.StructurePanel.Title = 'Structure Analysis';
            app.StructurePanel.FontWeight = 'bold';
            app.StructurePanel.Layout.Row = 1;
            app.StructurePanel.Layout.Column = 3;

            sg = uigridlayout(app.StructurePanel,[4 2]);
            sg.RowHeight = {'1x','1x','1x','1x'};
            sg.ColumnWidth = {170,'1x'};
            sg.Padding = [10 8 10 8];

            lbl = uilabel(sg,'Text','Optic disc');
            lbl.Layout.Row = 1; lbl.Layout.Column = 1;
            app.OpticDiscLabel = uilabel(sg,'Text','--');
            app.OpticDiscLabel.Layout.Row = 1; app.OpticDiscLabel.Layout.Column = 2;

            lbl = uilabel(sg,'Text','Fovea');
            lbl.Layout.Row = 2; lbl.Layout.Column = 1;
            app.FoveaLabel = uilabel(sg,'Text','--');
            app.FoveaLabel.Layout.Row = 2; app.FoveaLabel.Layout.Column = 2;

            lbl = uilabel(sg,'Text','Vessel density');
            lbl.Layout.Row = 3; lbl.Layout.Column = 1;
            app.VesselDensityLabel = uilabel(sg,'Text','--');
            app.VesselDensityLabel.Layout.Row = 3; app.VesselDensityLabel.Layout.Column = 2;

            lbl = uilabel(sg,'Text','NV suspicious');
            lbl.Layout.Row = 4; lbl.Layout.Column = 1;
            app.NVLabel = uilabel(sg,'Text','--');
            app.NVLabel.Layout.Row = 4; app.NVLabel.Layout.Column = 2;

            % =========================================================
            % FOOTER
            % =========================================================
            app.FooterPanel = uipanel(app.MainGrid);
            app.FooterPanel.BorderType = 'none';

            fg = uigridlayout(app.FooterPanel,[1 4]);
            fg.ColumnWidth = {'1x',160,160,160};
            fg.Padding = [0 5 0 5];
            fg.ColumnSpacing = 10;

            note = uilabel(fg);
            note.Text = 'Clinical decision support prototype — not a substitute for ophthalmologist review.';
            note.FontColor = [0.40 0.44 0.48];
            note.Layout.Row = 1;
            note.Layout.Column = 1;

            app.GeneratePDFButton = uibutton(fg,'push');
            app.GeneratePDFButton.Text = 'Generate PDF';
            app.GeneratePDFButton.ButtonPushedFcn = @(src,event)app.generatePDF();
            app.GeneratePDFButton.Layout.Row = 1;
            app.GeneratePDFButton.Layout.Column = 2;

            app.OpenPDFButton = uibutton(fg,'push');
            app.OpenPDFButton.Text = 'Open PDF';
            app.OpenPDFButton.ButtonPushedFcn = @(src,event)app.openPDF();
            app.OpenPDFButton.Layout.Row = 1;
            app.OpenPDFButton.Layout.Column = 3;

            app.ClearButton = uibutton(fg,'push');
            app.ClearButton.Text = 'Clear / New Case';
            app.ClearButton.ButtonPushedFcn = @(src,event)app.clearApp();
            app.ClearButton.Layout.Row = 1;
            app.ClearButton.Layout.Column = 4;

            app.setStatus('Ready');
        end

        function ax = makeAxes(~,parent,titleText,row,col)
            ax = uiaxes(parent);
            ax.Layout.Row = row;
            ax.Layout.Column = col;
            ax.Title.String = titleText;
            ax.XTick = [];
            ax.YTick = [];
            ax.Box = 'on';
            ax.Toolbar.Visible = 'off';
            ax.Color = [1 1 1];
        end

        function selectImage(app)
            [file,path] = uigetfile( ...
            {'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff','Fundus Images'}, ...
            'Select a Fundus Image');

            if isequal(file,0)
                return;
            end

            app.SelectedImageFile = string(fullfile(path,file));
            app.SelectedImage = imread(app.SelectedImageFile);

            app.FileNameLabel.Text = file;
            app.QualityLabel.Text = 'Quality: not checked';

            imshow(app.SelectedImage,'Parent',app.OriginalAxes);
            title(app.OriginalAxes,'Original Image');

            app.setStatus('Image selected. Ready to screen.');
        end

        function runScreening(app)
            if strlength(app.SelectedImageFile) == 0 || ...
                ~isfile(app.SelectedImageFile)

                uialert(app.UIFigure, ...
                'Please select a fundus image first.', ...
                'No Image Selected');
                return;
            end

            try
                app.RunButton.Enable = 'off';
                app.SelectImageButton.Enable = 'off';
                drawnow;

                rootDir = fileparts(mfilename('fullpath'));

                addpath(rootDir);
                addpath(fullfile(rootDir,'validation'));
                addpath(fullfile(rootDir,'simulink'));

                cfgFile = fullfile(rootDir,'prototypeConfig.json');
                if ~isfile(cfgFile)
                    error('prototypeConfig.json not found:\n%s',cfgFile);
                end

                cfg = jsondecode(fileread(cfgFile));
                app.Config = cfg;

                modelFile = fullfile(rootDir,cfg.classifierModel);
                if ~isfile(modelFile)
                    error('Classifier model missing:\n%s',modelFile);
                end

                app.setStatus('Loading DR model...');
                app.Net = loadONNXModelCached(modelFile);

                imageFile = char(app.SelectedImageFile);
                original = imread(imageFile);
                app.SelectedImage = original;

                app.setStatus('Checking image quality...');
                quality = checkImageQuality(original,cfg);
                app.LastQuality = quality;

                app.QualityLabel.Text = sprintf( ...
                'Quality: %s | Score %.3f', ...
                char(string(quality.status)),quality.score);

                if quality.status == "REJECT"
                    app.setStatus('Image rejected — recapture required.');

                    uialert(app.UIFigure, ...
                    sprintf(['Image quality rejected.\n\n%s\n\n' ...
                    'Suggested action: refocus, center the retina, ' ...
                    'improve illumination, or recapture.'], ...
                    quality.message), ...
                    'Image Quality Rejected');

                    app.RunButton.Enable = 'on';
                    app.SelectImageButton.Enable = 'on';
                    return;
                end

                usedImage = original;

                if quality.isBorderline
                    app.setStatus('Enhancing borderline image...');
                    usedImage = enhanceFundusImage(original);

                    post = checkImageQuality(usedImage,cfg);
                    quality.postEnhancement = post;
                    app.LastQuality = quality;

                    if post.status == "REJECT"
                        uialert(app.UIFigure, ...
                        sprintf('Image remained unacceptable after enhancement.\n\n%s', ...
                        post.message), ...
                        'Image Quality Rejected');

                        app.RunButton.Enable = 'on';
                        app.SelectImageButton.Enable = 'on';
                        return;
                    end
                end

                app.setStatus('Running DR classifier...');
                result = screenFundusImage( ...
                app.Net,usedImage,cfg);

                lesionRoot = fullfile(rootDir,'models');
                lesionCfg = cfg;

                app.setStatus('Running lesion analysis...');

                lesions.microaneurysm = runLesionModel( ...
                fullfile(lesionRoot,'microaneurysm_model.onnx'), ...
                original,lesionCfg,'microaneurysm');

                lesions.hemorrhage = runLesionModel( ...
                fullfile(lesionRoot,'hemorrhage_model.onnx'), ...
                original,lesionCfg,'hemorrhage');

                lesions.exudate = runLesionModel( ...
                fullfile(lesionRoot,'exudate_model.onnx'), ...
                original,lesionCfg,'exudate');

                app.setStatus('Analyzing retinal structures...');

                structures = segmentRetinalStructures( ...
                original,quality);

                app.setStatus('Generating Grad-CAM...');

                cam = computeGradCAM( ...
                app.Net,usedImage, ...
                result.predictedGrade+1,cfg);

                result.fusedReferableProbability = [];
                result.fusedReferable = [];

                if isfield(cfg,'fusion') && ...
                    isfield(cfg.fusion,'enabled') && ...
                    cfg.fusion.enabled && ...
                    isfield(cfg.fusion,'modelFile') && ...
                    isfile(fullfile(rootDir,cfg.fusion.modelFile))

                    S = load(fullfile(rootDir,cfg.fusion.modelFile), ...
                    'fusionModel');

                    [fusedP,~] = fuseReferableEvidence( ...
                    result.referableProbability, ...
                    lesions,structures,S.fusionModel);

                    result.fusedReferableProbability = fusedP;
                    result.fusedReferable = ...
                    fusedP >= cfg.fusion.threshold;
                end

                app.setStatus('Building annotated report...');

                report = buildAnnotatedReport( ...
                imageFile,original,usedImage,quality, ...
                result,lesions,structures,cam,cfg);

                result.lesionEvidence = lesions;
                result.structures = structures;
                result.gradcam = cam;
                result.report = report;

                app.LastResult = result;
                app.LastLesions = lesions;
                app.LastStructures = structures;
                app.LastCAM = cam;
                app.LastReport = report;

                resultsDir = fullfile(rootDir,'results');
                if ~isfolder(resultsDir)
                    mkdir(resultsDir);
                end

                save(fullfile(resultsDir, ...
                [report.baseName '_screening_result.mat']), ...
                'result','quality','report');

                app.displayResults( ...
                original,usedImage,result,lesions,structures,cam);

                if isfield(report,'pdfFile') && ...
                    ~isempty(report.pdfFile) && ...
                    isfile(report.pdfFile)

                    app.LastPDF = string(report.pdfFile);
                    app.openPDF();
                end

                app.setStatus('Screening completed successfully.');

            catch ME
                app.setStatus('Screening failed.');

                uialert(app.UIFigure, ...
                sprintf('Screening failed:\n\n%s',ME.message), ...
                'Screening Error');

                fprintf(2,'%s\n',getReport(ME,'extended','hyperlinks','off'));

            end

            app.RunButton.Enable = 'on';
            app.SelectImageButton.Enable = 'on';
        end

        function displayResults(app,original,usedImage,result,lesions,structures,cam)

            imshow(original,'Parent',app.OriginalAxes);
            title(app.OriginalAxes,'Original Image');

            imshow(usedImage,'Parent',app.GradingAxes);
            title(app.GradingAxes,'Image Used for Grading');

            % Structures
            imshow(original,'Parent',app.StructuresAxes);
            title(app.StructuresAxes,'Retinal Structures');
            hold(app.StructuresAxes,'on');

            if isfield(structures,'opticDiscCentroid') && ...
                ~isempty(structures.opticDiscCentroid)

                c = structures.opticDiscCentroid;
                if numel(c) >= 2 && all(isfinite(c(1:2)))
                    plot(app.StructuresAxes,c(1),c(2),'r+','LineWidth',2,'MarkerSize',12);
                    text(app.StructuresAxes,c(1)+5,c(2),'Optic disc', ...
                    'Color','r','FontWeight','bold');
                end
            end

            if isfield(structures,'foveaCentroid') && ...
                ~isempty(structures.foveaCentroid)

                c = structures.foveaCentroid;
                if numel(c) >= 2 && all(isfinite(c(1:2)))
                    plot(app.StructuresAxes,c(1),c(2),'g+','LineWidth',2,'MarkerSize',12);
                    text(app.StructuresAxes,c(1)+5,c(2),'Fovea', ...
                    'Color','g','FontWeight','bold');
                end
            end
            hold(app.StructuresAxes,'off');

            % Lesion overlays
            app.showLesion(app.MicroaneurysmAxes,original, ...
            lesions.microaneurysm,'Microaneurysm');

            hold(app.HemorrhageAxes,'on');
            imshow(original,'Parent',app.HemorrhageAxes);
            title(app.HemorrhageAxes,'Hemorrhage + Exudate');

            app.showMaskOnAxes(app.HemorrhageAxes, ...
            lesions.hemorrhage,'r');

            app.showMaskOnAxes(app.HemorrhageAxes, ...
            lesions.exudate,'y');

            hold(app.HemorrhageAxes,'off');

            % Grad-CAM
            imshow(usedImage,'Parent',app.GradCAMAxes);
            title(app.GradCAMAxes,'Grad-CAM');

            if isfield(cam,'map') && ~isempty(cam.map)
                hold(app.GradCAMAxes,'on');

                cm = cam.map;
                cm = mat2gray(cm);
                cm = imresize(cm,[size(usedImage,1) size(usedImage,2)]);

                h = imagesc(app.GradCAMAxes,cm);
                h.AlphaData = 0.45;

                colormap(app.GradCAMAxes,'jet');
                colorbar(app.GradCAMAxes);

                hold(app.GradCAMAxes,'off');
            end

            % Result labels
            if isfield(result,'predictedGrade')
                app.GradeValue.Text = sprintf('%d',result.predictedGrade);
            end

            if isfield(result,'confidence')
                app.ConfidenceValue.Text = sprintf('%.2f%%', ...
                100*result.confidence);
            end

            if isfield(result,'referableProbability')
                app.ReferableValue.Text = sprintf('%.2f%%', ...
                100*result.referableProbability);
            end

            if isfield(result,'referable')
                if result.referable
                    app.DecisionValue.Text = 'REFER TO OPHTHALMOLOGIST';
                else
                    app.DecisionValue.Text = 'ROUTINE / FOLLOW-UP';
                end
            end

            % Lesion table
            app.LesionTable.Data = app.makeLesionTable(lesions);

            % Structure information
            app.OpticDiscLabel.Text = app.centroidText( ...
            structures,'opticDiscCentroid');

            app.FoveaLabel.Text = app.centroidText( ...
            structures,'foveaCentroid');

            if isfield(structures,'vesselDensity')
                app.VesselDensityLabel.Text = sprintf('%.3f', ...
                structures.vesselDensity);
            else
                app.VesselDensityLabel.Text = '--';
            end

            if isfield(structures,'neovascularizationSuspicious')
                app.NVLabel.Text = app.boolText( ...
                structures.neovascularizationSuspicious);
            else
                app.NVLabel.Text = '--';
            end
        end

        function showLesion(app,ax,original,lesion,titleText)
            imshow(original,'Parent',ax);
            title(ax,titleText);

            hold(ax,'on');
            app.showMaskOnAxes(ax,lesion,'r');
            hold(ax,'off');
        end

        function showMaskOnAxes(~,ax,lesion,displayColor)
            if ~isstruct(lesion)
                return;
            end

            mask = [];

            if isfield(lesion,'mask')
                mask = lesion.mask;
            elseif isfield(lesion,'binaryMask')
                mask = lesion.binaryMask;
            end

            if isempty(mask)
                return;
            end

            mask = logical(mask);
            if ~isequal(size(mask),[ax.Position(4) ax.Position(3)])
                % Overlay dimensions are determined from the displayed
                % image rather than axes pixels below.
            end

            h = imagesc(ax,mask);
            h.AlphaData = 0.28*double(mask);

            if strcmp(displayColor,'r')
                cmap = [1 0 0];
            elseif strcmp(displayColor,'y')
                cmap = [1 1 0];
            else
                cmap = [0 1 0];
            end

            colormap(ax,[0 0 0;cmap]);
            h.CDataMapping = 'direct';
            h.CData = double(mask)+1;
        end

        function data = makeLesionTable(app,lesions)
            names = {'Microaneurysm';'Hemorrhage';'Exudate'};
            fields = {'microaneurysm','hemorrhage','exudate'};

            data = cell(3,4);

            for k = 1:3
                L = lesions.(fields{k});

                data{k,1} = names{k};

                if isfield(L,'present')
                    data{k,2} = app.boolText(L.present);
                else
                    data{k,2} = '--';
                end

                if isfield(L,'areaPercent')
                    data{k,3} = sprintf('%.3f',L.areaPercent);
                else
                    data{k,3} = '--';
                end

                if isfield(L,'subpixelCentroids') && ...
                    ~isempty(L.subpixelCentroids)

                    c = L.subpixelCentroids;

                    if isvector(c)
                        n = 1;
                    else
                        n = size(c,1);
                    end

                    data{k,4} = n;
                else
                    data{k,4} = 0;
                end
            end
        end

        function txt = centroidText(~,S,field)
            if ~isfield(S,field) || isempty(S.(field))
                txt = '--';
                return;
            end

            c = S.(field);

            if numel(c) < 2 || any(~isfinite(c(1:2)))
                txt = '--';
            else
                txt = sprintf('(%.1f, %.1f)',c(1),c(2));
            end
        end

        function txt = boolText(~,x)
            if islogical(x) || isnumeric(x)
                if x
                    txt = 'YES';
                else
                    txt = 'NO';
                end
            else
                txt = char(string(x));
            end
        end

        function generatePDF(app)
            if isempty(app.LastReport) || ~isstruct(app.LastReport)
                uialert(app.UIFigure, ...
                'Run screening before generating a PDF.', ...
                'No Screening Result');
                return;
            end

            try
                if isfield(app.LastReport,'pdfFile') && ...
                    isfile(app.LastReport.pdfFile)

                    app.LastPDF = string(app.LastReport.pdfFile);
                    app.openPDF();
                    return;
                end

                uialert(app.UIFigure, ...
                'The screening report does not contain a PDF file.', ...
                'PDF Not Available');

            catch ME
                uialert(app.UIFigure,ME.message,'PDF Error');
            end
        end

        function openPDF(app)
            if strlength(app.LastPDF) == 0
                if ~isempty(app.LastReport) && ...
                    isstruct(app.LastReport) && ...
                    isfield(app.LastReport,'pdfFile')

                    app.LastPDF = string(app.LastReport.pdfFile);
                end
            end

            if strlength(app.LastPDF) == 0 || ~isfile(app.LastPDF)
                uialert(app.UIFigure, ...
                'No screening PDF is available yet.', ...
                'PDF Not Available');
                return;
            end

            pdfFile = char(app.LastPDF);

            if ispc
                winopen(pdfFile);
            elseif ismac
                system(['open "' pdfFile '"']);
            else
                system(['xdg-open "' pdfFile '"']);
            end
        end

        function clearApp(app)
            app.SelectedImageFile = "";
            app.SelectedImage = [];
            app.LastResult = [];
            app.LastQuality = [];
            app.LastLesions = [];
            app.LastStructures = [];
            app.LastCAM = [];
            app.LastReport = [];
            app.LastPDF = "";

            app.FileNameLabel.Text = 'No image selected';
            app.QualityLabel.Text = 'Quality: --';

            app.GradeValue.Text = '--';
            app.ConfidenceValue.Text = '--';
            app.ReferableValue.Text = '--';
            app.DecisionValue.Text = '--';

            app.OpticDiscLabel.Text = '--';
            app.FoveaLabel.Text = '--';
            app.VesselDensityLabel.Text = '--';
            app.NVLabel.Text = '--';

            app.LesionTable.Data = cell(0,4);

            cla(app.OriginalAxes);
            cla(app.GradingAxes);
            cla(app.StructuresAxes);
            cla(app.MicroaneurysmAxes);
            cla(app.HemorrhageAxes);
            cla(app.GradCAMAxes);

            title(app.OriginalAxes,'Original Image');
            title(app.GradingAxes,'Image Used for Grading');
            title(app.StructuresAxes,'Retinal Structures');
            title(app.MicroaneurysmAxes,'Microaneurysm');
            title(app.HemorrhageAxes,'Hemorrhage + Exudate');
            title(app.GradCAMAxes,'Grad-CAM');

            app.setStatus('Ready for new case.');
        end

        function setStatus(app,msg)
            if isempty(app.UIFigure) || ~isvalid(app.UIFigure)
                return;
            end

            app.StatusLabel.Text = msg;

            if contains(lower(msg),'failed') || ...
                contains(lower(msg),'rejected')

                app.StatusLamp.Color = [0.85 0.15 0.15];

            elseif contains(lower(msg),'completed') || ...
                contains(lower(msg),'ready')

                app.StatusLamp.Color = [0.15 0.65 0.25];

            else
                app.StatusLamp.Color = [0.95 0.65 0.10];
            end

            drawnow;
        end

        function delete(app)
            if ~isempty(app.UIFigure) && isvalid(app.UIFigure)
                delete(app.UIFigure);
            end
        end
    end
end
