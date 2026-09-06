classdef ReshapeLayer1003 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = microaneurysm_model.coder.ReshapeLayer1003(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = microaneurysm_model.ReshapeLayer1003(cgInstance.Name);
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
        function this = ReshapeLayer1003(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'conv2d_14'};
            if isstruct(mlInstance.Vars)
                names = fieldnames(mlInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this.Vars.(fieldname) = microaneurysm_model.coder.ops.extractIfDlarray(mlInstance.Vars.(fieldname));
                end
            else
                this.Vars = [];
            end

            this.NumDims = mlInstance.NumDims;
        end

        function [conv2d_14] = predict(this, functional_1_conv_22__)
            if isdlarray(functional_1_conv_22__)
                functional_1_conv_22_ = stripdims(functional_1_conv_22__);
            else
                functional_1_conv_22_ = functional_1_conv_22__;
            end
            functional_1_conv_22NumDims = 4;
            functional_1_conv_22 = microaneurysm_model.coder.ops.permuteInputVar(functional_1_conv_22_, [4 3 1 2], 4);

            [conv2d_14__, conv2d_14NumDims__] = ReshapeGraph1009(this, functional_1_conv_22, functional_1_conv_22NumDims, false);
            conv2d_14_ = microaneurysm_model.coder.ops.permuteOutputVar(conv2d_14__, ['as-is'], 4);

            conv2d_14 = dlarray(single(conv2d_14_), repmat('U', 1, max(2, coder.const(conv2d_14NumDims__))));
        end

        function [conv2d_14, conv2d_14NumDims1010] = ReshapeGraph1009(this, functional_1_conv_22, functional_1_conv_22NumDims, Training)

            % Execute the operators:
            % Reshape:
            [shape1033, conv2d_14NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(functional_1_conv_22, this.Vars.new_shape__281, coder.const(functional_1_conv_22NumDims), 0);
            conv2d_14 = reshape(functional_1_conv_22, shape1033{:});

            % Set graph output arguments
            conv2d_14NumDims1010 = coder.const(conv2d_14NumDims);

        end

    end

end