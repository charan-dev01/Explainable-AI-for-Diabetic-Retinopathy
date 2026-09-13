classdef DRScreeningApp < handle
    %DRSCREENINGAPP Clinician-first UI for the integrated Retina Assist pipeline.
    % This app is decision support only; it never represents AI output as diagnosis.

    properties
        UIFigure
        RootGrid
        HeaderPanel
        IntakePanel
        ResultPanel
        WorkspacePanel
        EvidencePanel
        AnatomyPanel
        FooterPanel
        ContentGrid

        CaseIdField
        EyeDropDown
        CaptureField
        DeviceField
        ReviewerDropDown
        SelectImageButton
        RunButton
        ReportButton
        OpenReportButton
        NewCaseButton

        StatusLamp
        StatusLabel
        CaseHeaderLabel
        QualityLabel
        ActionLabel
        ActionPriorityLabel
        ActionRationaleLabel
        GradeLabel
        ReferableLabel
        ConfidenceLabel
        MacularLabel
        ModelLabel

        MainAxes
        ViewTitle
        OverlaySlider
        OverlayLabel
        LegendLabel
        ViewButtons

        EvidenceTable
        HighlightButton
        AnatomyLabel
        NotesArea
        TechnicalArea
        DetailsButton

        SelectedImageFile = ""
        SelectedImage = []
        LastResult = []
        ImageViews = struct()
        CurrentView = "original"

        % Selected row in the lesion evidence table.
        SelectedEvidenceIndex = []

        % Reusable clinical colors.
        Colors = struct()
    end

    methods
        function app = DRScreeningApp
            app.createUI();
            app.showEmptyState('Select a fundus image to begin a clinician-reviewed assessment.');
        end

        function createUI(app)
            %% White clinical design system
            app.Colors.page      = [1.00 1.00 1.00];
            app.Colors.surface   = [1.00 1.00 1.00];
            app.Colors.subtle    = [0.97 0.98 0.99];
            app.Colors.border    = [0.78 0.82 0.87];
            app.Colors.ink       = [0.10 0.15 0.20];
            app.Colors.muted     = [0.32 0.39 0.46];
            app.Colors.blue      = [0.05 0.39 0.70];
            app.Colors.blueDark  = [0.03 0.25 0.48];
            app.Colors.green     = [0.08 0.50 0.26];
            app.Colors.amber     = [0.72 0.43 0.04];
            app.Colors.red       = [0.72 0.18 0.14];

            app.UIFigure = uifigure( ...
                'Name','LUMORA VISION | DR Screening', ...
                'Position',[35 28 1500 960], ...
                'Color',app.Colors.page, ...
                'Scrollable','on', ...
                'AutoResizeChildren','off');

            app.UIFigure.SizeChangedFcn = @(~,~)app.adaptLayout();
            app.UIFigure.CloseRequestFcn = @(~,~)delete(app);

            app.RootGrid = uigridlayout(app.UIFigure,[5 1]);
            app.RootGrid.RowHeight = {66,154,158,'1x',62};
            app.RootGrid.Padding = [16 14 16 14];
            app.RootGrid.RowSpacing = 10;
            app.RootGrid.BackgroundColor = app.Colors.page;

            %% Header: white, never dark
            app.HeaderPanel = uipanel(app.RootGrid, ...
                'BorderType','line', ...
                'BackgroundColor',app.Colors.surface, ...
                'ForegroundColor',app.Colors.border, ...
                'Scrollable','on', ...
                'HighlightColor',app.Colors.border);

            hg = uigridlayout(app.HeaderPanel,[1 3]);
            hg.ColumnWidth = {260,'1x',360};
            hg.Padding = [16 8 16 8];
            hg.ColumnSpacing = 12;
            hg.BackgroundColor = app.Colors.surface;

            uilabel(hg, ...
                'Text','LUMORA VISION', ...
                'FontSize',22, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.blueDark, ...
                'VerticalAlignment','center');

            app.CaseHeaderLabel = uilabel(hg, ...
                'Text','CASE: —  |  EYE: —  |  REVIEW: NOT STARTED', ...
                'FontSize',12, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.ink, ...
                'HorizontalAlignment','center', ...
                'VerticalAlignment','center', ...
                'WordWrap','on');
            app.CaseHeaderLabel.Layout.Column = 2;

            sg = uigridlayout(hg,[1 2]);
            sg.Layout.Column = 3;
            sg.ColumnWidth = {20,'1x'};
            sg.Padding = [2 0 2 0];
            sg.ColumnSpacing = 8;
            sg.BackgroundColor = app.Colors.surface;

            app.StatusLamp = uilamp(sg,'Color',app.Colors.green);
            app.StatusLabel = uilabel(sg, ...
                'Text','READY FOR CASE INTAKE', ...
                'FontSize',11, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.ink, ...
                'HorizontalAlignment','right', ...
                'VerticalAlignment','center', ...
                'WordWrap','on');
            app.StatusLabel.Layout.Column = 2;

            %% Intake
            app.IntakePanel = uipanel(app.RootGrid, ...
                'Title','CASE INTAKE & IMAGE GRADEABILITY', ...
                'ForegroundColor',app.Colors.ink, ...
                'BackgroundColor',app.Colors.surface, ...
                'HighlightColor',app.Colors.border, ...
                'Scrollable','on', ...
                'FontWeight','bold');

            ig = uigridlayout(app.IntakePanel,[4 6]);
            ig.RowHeight = {42,18,32,32};
            ig.ColumnWidth = {175,175,'1x',155,190,190};
            ig.Padding = [16 10 16 10];
            ig.RowSpacing = 4;
            ig.ColumnSpacing = 10;
            ig.BackgroundColor = app.Colors.surface;

            app.SelectImageButton = uibutton(ig, ...
                'Text',['' char(128194) ' SELECT FUNDUS IMAGE'], ...
                'ButtonPushedFcn',@(~,~)app.selectImage());
            app.SelectImageButton.Layout.Row = 1;
            app.SelectImageButton.Layout.Column = 1;
            app.styleButton(app.SelectImageButton,'primary');

            app.RunButton = uibutton(ig, ...
                'Text',['' char(9654) ' RUN AI ASSESSMENT'], ...
                'ButtonPushedFcn',@(~,~)app.runScreening());
            app.RunButton.Layout.Row = 1;
            app.RunButton.Layout.Column = 2;
            app.styleButton(app.RunButton,'primary');

            app.QualityLabel = uilabel(ig, ...
                'Text','GRADEABILITY: NOT ASSESSED', ...
                'FontSize',11, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.muted, ...
                'VerticalAlignment','center', ...
                'WordWrap','on');
            app.QualityLabel.Layout.Row = 1;
            app.QualityLabel.Layout.Column = [3 4];

            app.ReviewerDropDown = uidropdown(ig, ...
                'Items',{'Reviewer: pending','Reviewer: in review','Reviewer: confirmed'}, ...
                'Value','Reviewer: pending', ...
                'ValueChangedFcn',@(~,~)app.updateCaseHeader());
            app.ReviewerDropDown.Layout.Row = 1;
            app.ReviewerDropDown.Layout.Column = [5 6];

            labels = { ...
                'CASE ID (OPTIONAL)', ...
                'EYE LATERALITY', ...
                'CAPTURE DATE / TIME (OPTIONAL)', ...
                'CAMERA / DEVICE (OPTIONAL)'};
            labelCols = {[1 2],3,4,[5 6]};

            for n = 1:numel(labels)
                x = uilabel(ig, ...
                    'Text',labels{n}, ...
                    'FontSize',10, ...
                    'FontWeight','bold', ...
                    'FontColor',app.Colors.muted, ...
                    'VerticalAlignment','bottom');
                x.Layout.Row = 2;
                x.Layout.Column = labelCols{n};
            end

            app.CaseIdField = uieditfield(ig,'text', ...
                'ValueChangedFcn',@(~,~)app.updateCaseHeader());
            app.CaseIdField.Layout.Row = 3;
            app.CaseIdField.Layout.Column = [1 2];

            app.EyeDropDown = uidropdown(ig, ...
                'Items',{'Eye: not specified','Right eye','Left eye'}, ...
                'Value','Eye: not specified', ...
                'ValueChangedFcn',@(~,~)app.updateCaseHeader());
            app.EyeDropDown.Layout.Row = 3;
            app.EyeDropDown.Layout.Column = 3;

            app.CaptureField = uieditfield(ig,'text');
            app.CaptureField.Layout.Row = 3;
            app.CaptureField.Layout.Column = 4;

            app.DeviceField = uieditfield(ig,'text');
            app.DeviceField.Layout.Row = 3;
            app.DeviceField.Layout.Column = [5 6];

            %% Clinical results
            app.ResultPanel = uipanel(app.RootGrid, ...
                'Title','CLINICAL RESULT  •  SCREENING DECISION SUPPORT', ...
                'ForegroundColor',app.Colors.ink, ...
                'BackgroundColor',app.Colors.surface, ...
                'HighlightColor',app.Colors.border, ...
                'Scrollable','on', ...
                'FontWeight','bold');

            rg = uigridlayout(app.ResultPanel,[1 5]);
            rg.ColumnWidth = {'1.2x','1x','1x','1x','1.55x'};
            rg.Padding = [16 10 16 10];
            rg.ColumnSpacing = 10;
            rg.BackgroundColor = app.Colors.surface;

            [~,app.GradeLabel] = app.resultMetric(rg,1,['' char(128269) ' DR SCREENING GRADE'],'—');
            [~,app.ReferableLabel] = app.resultMetric(rg,2,['' char(9888) ' REFERABLE PROBABILITY'],'—');
            [~,app.ConfidenceLabel] = app.resultMetric(rg,3,['' char(128202) ' AI CONFIDENCE'],'—');
            [~,app.MacularLabel] = app.resultMetric(rg,4,['' char(128065) ' MACULAR SCREEN'],'—');

            actionPanel = uipanel(rg, ...
                'BorderType','line', ...
                'BackgroundColor',app.Colors.surface, ...
                'ForegroundColor',app.Colors.border, ...
                'Scrollable','on', ...
                'HighlightColor',app.Colors.border);
            actionPanel.Layout.Column = 5;

            ag = uigridlayout(actionPanel,[4 1]);
            ag.RowHeight = {18,34,20,'1x'};
            ag.Padding = [12 8 12 8];
            ag.RowSpacing = 3;
            ag.BackgroundColor = app.Colors.surface;

            uilabel(ag, ...
                'Text','RECOMMENDED ACTION', ...
                'FontSize',10, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.muted);

            app.ActionLabel = uilabel(ag, ...
                'Text','Awaiting assessment', ...
                'FontSize',17, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.ink, ...
                'VerticalAlignment','center', ...
                'WordWrap','on');
            app.ActionLabel.Layout.Row = 2;

            app.ActionPriorityLabel = uilabel(ag, ...
                'Text','Priority: not assessed', ...
                'FontSize',11, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.muted, ...
                'WordWrap','on');
            app.ActionPriorityLabel.Layout.Row = 3;

            app.ActionRationaleLabel = uilabel(ag, ...
                'Text','Quality and retinal evidence will be shown after assessment.', ...
                'FontSize',10, ...
                'FontColor',app.Colors.muted, ...
                'VerticalAlignment','top', ...
                'WordWrap','on');
            app.ActionRationaleLabel.Layout.Row = 4;

            %% Main content
            app.ContentGrid = uigridlayout(app.RootGrid,[3 2]);
            app.ContentGrid.RowHeight = {'1x','1x',180};
            app.ContentGrid.ColumnWidth = {'2x',470};
            app.ContentGrid.Padding = [0 0 0 0];
            app.ContentGrid.RowSpacing = 10;
            app.ContentGrid.ColumnSpacing = 10;
            app.ContentGrid.BackgroundColor = app.Colors.page;

            %% Image evidence workspace
            app.WorkspacePanel = uipanel(app.ContentGrid, ...
                'Title','IMAGE EVIDENCE WORKSPACE', ...
                'ForegroundColor',app.Colors.ink, ...
                'BackgroundColor',app.Colors.surface, ...
                'HighlightColor',app.Colors.border, ...
                'Scrollable','on', ...
                'FontWeight','bold');
            app.WorkspacePanel.Layout.Row = [1 3];
            app.WorkspacePanel.Layout.Column = 1;

            wg = uigridlayout(app.WorkspacePanel,[2 2]);
            wg.RowHeight = {'1x',58};
            wg.ColumnWidth = {'1x',165};
            wg.Padding = [14 12 14 12];
            wg.RowSpacing = 8;
            wg.ColumnSpacing = 10;
            wg.BackgroundColor = app.Colors.surface;

            app.MainAxes = uiaxes(wg);
            app.MainAxes.Layout.Row = 1;
            app.MainAxes.Layout.Column = 1;
            app.MainAxes.Color = app.Colors.surface;
            app.MainAxes.XColor = 'none';
            app.MainAxes.YColor = 'none';
            app.MainAxes.Box = 'off';
            app.MainAxes.XTick = [];
            app.MainAxes.YTick = [];
            app.MainAxes.Title.Color = app.Colors.ink;
            app.MainAxes.Title.FontWeight = 'bold';
            axtoolbar(app.MainAxes,{'zoomin','zoomout','pan','restoreview'});

            rail = uipanel(wg, ...
                'BorderType','none', ...
                'BackgroundColor',app.Colors.surface);
            rail.Layout.Row = 1;
            rail.Layout.Column = 2;

            vg = uigridlayout(rail,[7 1]);
            vg.RowHeight = {18,34,34,34,34,34,34};
            vg.Padding = [0 0 0 0];
            vg.RowSpacing = 6;
            vg.BackgroundColor = app.Colors.surface;

            app.ViewTitle = uilabel(vg, ...
                'Text','IMAGE VIEW', ...
                'FontSize',10, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.muted, ...
                'HorizontalAlignment','center');

            names = {'Original','Grading image','Structure overlay','Lesion evidence','Grad-CAM','Color legend'};
            keys = {'original','grading','structures','lesions','gradcam','legend'};
            app.ViewButtons = cell(1,numel(names));

            for k = 1:numel(names)
                b = uibutton(vg, ...
                    'Text',names{k}, ...
                    'ButtonPushedFcn',@(~,~)app.setImageView(keys{k}));
                b.Layout.Row = k + 1;
                app.styleButton(b,'view');
                app.ViewButtons{k} = b;
            end

            controls = uigridlayout(wg,[2 4]);
            controls.Layout.Row = 2;
            controls.Layout.Column = [1 2];
            controls.RowHeight = {26,24};
            controls.ColumnWidth = {125,'1x',55,'1.35x'};
            controls.Padding = [0 0 0 0];
            controls.RowSpacing = 2;
            controls.ColumnSpacing = 8;
            controls.BackgroundColor = app.Colors.surface;

            uilabel(controls, ...
                'Text','OVERLAY OPACITY', ...
                'FontSize',10, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.muted, ...
                'VerticalAlignment','center');

            app.OverlaySlider = uislider(controls, ...
                'Limits',[0.10 0.80], ...
                'Value',0.42, ...
                'ValueChangingFcn',@(~,~)app.refreshView(), ...
                'ValueChangedFcn',@(~,~)app.refreshView());

            app.OverlayLabel = uilabel(controls, ...
                'Text','42%', ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.ink, ...
                'HorizontalAlignment','center');

            zoomHelp = uilabel(controls, ...
                'Text','Pan / zoom with viewer tools', ...
                'FontSize',10, ...
                'FontColor',app.Colors.muted, ...
                'HorizontalAlignment','right', ...
                'WordWrap','on');
            zoomHelp.Layout.Column = 4;

            app.LegendLabel = uilabel(controls, ...
                'Text','Red = microaneurysm  •  Amber = hemorrhage  •  Green = exudate  •  Heatmap = model attention', ...
                'FontSize',10, ...
                'FontColor',app.Colors.muted, ...
                'WordWrap','on');
            app.LegendLabel.Layout.Row = 2;
            app.LegendLabel.Layout.Column = [1 4];

            %% Lesion evidence
            app.EvidencePanel = uipanel(app.ContentGrid, ...
                'Title','LESION EVIDENCE', ...
                'ForegroundColor',app.Colors.ink, ...
                'BackgroundColor',app.Colors.surface, ...
                'HighlightColor',app.Colors.border, ...
                'Scrollable','on', ...
                'FontWeight','bold');
            app.EvidencePanel.Layout.Row = [1 2];
            app.EvidencePanel.Layout.Column = 2;

            eg = uigridlayout(app.EvidencePanel,[2 1]);

            eg.RowHeight = {220,42};
            eg.Padding = [12 10 12 10];
            eg.RowSpacing = 7;
            eg.BackgroundColor = app.Colors.surface;

            app.EvidenceTable = uitable(eg, ...
                'ColumnName',{'Finding','Status','Regions','Area (%)','Confidence'}, ...
                'Data',cell(0,5), ...
                'ColumnWidth',{140,85,60,70,80}, ...
                'RowStriping','on', ...
                'FontSize',12, ...
                'BackgroundColor',[app.Colors.surface; app.Colors.subtle], ...
                'CellSelectionCallback',@(src,event)app.onEvidenceSelection(src,event));

            % Make all lesion-evidence table text black.
            evidenceTextStyle = uistyle('FontColor',[0 0 0]);
            addStyle(app.EvidenceTable,evidenceTextStyle,'column',1:5);

            app.EvidenceTable.Layout.Row = 1;
            app.HighlightButton = uibutton(eg, ...
                'Text','HIGHLIGHT SELECTED LESION', ...
                'ButtonPushedFcn',@(~,~)app.highlightSelectedEvidence());
            app.HighlightButton.Layout.Row = 2;
            app.styleButton(app.HighlightButton,'secondary');
            app.HighlightButton.Enable = 'off';

            %% Anatomy + notes
            app.AnatomyPanel = uipanel(app.ContentGrid, ...
                'Title','ANATOMICAL CONTEXT & CLINICIAN NOTES', ...
                'ForegroundColor',app.Colors.ink, ...
                'BackgroundColor',app.Colors.surface, ...
                'HighlightColor',app.Colors.border, ...
                'Scrollable','on', ...
                'FontWeight','bold');
            app.AnatomyPanel.Layout.Row = 3;
            app.AnatomyPanel.Layout.Column = 2;

            ng = uigridlayout(app.AnatomyPanel,[2 2]);

            % More room for technical details and scrolling when needed.
            ng.RowHeight = {'1x',60};
            ng.ColumnWidth = {'1x','1.1x'};
            ng.Padding = [12 8 12 8];
            ng.RowSpacing = 5;
            ng.ColumnSpacing = 9;
            ng.BackgroundColor = app.Colors.surface;

            app.AnatomyLabel = uilabel(ng, ...
                'Text','Optic disc, fovea and vessel context will appear after assessment.', ...
                'WordWrap','on', ...
                'FontColor',app.Colors.ink, ...
                'FontSize',11, ...
                'VerticalAlignment','top');
            app.AnatomyLabel.Layout.Row = 1;
            app.AnatomyLabel.Layout.Column = 1;

            app.NotesArea = uitextarea(ng, ...
                'Placeholder','Clinician notes (not used for AI inference)', ...
                'BackgroundColor',app.Colors.surface, ...
                'FontColor',app.Colors.ink);
            app.NotesArea.Layout.Row = 1;
            app.NotesArea.Layout.Column = 2;

            app.DetailsButton = uibutton(ng, ...
                'Text','SHOW TECHNICAL DETAILS', ...
                'ButtonPushedFcn',@(~,~)app.toggleTechnicalDetails());
            app.DetailsButton.Layout.Row = 2;
            app.DetailsButton.Layout.Column = 1;
            app.styleButton(app.DetailsButton,'secondary');

            app.TechnicalArea = uilabel(ng, ...
                'Text','Technical coordinates are hidden until requested.', ...
                'WordWrap','on', ...
                'FontSize',10, ...
                'FontColor',app.Colors.muted, ...
                'Visible','off');
            app.TechnicalArea.Layout.Row = 2;
            app.TechnicalArea.Layout.Column = 2;

            %% Footer — all white
            app.FooterPanel = uipanel(app.RootGrid, ...
                'BorderType','line', ...
                'BackgroundColor',app.Colors.surface, ...
                'ForegroundColor',app.Colors.border, ...
                'Scrollable','on', ...
                'HighlightColor',app.Colors.border);

            fg = uigridlayout(app.FooterPanel,[1 5]);
            fg.ColumnWidth = {'1x','1.2x',150,125,110};
            fg.Padding = [8 6 8 6];
            fg.ColumnSpacing = 8;
            fg.BackgroundColor = app.Colors.surface;

            uilabel(fg, ...
                'Text','AI-assisted screening decision support — clinician confirmation required.', ...
                'FontWeight','bold', ...
                'FontSize',11, ...
                'FontColor',app.Colors.ink, ...
                'VerticalAlignment','center', ...
                'WordWrap','on');

            app.ModelLabel = uilabel(fg, ...
                'Text','Model: supplied ONNX • provenance unverified', ...
                'FontSize',10, ...
                'FontColor',app.Colors.muted, ...
                'HorizontalAlignment','right', ...
                'VerticalAlignment','center', ...
                'WordWrap','on');
            app.ModelLabel.Layout.Column = 2;

            app.ReportButton = uibutton(fg, ...
                'Text',['' char(128196) ' GENERATE REPORT'], ...
                'ButtonPushedFcn',@(~,~)app.generateReport());
            app.ReportButton.Layout.Column = 3;
            app.styleButton(app.ReportButton,'secondary');

            app.OpenReportButton = uibutton(fg, ...
                'Text',['' char(128214) ' OPEN REPORT'], ...
                'ButtonPushedFcn',@(~,~)app.openReport());
            app.OpenReportButton.Layout.Column = 4;
            app.styleButton(app.OpenReportButton,'secondary');

            app.NewCaseButton = uibutton(fg, ...
                'Text',['' char(10133) ' NEW CASE'], ...
                'ButtonPushedFcn',@(~,~)app.confirmNewCase());
            app.NewCaseButton.Layout.Column = 5;
            app.styleButton(app.NewCaseButton,'secondary');

            app.setStatus('READY FOR CASE INTAKE','ready');
        end

        function styleButton(app,button,kind)
            button.FontWeight = 'bold';
            button.FontSize = 11;

            switch kind
                case 'primary'
                    button.BackgroundColor = app.Colors.blue;
                    button.FontColor = [1 1 1];
                case 'view'
                    button.BackgroundColor = [0.94 0.97 1.00];
                    button.FontColor = app.Colors.blueDark;
                otherwise
                    button.BackgroundColor = [0.90 0.94 0.98];
                    button.FontColor = app.Colors.blueDark;
            end
        end

        function [label,value] = resultMetric(app,parent,col,caption,initial)
            p = uipanel(parent, ...
                'BorderType','line', ...
                'BackgroundColor',app.Colors.surface, ...
                'ForegroundColor',app.Colors.border, ...
                'HighlightColor',app.Colors.border);
            p.Layout.Column = col;

            g = uigridlayout(p,[2 1]);
            g.RowHeight = {30,'1x'};
            g.Padding = [12 8 12 8];
            g.RowSpacing = 2;
            g.BackgroundColor = app.Colors.surface;

            label = uilabel(g, ...
                'Text',caption, ...
                'FontSize',10, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.muted, ...
                'VerticalAlignment','top', ...
                'WordWrap','on');

            value = uilabel(g, ...
                'Text',initial, ...
                'FontSize',18, ...
                'FontWeight','bold', ...
                'FontColor',app.Colors.ink, ...
                'VerticalAlignment','center', ...
                'WordWrap','on');
            value.Layout.Row = 2;
        end

        function selectImage(app)
            [file,path] = uigetfile({ ...
                '*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff','Fundus images'}, ...
                'Select fundus image');

            if isequal(file,0)
                return
            end

            try
                app.SelectedImageFile = string(fullfile(path,file));
                app.SelectedImage = imread(app.SelectedImageFile);

                % Clear previous assessment when a new image is selected.
                app.LastResult = [];

                % Reset previous clinical result values.
                app.GradeLabel.Text = '—';
                app.ReferableLabel.Text = '—';
                app.ConfidenceLabel.Text = '—';
                app.MacularLabel.Text = '—';
                app.ActionLabel.Text = 'Awaiting assessment';
                app.ActionPriorityLabel.Text = 'Priority: not assessed';
                app.ActionRationaleLabel.Text = ...
                    'Quality and retinal evidence will be shown after assessment.';
                app.ActionLabel.FontColor = app.Colors.ink;
                app.ActionPriorityLabel.FontColor = app.Colors.muted;

                % Reset evidence/anatomical information from previous case.
                app.EvidenceTable.Data = cell(0,5);
                app.HighlightButton.Enable = 'off';
                app.SelectedEvidenceIndex = [];
                app.AnatomyLabel.Text = ...
                    'Optic disc, fovea and vessel context will appear after assessment.';
                app.TechnicalArea.Visible = 'off';
                app.DetailsButton.Text = 'SHOW TECHNICAL DETAILS';
                app.ModelLabel.Text = ...
                    'Model: supplied ONNX • provenance unverified';

                app.ImageViews = struct('original',app.SelectedImage);
                app.CurrentView = "original";
                app.setImageView('original');

                app.setStatus('IMAGE SELECTED — READY TO ASSESS','processing');
                app.QualityLabel.Text = 'GRADEABILITY: PENDING';
                app.QualityLabel.FontColor = app.Colors.amber;
                app.updateCaseHeader();

            catch ME
                app.showEmptyState('Unable to read selected image. Choose a valid RGB or grayscale fundus image.');
                app.setStatus('IMAGE LOAD FAILED','failed');
                uialert(app.UIFigure,ME.message,'Image Load Failed');
            end
        end

        function runScreening(app)
            if strlength(app.SelectedImageFile) == 0
                uialert(app.UIFigure, ...
                    'Select a fundus image before running assessment.', ...
                    'No Image Selected');
                return
            end

            app.setControlsEnabled(false);
            app.setStatus('ANALYSIS IN PROGRESS — PLEASE WAIT','processing');
            app.showEmptyState('Running quality assessment, retinal analysis and explainability…');
            drawnow;

            cleanup = onCleanup(@()app.setControlsEnabled(true)); %#ok<NASGU>

            try
                result = screenFundusImage(app.SelectedImageFile);
                app.LastResult = result;
                app.applyResult(result);

                if result.status == "UNGRADABLE"
                    app.setStatus('UNGRADABLE IMAGE — RECAPTURE REQUIRED','failed');
                    app.showEmptyState(result.recaptureFeedback);
                    uialert(app.UIFigure,result.recaptureFeedback,'Ungradable Image');
                    return
                end

                app.setStatus('ASSESSMENT READY FOR CLINICIAN REVIEW','ready');

            catch ME
                app.setStatus('ANALYSIS FAILED','failed');
                app.showEmptyState('Analysis failed safely. Check the image and model availability, then try again.');
                uialert(app.UIFigure,ME.message,'Analysis Failed');
            end
        end

        function applyResult(app,result)
            q = result.quality;
            app.QualityLabel.Text = sprintf( ...
                'GRADEABILITY: %s  •  SCORE %.2f',char(q.status),q.score);

            if q.status == "ACCEPT"
                app.QualityLabel.FontColor = app.Colors.green;
            else
                app.QualityLabel.FontColor = app.Colors.amber;
            end

            g = result.finalGrade;
            app.GradeLabel.Text = sprintf('Level %d — %s',g.level,char(g.label));

            app.ReferableLabel.Text = sprintf( ...
                '%.1f%%',100*result.referableProbability);

            app.ConfidenceLabel.Text = sprintf( ...
                '%.1f%%',100*result.confidence);

            app.MacularLabel.Text = strrep( ...
                char(result.macularAssessment.status),'_',' ');

            if result.referable
                app.ActionLabel.Text = 'Refer to ophthalmology';
                app.ActionPriorityLabel.Text = 'Priority: timely review';
                app.ActionRationaleLabel.Text = ...
                    'Referable screening evidence is present. Confirm and arrange eye-care review.';
                app.ActionLabel.FontColor = app.Colors.red;
                app.ActionPriorityLabel.FontColor = app.Colors.red;
            else
                app.ActionLabel.Text = 'Routine follow-up';
                app.ActionPriorityLabel.Text = 'Priority: standard pathway';
                app.ActionRationaleLabel.Text = ...
                    'No referable screening threshold was reached. Confirm during clinician review.';
                app.ActionLabel.FontColor = app.Colors.green;
                app.ActionPriorityLabel.FontColor = app.Colors.green;
            end

            app.ImageViews = struct( ...
                'original',app.SelectedImage, ...
                'grading',result.usedImage, ...
                'structures',result.structures, ...
                'lesions',result.lesionEvidence, ...
                'gradcam',result.gradcam);

            app.SelectedEvidenceIndex = [];
            app.populateEvidence(result.lesionEvidence);
            app.populateAnatomy(result);
            app.setImageView('original');

            processedTime = datetime("now",'Format','yyyy-MM-dd HH:mm');
            app.ModelLabel.Text = sprintf( ...
                'Model: supplied ONNX • processed %s', ...
                char(processedTime));

            app.updateCaseHeader();
        end

        function setImageView(app,key)
            app.CurrentView = string(key);
            opacity = app.OverlaySlider.Value;

            keys = {'original','grading','structures','lesions','gradcam','legend'};

            for k = 1:numel(app.ViewButtons)
                if string(keys{k}) == app.CurrentView
                    app.ViewButtons{k}.BackgroundColor = app.Colors.blue;
                    app.ViewButtons{k}.FontColor = [1 1 1];
                else
                    app.ViewButtons{k}.BackgroundColor = [0.94 0.97 1.00];
                    app.ViewButtons{k}.FontColor = app.Colors.blueDark;
                end
            end

            cla(app.MainAxes);
            app.MainAxes.Color = app.Colors.surface;

            if ~isfield(app.ImageViews,'original')
                app.showEmptyState('No retinal image loaded.');
                return
            end

            original = app.ImageViews.original;

            if string(key) == "legend"
                axis(app.MainAxes,'off');

                text(app.MainAxes,0.07,0.83,'COLOR LEGEND', ...
                    'Units','normalized', ...
                    'Color',app.Colors.ink, ...
                    'FontWeight','bold', ...
                    'FontSize',16);

                text(app.MainAxes,0.07,0.63,'Red — microaneurysm evidence', ...
                    'Units','normalized', ...
                    'Color',app.Colors.red, ...
                    'FontSize',13);

                text(app.MainAxes,0.07,0.46,'Amber — hemorrhage evidence', ...
                    'Units','normalized', ...
                    'Color',app.Colors.amber, ...
                    'FontSize',13);

                text(app.MainAxes,0.07,0.29,'Green — exudate evidence', ...
                    'Units','normalized', ...
                    'Color',app.Colors.green, ...
                    'FontSize',13);

                text(app.MainAxes,0.07,0.12, ...
                    'Heatmap — model attention; it is not a diagnosis', ...
                    'Units','normalized', ...
                    'Color',app.Colors.ink, ...
                    'FontSize',12);

                app.ViewTitle.Text = 'COLOR LEGEND';
                return
            end

            imshow(original,'Parent',app.MainAxes);
            hold(app.MainAxes,'on');

            switch string(key)

                case "grading"
                    if isfield(app.ImageViews,'grading')
                        imshow(app.ImageViews.grading,'Parent',app.MainAxes);
                    end
                    title(app.MainAxes,{'IMAGE USED FOR GRADING',''}, ...
                        'Color',app.Colors.ink);

                case "structures"
                    if isfield(app.ImageViews,'structures')
                        s = app.ImageViews.structures;

                        if isfield(s,'vesselMask') && ~isempty(s.vesselMask)
                            % Draw vessels as transparent contour lines on the
                            % original image. No dark canvas is introduced.
                            boundaries = bwboundaries(logical(s.vesselMask));
                            for b = 1:numel(boundaries)
                                xy = boundaries{b};
                                if size(xy,1) > 10
                                    plot(app.MainAxes,xy(:,2),xy(:,1), ...
                                        'Color',[0.12 0.52 0.72], ...
                                        'LineWidth',0.8, ...
                                        'LineStyle','-');
                                end
                            end
                        end

                        if isfield(s,'opticDiscCentroid') && all(isfinite(s.opticDiscCentroid))
                            plot(app.MainAxes, ...
                                s.opticDiscCentroid(1), ...
                                s.opticDiscCentroid(2), ...
                                'o','Color',[0.10 0.55 0.78], ...
                                'LineWidth',2,'MarkerSize',12);
                        end

                        if isfield(s,'foveaCentroid') && all(isfinite(s.foveaCentroid))
                            plot(app.MainAxes, ...
                                s.foveaCentroid(1), ...
                                s.foveaCentroid(2), ...
                                '+','Color',app.Colors.amber, ...
                                'LineWidth',2,'MarkerSize',14);
                        end
                    end

                    title(app.MainAxes, ...
                        {'STRUCTURE OVERLAY','VESSELS / DISC / FOVEA'}, ...
                        'Color',app.Colors.ink);

                case "lesions"
                    if isfield(app.ImageViews,'lesions')
                        app.drawLesions(app.ImageViews.lesions,opacity);
                    end

                    title(app.MainAxes, ...
                        {'LESION EVIDENCE','MICROANEURYSM • HEMORRHAGE • EXUDATE'}, ...
                        'Color',app.Colors.ink);

                case "gradcam"
                    if isfield(app.ImageViews,'gradcam') && ...
                            isfield(app.ImageViews.gradcam,'success') && ...
                            app.ImageViews.gradcam.success

                        % Render Grad-CAM with a transparent alpha layer.
                        h = imagesc(app.MainAxes,app.ImageViews.gradcam.map);
                        h.AlphaData = 0.75 * opacity;
                        colormap(app.MainAxes,'hot');

                    else
                        text(app.MainAxes,0.5,0.5, ...
                            'Grad-CAM unavailable for this imported model.', ...
                            'Units','normalized', ...
                            'Color',app.Colors.ink, ...
                            'HorizontalAlignment','center', ...
                            'FontSize',12);
                    end

                    title(app.MainAxes, ...
                        {'GRAD-CAM ATTENTION MAP','SUPPORTING CONTEXT ONLY'}, ...
                        'Color',app.Colors.ink);

                otherwise
                    title(app.MainAxes,{'ORIGINAL FUNDUS IMAGE',''}, ...
                        'Color',app.Colors.ink);
            end

            axis(app.MainAxes,'image');
            app.MainAxes.XTick = [];
            app.MainAxes.YTick = [];
            hold(app.MainAxes,'off');

            app.ViewTitle.Text = upper(strrep(char(key),'_',' '));
        end

        function drawLesions(app,L,opacity)
            % Draw all evidence lightly, then selected evidence strongly.
            specs = { ...
                'microaneurysm',app.Colors.red; ...
                'hemorrhage',app.Colors.amber; ...
                'exudate',app.Colors.green};

            for k = 1:size(specs,1)
                field = specs{k,1};

                if ~isfield(L,field)
                    continue
                end

                x = L.(field);

                if ~isfield(x,'mask') || isempty(x.mask)
                    continue
                end

                mask = logical(x.mask);

                % Convert mask to full original-image dimensions.
                mask = imresize(mask, ...
                    [size(app.ImageViews.original,1), ...
                     size(app.ImageViews.original,2)], ...
                    'nearest');

                alphaValue = max(0.20,0.45 * opacity);
                if ~isempty(app.SelectedEvidenceIndex) && ...
                        app.SelectedEvidenceIndex == k
                    alphaValue = min(1.0,0.95 * opacity + 0.20);
                end

                % Filled mask on a transparent layer.
                rgb = zeros([size(mask,1),size(mask,2),3],'uint8');
                rgb(:,:,1) = uint8(255 * specs{k,2}(1));
                rgb(:,:,2) = uint8(255 * specs{k,2}(2));
                rgb(:,:,3) = uint8(255 * specs{k,2}(3));

                h = imshow(rgb,'Parent',app.MainAxes);
                h.AlphaData = alphaValue * double(mask);

                % Strong outline for selected evidence.
                if ~isempty(app.SelectedEvidenceIndex) && ...
                        app.SelectedEvidenceIndex == k

                    boundaries = bwboundaries(mask);

                    for b = 1:numel(boundaries)
                        xy = boundaries{b};
                        if size(xy,1) > 4
                            plot(app.MainAxes,xy(:,2),xy(:,1), ...
                                'Color',specs{k,2}, ...
                                'LineWidth',2.2);
                        end
                    end
                end
            end
        end

        function populateEvidence(app,L)
            fields = {'microaneurysm','hemorrhage','exudate'};
            labels = {'Microaneurysm','Hemorrhage','Exudate'};
            rows = cell(3,5);

            for k = 1:3
                x = L.(fields{k});

                confidence = NaN;
                if isfield(x,'probability') && ~isempty(x.probability)
                    confidence = max(x.probability(:));
                end

                regions = 0;
                if isfield(x,'subpixelCentroids') && ~isempty(x.subpixelCentroids)
                    regions = size(x.subpixelCentroids,1);
                end

                areaPercent = NaN;
                if isfield(x,'areaPercent') && ~isempty(x.areaPercent)
                    areaPercent = x.areaPercent;
                end

                isPresent = false;
                if isfield(x,'present')
                    isPresent = logical(x.present);
                end

                rows(k,:) = { ...
                    labels{k}, ...
                    ternaryText(isPresent,'Detected','Not detected'), ...
                    regions, ...
                    sprintf('%.3f',areaPercent), ...
                    formatPercent(confidence)};
            end

            app.EvidenceTable.Data = rows;
            app.SelectedEvidenceIndex = [];
            app.HighlightButton.Enable = 'off';
        end

        function populateAnatomy(app,result)
            % Populate the anatomical context panel after a successful assessment.
            if ~isfield(result,'structures') || isempty(result.structures)
                app.AnatomyLabel.Text = ...
                    'Anatomical context is unavailable for this assessment.';
                app.TechnicalArea.Text = ...
                    'Technical coordinates are unavailable.';
                return
            end

            s = result.structures;

            vesselDensityText = '—';
            if isfield(s,'vesselDensity') && ~isempty(s.vesselDensity)
                vesselDensityText = sprintf('%.3f',s.vesselDensity);
            end

            neovascularizationText = 'Not available';
            if isfield(s,'neovascularizationStatus') && ...
                    ~isempty(s.neovascularizationStatus)
                neovascularizationText = strrep( ...
                    char(s.neovascularizationStatus),'_',' ');
            end

            macularText = 'Not available';
            if isfield(result,'macularAssessment') && ...
                    isfield(result.macularAssessment,'status') && ...
                    ~isempty(result.macularAssessment.status)
                macularText = strrep( ...
                    char(result.macularAssessment.status),'_',' ');
            end

            app.AnatomyLabel.Text = sprintf( ...
                'Vessel density: %s\nNeovascularization screening: %s\nMacular context: %s', ...
                vesselDensityText, ...
                neovascularizationText, ...
                macularText);

            discText = 'not available';
            if isfield(s,'opticDiscCentroid') && ...
                    numel(s.opticDiscCentroid) >= 2 && ...
                    all(isfinite(s.opticDiscCentroid(1:2)))
                discText = sprintf('(%.1f, %.1f)', ...
                    s.opticDiscCentroid(1),s.opticDiscCentroid(2));
            end

            foveaText = 'not available';
            if isfield(s,'foveaCentroid') && ...
                    numel(s.foveaCentroid) >= 2 && ...
                    all(isfinite(s.foveaCentroid(1:2)))
                foveaText = sprintf('(%.1f, %.1f)', ...
                    s.foveaCentroid(1),s.foveaCentroid(2));
            end

            noteText = '';
            if isfield(s,'neovascularizationNote') && ...
                    ~isempty(s.neovascularizationNote)
                noteText = char(s.neovascularizationNote);
            end

            app.TechnicalArea.Text = sprintf( ...
                'Optic disc: %s  •  Fovea: %s\n%s', ...
                discText, ...
                foveaText, ...
                noteText);
        end

        function onEvidenceSelection(app,src,event)
            if isempty(event.Indices)
                app.SelectedEvidenceIndex = [];
                app.HighlightButton.Enable = 'off';
                return
            end

            row = event.Indices(1);

            if row >= 1 && row <= size(src.Data,1)
                app.SelectedEvidenceIndex = row;
                app.HighlightButton.Enable = 'on';

                % Immediately show the selected evidence.
                app.setImageView('lesions');
            end
        end

        function highlightSelectedEvidence(app)
            if isempty(app.SelectedEvidenceIndex)
                uialert(app.UIFigure, ...
                    'Select a lesion row first.', ...
                    'No Lesion Selected');
                return
            end

            app.setImageView('lesions');
        end

        function refreshView(app)
            app.OverlayLabel.Text = sprintf( ...
                '%.0f%%',100*app.OverlaySlider.Value);
            app.setImageView(app.CurrentView);
        end

        function toggleTechnicalDetails(app)
            if strcmp(app.TechnicalArea.Visible,'on')
                app.TechnicalArea.Visible = 'off';
                app.DetailsButton.Text = 'SHOW TECHNICAL DETAILS';
            else
                app.TechnicalArea.Visible = 'on';
                app.DetailsButton.Text = 'HIDE TECHNICAL DETAILS';
            end
        end

        function showEmptyState(app,message)
            cla(app.MainAxes);
            app.MainAxes.Color = app.Colors.surface;
            axis(app.MainAxes,'off');

            text(app.MainAxes,0.5,0.5,message, ...
                'Units','normalized', ...
                'HorizontalAlignment','center', ...
                'VerticalAlignment','middle', ...
                'Color',app.Colors.ink, ...
                'FontSize',14, ...
                'FontWeight','bold', ...
                'Interpreter','none');
            app.ViewTitle.Text = 'ASSESSMENT WORKSPACE';
        end

        function setControlsEnabled(app,value)
            state = ternaryText(value,'on','off');
            app.SelectImageButton.Enable = state;
            app.RunButton.Enable = state;
        end

        function setStatus(app,message,kind)
            app.StatusLabel.Text = message;

            switch lower(kind)
                case 'failed'
                    c = app.Colors.red;
                case 'processing'
                    c = app.Colors.amber;
                otherwise
                    c = app.Colors.green;
            end

            app.StatusLamp.Color = c;
            app.StatusLabel.FontColor = app.Colors.ink;
        end

        function updateCaseHeader(app)
            caseId = string(app.CaseIdField.Value);
            if strlength(caseId) == 0
                caseId = "—";
            end

            eye = erase(string(app.EyeDropDown.Value),'Eye: ');
            review = erase(string(app.ReviewerDropDown.Value),'Reviewer: ');

            app.CaseHeaderLabel.Text = ...
                "CASE: " + caseId + ...
                "  |  EYE: " + eye + ...
                "  |  REVIEW: " + upper(review);
        end

        function generateReport(app)
            if isempty(app.LastResult)
                uialert(app.UIFigure, ...
                    'Run an assessment before generating a report.', ...
                    'No Assessment');
                return
            end

            if isfield(app.LastResult,'report')
                app.openReport();
            else
                uialert(app.UIFigure, ...
                    'No report is available for this result.', ...
                    'Report Unavailable');
            end
        end

        function openReport(app)
            if isempty(app.LastResult) || ...
                    ~isfield(app.LastResult,'report') || ...
                    ~isfile(app.LastResult.report.pdfFile)

                uialert(app.UIFigure, ...
                    'No report is available yet.', ...
                    'Report Unavailable');
                return
            end

            if ispc
                winopen(app.LastResult.report.pdfFile);
            else
                open(app.LastResult.report.pdfFile);
            end
        end

        function confirmNewCase(app)
            if isempty(app.LastResult) && ...
                    strlength(app.SelectedImageFile) == 0
                app.resetCase();
                return
            end

            uiconfirm(app.UIFigure, ...
                'Start a new case? Unsaved clinician notes will be discarded.', ...
                'New case', ...
                'Options',{'Cancel','Start new case'}, ...
                'DefaultOption',1, ...
                'CancelOption',1, ...
                'CloseFcn',@(~,e)app.handleNewCaseChoice(e.SelectedOption));
        end

        function handleNewCaseChoice(app,choice)
            if string(choice) == "Start new case"
                app.resetCase();
            end
        end

        function resetCase(app)
            app.SelectedImageFile = "";
            app.SelectedImage = [];
            app.LastResult = [];
            app.ImageViews = struct();
            app.SelectedEvidenceIndex = [];

            app.CaseIdField.Value = '';
            app.EyeDropDown.Value = 'Eye: not specified';
            app.CaptureField.Value = '';
            app.DeviceField.Value = '';
            app.ReviewerDropDown.Value = 'Reviewer: pending';
            app.NotesArea.Value = '';

            app.QualityLabel.Text = 'GRADEABILITY: NOT ASSESSED';
            app.QualityLabel.FontColor = app.Colors.muted;

            app.GradeLabel.Text = '—';
            app.ReferableLabel.Text = '—';
            app.ConfidenceLabel.Text = '—';
            app.MacularLabel.Text = '—';

            app.ActionLabel.Text = 'Awaiting assessment';
            app.ActionPriorityLabel.Text = 'Priority: not assessed';
            app.ActionRationaleLabel.Text = ...
                'Quality and retinal evidence will be shown after assessment.';
            app.ActionLabel.FontColor = app.Colors.ink;
            app.ActionPriorityLabel.FontColor = app.Colors.muted;

            app.EvidenceTable.Data = cell(0,5);
            app.HighlightButton.Enable = 'off';

            app.AnatomyLabel.Text = ...
                'Optic disc, fovea and vessel context will appear after assessment.';

            app.TechnicalArea.Visible = 'off';
            app.DetailsButton.Text = 'SHOW TECHNICAL DETAILS';

            app.ModelLabel.Text = ...
                'Model: supplied ONNX • provenance unverified';

            app.updateCaseHeader();
            app.setStatus('READY FOR CASE INTAKE','ready');
            app.showEmptyState( ...
                'Select a fundus image to begin a clinician-reviewed assessment.');
        end

        function adaptLayout(app)
            if isempty(app.UIFigure) || ~isvalid(app.UIFigure)
                return
            end

            width = app.UIFigure.Position(3);

            if width >= 1400
                app.RootGrid.RowHeight = {66,154,158,'1x',62};
                app.ContentGrid.ColumnWidth = {'2x',470};
                app.ContentGrid.RowHeight = {'1x','1x',180};

                app.WorkspacePanel.Layout.Row = [1 3];
                app.WorkspacePanel.Layout.Column = 1;

                app.EvidencePanel.Layout.Row = [1 2];
                app.EvidencePanel.Layout.Column = 2;

                app.AnatomyPanel.Layout.Row = 3;
                app.AnatomyPanel.Layout.Column = 2;

            elseif width >= 1180
                app.RootGrid.RowHeight = {70,165,170,'1x',64};
                app.ContentGrid.ColumnWidth = {'1.75x',440};
                app.ContentGrid.RowHeight = {'1x','1x',190};

                app.WorkspacePanel.Layout.Row = [1 3];
                app.WorkspacePanel.Layout.Column = 1;

                app.EvidencePanel.Layout.Row = [1 2];
                app.EvidencePanel.Layout.Column = 2;

                app.AnatomyPanel.Layout.Row = 3;
                app.AnatomyPanel.Layout.Column = 2;

            elseif width >= 900
                app.RootGrid.RowHeight = {72,184,180,'1x',64};
                app.ContentGrid.ColumnWidth = {'1x','1x'};
                app.ContentGrid.RowHeight = {'1.25x','1x','0.9x'};

                app.WorkspacePanel.Layout.Row = 1;
                app.WorkspacePanel.Layout.Column = [1 2];

                app.EvidencePanel.Layout.Row = 2;
                app.EvidencePanel.Layout.Column = [1 2];

                app.AnatomyPanel.Layout.Row = 3;
                app.AnatomyPanel.Layout.Column = [1 2];

            else
                app.RootGrid.RowHeight = {82,220,190,'1x',74};
                app.ContentGrid.ColumnWidth = {'1x', '1x'};
                app.ContentGrid.RowHeight = {'1.25x','0.9x','1.0x'};

                app.WorkspacePanel.Layout.Row = 1;
                app.WorkspacePanel.Layout.Column = 1;

                app.EvidencePanel.Layout.Row = 2;
                app.EvidencePanel.Layout.Column = 1;

                app.AnatomyPanel.Layout.Row = 3;
                app.AnatomyPanel.Layout.Column = 1;
            end
        end

        function delete(app)
            if ~isempty(app.UIFigure) && isvalid(app.UIFigure)
                delete(app.UIFigure);
            end
        end
    end
end

function out = ternaryText(condition,yes,no)
if condition
    out = yes;
else
    out = no;
end
end

function out = formatPercent(value)
if isnan(value)
    out = '—';
else
    out = sprintf('%.1f%%',100*value);
end
end
