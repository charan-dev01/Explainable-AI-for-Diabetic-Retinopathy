classdef ReshapeLayer1004 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'hemorrhage_model.coder.ReshapeLayer1004';
        end
    end


    methods
        function this = ReshapeLayer1004(name)
            this.Name = name;
            this.OutputNames = {'conv2d_18'};
        end

        function [conv2d_18] = predict(this, Hemorrhage_UNet_1_42)
            if isdlarray(Hemorrhage_UNet_1_42)
                Hemorrhage_UNet_1_42 = stripdims(Hemorrhage_UNet_1_42);
            end
            Hemorrhage_UNet_1_42NumDims = 4;
            Hemorrhage_UNet_1_42 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_42, [4 3 1 2], 4);

            [conv2d_18, conv2d_18NumDims] = ReshapeGraph1012(this, Hemorrhage_UNet_1_42, Hemorrhage_UNet_1_42NumDims, false);
            conv2d_18 = hemorrhage_model.ops.permuteOutputVar(conv2d_18, ['as-is'], 4);

            conv2d_18 = dlarray(single(conv2d_18), repmat('U', 1, max(2, conv2d_18NumDims)));
        end

        function [conv2d_18] = forward(this, Hemorrhage_UNet_1_42)
            if isdlarray(Hemorrhage_UNet_1_42)
                Hemorrhage_UNet_1_42 = stripdims(Hemorrhage_UNet_1_42);
            end
            Hemorrhage_UNet_1_42NumDims = 4;
            Hemorrhage_UNet_1_42 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_42, [4 3 1 2], 4);

            [conv2d_18, conv2d_18NumDims] = ReshapeGraph1012(this, Hemorrhage_UNet_1_42, Hemorrhage_UNet_1_42NumDims, true);
            conv2d_18 = hemorrhage_model.ops.permuteOutputVar(conv2d_18, ['as-is'], 4);

            conv2d_18 = dlarray(single(conv2d_18), repmat('U', 1, max(2, conv2d_18NumDims)));
        end

        function [conv2d_18, conv2d_18NumDims1013] = ReshapeGraph1012(this, Hemorrhage_UNet_1_42, Hemorrhage_UNet_1_42NumDims, Training)

            % Execute the operators:
            % Reshape:
            [shape, conv2d_18NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Hemorrhage_UNet_1_42, this.Vars.new_shape__268, Hemorrhage_UNet_1_42NumDims, 0);
            conv2d_18 = reshape(Hemorrhage_UNet_1_42, shape{:});

            % Set graph output arguments
            conv2d_18NumDims1013 = conv2d_18NumDims;

        end

    end

end