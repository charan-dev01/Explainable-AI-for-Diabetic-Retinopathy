classdef Unsqueeze_To_ReshapeLayer1002 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1002';
        end
    end


    methods
        function this = Unsqueeze_To_ReshapeLayer1002(name)
            this.Name = name;
            this.OutputNames = {'Hemorrhage_UNet__178'};
        end

        function [Hemorrhage_UNet__178] = predict(this, Hemorrhage_UNet_1_22)
            if isdlarray(Hemorrhage_UNet_1_22)
                Hemorrhage_UNet_1_22 = stripdims(Hemorrhage_UNet_1_22);
            end
            Hemorrhage_UNet_1_22NumDims = 4;
            Hemorrhage_UNet_1_22 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_22, [4 3 1 2], 4);

            [Hemorrhage_UNet__178, Hemorrhage_UNet__178NumDims] = Unsqueeze_To_ReshapeGraph1006(this, Hemorrhage_UNet_1_22, Hemorrhage_UNet_1_22NumDims, false);
            Hemorrhage_UNet__178 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__178, [2 3 4 1], 4);

            Hemorrhage_UNet__178 = dlarray(single(Hemorrhage_UNet__178), 'SSCB');
        end

        function [Hemorrhage_UNet__178] = forward(this, Hemorrhage_UNet_1_22)
            if isdlarray(Hemorrhage_UNet_1_22)
                Hemorrhage_UNet_1_22 = stripdims(Hemorrhage_UNet_1_22);
            end
            Hemorrhage_UNet_1_22NumDims = 4;
            Hemorrhage_UNet_1_22 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_22, [4 3 1 2], 4);

            [Hemorrhage_UNet__178, Hemorrhage_UNet__178NumDims] = Unsqueeze_To_ReshapeGraph1006(this, Hemorrhage_UNet_1_22, Hemorrhage_UNet_1_22NumDims, true);
            Hemorrhage_UNet__178 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__178, [2 3 4 1], 4);

            Hemorrhage_UNet__178 = dlarray(single(Hemorrhage_UNet__178), 'SSCB');
        end

        function [Hemorrhage_UNet__178, Hemorrhage_UNet__178NumDims1008] = Unsqueeze_To_ReshapeGraph1006(this, Hemorrhage_UNet_1_22, Hemorrhage_UNet_1_22NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape, Hemorrhage_UNet__167NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_22, this.Vars.const_fold_opt__286, Hemorrhage_UNet_1_22NumDims);
            Hemorrhage_UNet__167 = reshape(Hemorrhage_UNet_1_22, shape);

            % Tile:
            [sz, Hemorrhage_UNet__172NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__172 = repmat(Hemorrhage_UNet__167, sz);

            % Transpose:
            [perm, Transpose__228_0NumDims] = hemorrhage_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1007, Hemorrhage_UNet__172NumDims);
            if isempty(perm)
                Transpose__228_0 = Hemorrhage_UNet__172;
            else
                Transpose__228_0 = permute(Hemorrhage_UNet__172, perm);
            end

            % Shape:
            [Shape__260_0, Shape__260_0NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet_1_22, Hemorrhage_UNet_1_22NumDims, 0, Hemorrhage_UNet_1_22NumDims+1);

            % Gather:
            [Hemorrhage_UNet__170, Hemorrhage_UNet__170NumDims] = hemorrhage_model.ops.onnxGather(Shape__260_0, this.Vars.Const__266, 0, Shape__260_0NumDims, this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__171 = cast(int32(extractdata(Hemorrhage_UNet__170)), 'like', Hemorrhage_UNet__170);
            Hemorrhage_UNet__171NumDims = Hemorrhage_UNet__170NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__175NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__171, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', Hemorrhage_UNet__171NumDims);
            Hemorrhage_UNet__175 = Hemorrhage_UNet__171(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__176NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__171, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__171NumDims);
            Hemorrhage_UNet__176 = Hemorrhage_UNet__171(Indices{:});

            % Concat:
            [Hemorrhage_UNet__174, Hemorrhage_UNet__174NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__175, this.Vars.Hemorrhage_UNet__173, Hemorrhage_UNet__176}, [Hemorrhage_UNet__175NumDims, this.NumDims.Hemorrhage_UNet__173, Hemorrhage_UNet__176NumDims]);

            % Cast:
            Hemorrhage_UNet__169 = cast(int64(extractdata(Hemorrhage_UNet__174)), 'like', Hemorrhage_UNet__174);
            Hemorrhage_UNet__169NumDims = Hemorrhage_UNet__174NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__168NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Transpose__228_0, Hemorrhage_UNet__169, Transpose__228_0NumDims, 0);
            Hemorrhage_UNet__168 = reshape(Transpose__228_0, shape{:});

            % Unsqueeze:
            [shape, Hemorrhage_UNet__177NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__168, this.Vars.const_fold_opt__286, Hemorrhage_UNet__168NumDims);
            Hemorrhage_UNet__177 = reshape(Hemorrhage_UNet__168, shape);

            % Tile:
            [sz, Hemorrhage_UNet__182NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__182 = repmat(Hemorrhage_UNet__177, sz);

            % Shape:
            [Hemorrhage_UNet__180, Hemorrhage_UNet__180NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet__168, Hemorrhage_UNet__168NumDims, 0, Hemorrhage_UNet__168NumDims+1);

            % Cast:
            Hemorrhage_UNet__181 = cast(int32(extractdata(Hemorrhage_UNet__180)), 'like', Hemorrhage_UNet__180);
            Hemorrhage_UNet__181NumDims = Hemorrhage_UNet__180NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__184NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__181, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', Hemorrhage_UNet__181NumDims);
            Hemorrhage_UNet__184 = Hemorrhage_UNet__181(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__185NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__181, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__181NumDims);
            Hemorrhage_UNet__185 = Hemorrhage_UNet__181(Indices{:});

            % Concat:
            [Hemorrhage_UNet__183, Hemorrhage_UNet__183NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__184, this.Vars.Hemorrhage_UNet__173, Hemorrhage_UNet__185}, [Hemorrhage_UNet__184NumDims, this.NumDims.Hemorrhage_UNet__173, Hemorrhage_UNet__185NumDims]);

            % Cast:
            Hemorrhage_UNet__179 = cast(int64(extractdata(Hemorrhage_UNet__183)), 'like', Hemorrhage_UNet__183);
            Hemorrhage_UNet__179NumDims = Hemorrhage_UNet__183NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__178NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Hemorrhage_UNet__182, Hemorrhage_UNet__179, Hemorrhage_UNet__182NumDims, 0);
            Hemorrhage_UNet__178 = reshape(Hemorrhage_UNet__182, shape{:});

            % Set graph output arguments
            Hemorrhage_UNet__178NumDims1008 = Hemorrhage_UNet__178NumDims;

        end

    end

end