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
            name = 'exudate_model.coder.ReshapeLayer1003';
        end
    end


    methods
        function this = ReshapeLayer1003(name)
            this.Name = name;
            this.OutputNames = {'conv2d_59'};
        end

        function [conv2d_59] = predict(this, functional_3_1_co_63)
            if isdlarray(functional_3_1_co_63)
                functional_3_1_co_63 = stripdims(functional_3_1_co_63);
            end
            functional_3_1_co_63NumDims = 4;
            functional_3_1_co_63 = exudate_model.ops.permuteInputVar(functional_3_1_co_63, [4 3 1 2], 4);

            [conv2d_59, conv2d_59NumDims] = ReshapeGraph1009(this, functional_3_1_co_63, functional_3_1_co_63NumDims, false);
            conv2d_59 = exudate_model.ops.permuteOutputVar(conv2d_59, ['as-is'], 4);

            conv2d_59 = dlarray(single(conv2d_59), repmat('U', 1, max(2, conv2d_59NumDims)));
        end

        function [conv2d_59] = forward(this, functional_3_1_co_63)
            if isdlarray(functional_3_1_co_63)
                functional_3_1_co_63 = stripdims(functional_3_1_co_63);
            end
            functional_3_1_co_63NumDims = 4;
            functional_3_1_co_63 = exudate_model.ops.permuteInputVar(functional_3_1_co_63, [4 3 1 2], 4);

            [conv2d_59, conv2d_59NumDims] = ReshapeGraph1009(this, functional_3_1_co_63, functional_3_1_co_63NumDims, true);
            conv2d_59 = exudate_model.ops.permuteOutputVar(conv2d_59, ['as-is'], 4);

            conv2d_59 = dlarray(single(conv2d_59), repmat('U', 1, max(2, conv2d_59NumDims)));
        end

        function [conv2d_59, conv2d_59NumDims1010] = ReshapeGraph1009(this, functional_3_1_co_63, functional_3_1_co_63NumDims, Training)

            % Execute the operators:
            % Reshape:
            [shape, conv2d_59NumDims] = exudate_model.ops.prepareReshapeArgs(functional_3_1_co_63, this.Vars.new_shape__953, functional_3_1_co_63NumDims, 0);
            conv2d_59 = reshape(functional_3_1_co_63, shape{:});

            % Set graph output arguments
            conv2d_59NumDims1010 = conv2d_59NumDims;

        end

    end

end