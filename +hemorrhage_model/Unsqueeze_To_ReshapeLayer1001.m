classdef Unsqueeze_To_ReshapeLayer1001 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1001';
        end
    end


    methods
        function this = Unsqueeze_To_ReshapeLayer1001(name)
            this.Name = name;
            this.OutputNames = {'Hemorrhage_UNet__159'};
        end

        function [Hemorrhage_UNet__159] = predict(this, Hemorrhage_UNet_1_14)
            if isdlarray(Hemorrhage_UNet_1_14)
                Hemorrhage_UNet_1_14 = stripdims(Hemorrhage_UNet_1_14);
            end
            Hemorrhage_UNet_1_14NumDims = 4;
            Hemorrhage_UNet_1_14 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_14, [4 3 1 2], 4);

            [Hemorrhage_UNet__159, Hemorrhage_UNet__159NumDims] = Unsqueeze_To_ReshapeGraph1003(this, Hemorrhage_UNet_1_14, Hemorrhage_UNet_1_14NumDims, false);
            Hemorrhage_UNet__159 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__159, [2 3 4 1], 4);

            Hemorrhage_UNet__159 = dlarray(single(Hemorrhage_UNet__159), 'SSCB');
        end

        function [Hemorrhage_UNet__159] = forward(this, Hemorrhage_UNet_1_14)
            if isdlarray(Hemorrhage_UNet_1_14)
                Hemorrhage_UNet_1_14 = stripdims(Hemorrhage_UNet_1_14);
            end
            Hemorrhage_UNet_1_14NumDims = 4;
            Hemorrhage_UNet_1_14 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_14, [4 3 1 2], 4);

            [Hemorrhage_UNet__159, Hemorrhage_UNet__159NumDims] = Unsqueeze_To_ReshapeGraph1003(this, Hemorrhage_UNet_1_14, Hemorrhage_UNet_1_14NumDims, true);
            Hemorrhage_UNet__159 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__159, [2 3 4 1], 4);

            Hemorrhage_UNet__159 = dlarray(single(Hemorrhage_UNet__159), 'SSCB');
        end

        function [Hemorrhage_UNet__159, Hemorrhage_UNet__159NumDims1005] = Unsqueeze_To_ReshapeGraph1003(this, Hemorrhage_UNet_1_14, Hemorrhage_UNet_1_14NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape, Hemorrhage_UNet__148NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_14, this.Vars.const_fold_opt__286, Hemorrhage_UNet_1_14NumDims);
            Hemorrhage_UNet__148 = reshape(Hemorrhage_UNet_1_14, shape);

            % Tile:
            [sz, Hemorrhage_UNet__153NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__153 = repmat(Hemorrhage_UNet__148, sz);

            % Transpose:
            [perm, Transpose__222_0NumDims] = hemorrhage_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1004, Hemorrhage_UNet__153NumDims);
            if isempty(perm)
                Transpose__222_0 = Hemorrhage_UNet__153;
            else
                Transpose__222_0 = permute(Hemorrhage_UNet__153, perm);
            end

            % Shape:
            [Shape__256_0, Shape__256_0NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet_1_14, Hemorrhage_UNet_1_14NumDims, 0, Hemorrhage_UNet_1_14NumDims+1);

            % Gather:
            [Hemorrhage_UNet__151, Hemorrhage_UNet__151NumDims] = hemorrhage_model.ops.onnxGather(Shape__256_0, this.Vars.Const__266, 0, Shape__256_0NumDims, this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__152 = cast(int32(extractdata(Hemorrhage_UNet__151)), 'like', Hemorrhage_UNet__151);
            Hemorrhage_UNet__152NumDims = Hemorrhage_UNet__151NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__156NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__152, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', Hemorrhage_UNet__152NumDims);
            Hemorrhage_UNet__156 = Hemorrhage_UNet__152(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__157NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__152, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__152NumDims);
            Hemorrhage_UNet__157 = Hemorrhage_UNet__152(Indices{:});

            % Concat:
            [Hemorrhage_UNet__155, Hemorrhage_UNet__155NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__156, this.Vars.Hemorrhage_UNet__154, Hemorrhage_UNet__157}, [Hemorrhage_UNet__156NumDims, this.NumDims.Hemorrhage_UNet__154, Hemorrhage_UNet__157NumDims]);

            % Cast:
            Hemorrhage_UNet__150 = cast(int64(extractdata(Hemorrhage_UNet__155)), 'like', Hemorrhage_UNet__155);
            Hemorrhage_UNet__150NumDims = Hemorrhage_UNet__155NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__149NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Transpose__222_0, Hemorrhage_UNet__150, Transpose__222_0NumDims, 0);
            Hemorrhage_UNet__149 = reshape(Transpose__222_0, shape{:});

            % Unsqueeze:
            [shape, Hemorrhage_UNet__158NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__149, this.Vars.const_fold_opt__286, Hemorrhage_UNet__149NumDims);
            Hemorrhage_UNet__158 = reshape(Hemorrhage_UNet__149, shape);

            % Tile:
            [sz, Hemorrhage_UNet__163NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__163 = repmat(Hemorrhage_UNet__158, sz);

            % Shape:
            [Hemorrhage_UNet__161, Hemorrhage_UNet__161NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet__149, Hemorrhage_UNet__149NumDims, 0, Hemorrhage_UNet__149NumDims+1);

            % Cast:
            Hemorrhage_UNet__162 = cast(int32(extractdata(Hemorrhage_UNet__161)), 'like', Hemorrhage_UNet__161);
            Hemorrhage_UNet__162NumDims = Hemorrhage_UNet__161NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__165NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__162, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', Hemorrhage_UNet__162NumDims);
            Hemorrhage_UNet__165 = Hemorrhage_UNet__162(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__166NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__162, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__162NumDims);
            Hemorrhage_UNet__166 = Hemorrhage_UNet__162(Indices{:});

            % Concat:
            [Hemorrhage_UNet__164, Hemorrhage_UNet__164NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__165, this.Vars.Hemorrhage_UNet__154, Hemorrhage_UNet__166}, [Hemorrhage_UNet__165NumDims, this.NumDims.Hemorrhage_UNet__154, Hemorrhage_UNet__166NumDims]);

            % Cast:
            Hemorrhage_UNet__160 = cast(int64(extractdata(Hemorrhage_UNet__164)), 'like', Hemorrhage_UNet__164);
            Hemorrhage_UNet__160NumDims = Hemorrhage_UNet__164NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__159NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Hemorrhage_UNet__163, Hemorrhage_UNet__160, Hemorrhage_UNet__163NumDims, 0);
            Hemorrhage_UNet__159 = reshape(Hemorrhage_UNet__163, shape{:});

            % Set graph output arguments
            Hemorrhage_UNet__159NumDims1005 = Hemorrhage_UNet__159NumDims;

        end

    end

end