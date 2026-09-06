classdef ReshapeLayer1003 < nnet.layer.Layer & nnet.layer.Formattable
    % A custom layer auto-generated while importing an ONNX network.

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
        % Specify the path to the class that will be used for codegen
        function name = matlabCodegenRedirect(~)
            name = 'microaneurysm_model.coder.ReshapeLayer1003';
        end
    end


    methods
        function this = ReshapeLayer1003(name)
            this.Name = name;
            this.OutputNames = {'conv2d_14'};
        end

        function [conv2d_14] = predict(this, functional_1_conv_22)
            if isdlarray(functional_1_conv_22)
                functional_1_conv_22 = stripdims(functional_1_conv_22);
            end
            functional_1_conv_22NumDims = 4;
            functional_1_conv_22 = microaneurysm_model.ops.permuteInputVar(functional_1_conv_22, [4 3 1 2], 4);

            [conv2d_14, conv2d_14NumDims] = ReshapeGraph1009(this, functional_1_conv_22, functional_1_conv_22NumDims, false);
            conv2d_14 = microaneurysm_model.ops.permuteOutputVar(conv2d_14, ['as-is'], 4);

            conv2d_14 = dlarray(single(conv2d_14), repmat('U', 1, max(2, conv2d_14NumDims)));
        end

        function [conv2d_14] = forward(this, functional_1_conv_22)
            if isdlarray(functional_1_conv_22)
                functional_1_conv_22 = stripdims(functional_1_conv_22);
            end
            functional_1_conv_22NumDims = 4;
            functional_1_conv_22 = microaneurysm_model.ops.permuteInputVar(functional_1_conv_22, [4 3 1 2], 4);

            [conv2d_14, conv2d_14NumDims] = ReshapeGraph1009(this, functional_1_conv_22, functional_1_conv_22NumDims, true);
            conv2d_14 = microaneurysm_model.ops.permuteOutputVar(conv2d_14, ['as-is'], 4);

            conv2d_14 = dlarray(single(conv2d_14), repmat('U', 1, max(2, conv2d_14NumDims)));
        end

        function [conv2d_14, conv2d_14NumDims1010] = ReshapeGraph1009(this, functional_1_conv_22, functional_1_conv_22NumDims, Training)

            % Execute the operators:
            % Reshape:
            [shape, conv2d_14NumDims] = microaneurysm_model.ops.prepareReshapeArgs(functional_1_conv_22, this.Vars.new_shape__281, functional_1_conv_22NumDims, 0);
            conv2d_14 = reshape(functional_1_conv_22, shape{:});

            % Set graph output arguments
            conv2d_14NumDims1010 = conv2d_14NumDims;

        end

    end

end