classdef ReshapeLayer1004 < nnet.layer.Layer & nnet.layer.Formattable
    % A custom layer auto-generated while importing an ONNX network.
    %#codegen

    %#ok<*PROPLC>
    %#ok<*NBRAK>
    %#ok<*INUSL>
    %#ok<*VARARG>
    properties (Learnable)
    end

    properties (State)
    end

    properties
        Vars
        NumDims
    end

    methods(Static, Hidden)
        % Specify the properties of the class that will not be modified
        % after the first assignment.
        function p = matlabCodegenNontunableProperties(~)
            p = {
                % Constants, i.e., Vars, NumDims and all learnables and states
                'Vars'
                'NumDims'
                };
        end
    end


    methods(Static, Hidden)
        % Instantiate a codegenable layer instance from a MATLAB layer instance
        function this_cg = matlabCodegenToRedirected(mlInstance)
            this_cg = hemorrhage_model.coder.ReshapeLayer1004(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = hemorrhage_model.ReshapeLayer1004(cgInstance.Name);
            if isstruct(cgInstance.Vars)
                names = fieldnames(cgInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this_ml.Vars.(fieldname) = dlarray(cgInstance.Vars.(fieldname));
                end
            else
                this_ml.Vars = [];
            end
            this_ml.NumDims = cgInstance.NumDims;
        end
    end

    methods
        function this = ReshapeLayer1004(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'conv2d_18'};
            if isstruct(mlInstance.Vars)
                names = fieldnames(mlInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this.Vars.(fieldname) = hemorrhage_model.coder.ops.extractIfDlarray(mlInstance.Vars.(fieldname));
                end
            else
                this.Vars = [];
            end

            this.NumDims = mlInstance.NumDims;
        end

        function [conv2d_18] = predict(this, Hemorrhage_UNet_1_42__)
            if isdlarray(Hemorrhage_UNet_1_42__)
                Hemorrhage_UNet_1_42_ = stripdims(Hemorrhage_UNet_1_42__);
            else
                Hemorrhage_UNet_1_42_ = Hemorrhage_UNet_1_42__;
            end
            Hemorrhage_UNet_1_42NumDims = 4;
            Hemorrhage_UNet_1_42 = hemorrhage_model.coder.ops.permuteInputVar(Hemorrhage_UNet_1_42_, [4 3 1 2], 4);

            [conv2d_18__, conv2d_18NumDims__] = ReshapeGraph1012(this, Hemorrhage_UNet_1_42, Hemorrhage_UNet_1_42NumDims, false);
            conv2d_18_ = hemorrhage_model.coder.ops.permuteOutputVar(conv2d_18__, ['as-is'], 4);

            conv2d_18 = dlarray(single(conv2d_18_), repmat('U', 1, max(2, coder.const(conv2d_18NumDims__))));
        end

        function [conv2d_18, conv2d_18NumDims1013] = ReshapeGraph1012(this, Hemorrhage_UNet_1_42, Hemorrhage_UNet_1_42NumDims, Training)

            % Execute the operators:
            % Reshape:
            [shape1044, conv2d_18NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Hemorrhage_UNet_1_42, this.Vars.new_shape__268, coder.const(Hemorrhage_UNet_1_42NumDims), 0);
            conv2d_18 = reshape(Hemorrhage_UNet_1_42, shape1044{:});

            % Set graph output arguments
            conv2d_18NumDims1013 = coder.const(conv2d_18NumDims);

        end

    end

end