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
            this_cg = exudate_model.coder.ReshapeLayer1003(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = exudate_model.ReshapeLayer1003(cgInstance.Name);
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
            this.OutputNames = {'conv2d_59'};
            if isstruct(mlInstance.Vars)
                names = fieldnames(mlInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this.Vars.(fieldname) = exudate_model.coder.ops.extractIfDlarray(mlInstance.Vars.(fieldname));
                end
            else
                this.Vars = [];
            end

            this.NumDims = mlInstance.NumDims;
        end

        function [conv2d_59] = predict(this, functional_3_1_co_63__)
            if isdlarray(functional_3_1_co_63__)
                functional_3_1_co_63_ = stripdims(functional_3_1_co_63__);
            else
                functional_3_1_co_63_ = functional_3_1_co_63__;
            end
            functional_3_1_co_63NumDims = 4;
            functional_3_1_co_63 = exudate_model.coder.ops.permuteInputVar(functional_3_1_co_63_, [4 3 1 2], 4);

            [conv2d_59__, conv2d_59NumDims__] = ReshapeGraph1009(this, functional_3_1_co_63, functional_3_1_co_63NumDims, false);
            conv2d_59_ = exudate_model.coder.ops.permuteOutputVar(conv2d_59__, ['as-is'], 4);

            conv2d_59 = dlarray(single(conv2d_59_), repmat('U', 1, max(2, coder.const(conv2d_59NumDims__))));
        end

        function [conv2d_59, conv2d_59NumDims1010] = ReshapeGraph1009(this, functional_3_1_co_63, functional_3_1_co_63NumDims, Training)

            % Execute the operators:
            % Reshape:
            [shape1033, conv2d_59NumDims] = exudate_model.coder.ops.prepareReshapeArgs(functional_3_1_co_63, this.Vars.new_shape__953, coder.const(functional_3_1_co_63NumDims), 0);
            conv2d_59 = reshape(functional_3_1_co_63, shape1033{:});

            % Set graph output arguments
            conv2d_59NumDims1010 = coder.const(conv2d_59NumDims);

        end

    end

end