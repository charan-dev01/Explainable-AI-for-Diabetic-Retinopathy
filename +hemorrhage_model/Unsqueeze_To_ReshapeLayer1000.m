classdef Unsqueeze_To_ReshapeLayer1000 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1000';
        end
    end


    methods
        function this = Unsqueeze_To_ReshapeLayer1000(name)
            this.Name = name;
            this.OutputNames = {'Hemorrhage_UNet__139'};
        end

        function [Hemorrhage_UNet__139] = predict(this, Hemorrhage_UNet_1_77)
            if isdlarray(Hemorrhage_UNet_1_77)
                Hemorrhage_UNet_1_77 = stripdims(Hemorrhage_UNet_1_77);
            end
            Hemorrhage_UNet_1_77NumDims = 4;
            Hemorrhage_UNet_1_77 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_77, [4 3 1 2], 4);

            [Hemorrhage_UNet__139, Hemorrhage_UNet__139NumDims] = Unsqueeze_To_ReshapeGraph1000(this, Hemorrhage_UNet_1_77, Hemorrhage_UNet_1_77NumDims, false);
            Hemorrhage_UNet__139 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__139, [2 3 4 1], 4);

            Hemorrhage_UNet__139 = dlarray(single(Hemorrhage_UNet__139), 'SSCB');
        end

        function [Hemorrhage_UNet__139] = forward(this, Hemorrhage_UNet_1_77)
            if isdlarray(Hemorrhage_UNet_1_77)
                Hemorrhage_UNet_1_77 = stripdims(Hemorrhage_UNet_1_77);
            end
            Hemorrhage_UNet_1_77NumDims = 4;
            Hemorrhage_UNet_1_77 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_77, [4 3 1 2], 4);

            [Hemorrhage_UNet__139, Hemorrhage_UNet__139NumDims] = Unsqueeze_To_ReshapeGraph1000(this, Hemorrhage_UNet_1_77, Hemorrhage_UNet_1_77NumDims, true);
            Hemorrhage_UNet__139 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__139, [2 3 4 1], 4);

            Hemorrhage_UNet__139 = dlarray(single(Hemorrhage_UNet__139), 'SSCB');
        end

        function [Hemorrhage_UNet__139, Hemorrhage_UNet__139NumDims1002] = Unsqueeze_To_ReshapeGraph1000(this, Hemorrhage_UNet_1_77, Hemorrhage_UNet_1_77NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape, Hemorrhage_UNet_1_upNumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_77, this.Vars.const_fold_opt__286, Hemorrhage_UNet_1_77NumDims);
            Hemorrhage_UNet_1_up = reshape(Hemorrhage_UNet_1_77, shape);

            % Tile:
            [sz, Hemorrhage_UNet__134NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__134 = repmat(Hemorrhage_UNet_1_up, sz);

            % Transpose:
            [perm, Transpose__218_0NumDims] = hemorrhage_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1001, Hemorrhage_UNet__134NumDims);
            if isempty(perm)
                Transpose__218_0 = Hemorrhage_UNet__134;
            else
                Transpose__218_0 = permute(Hemorrhage_UNet__134, perm);
            end

            % Shape:
            [Shape__252_0, Shape__252_0NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet_1_77, Hemorrhage_UNet_1_77NumDims, 0, Hemorrhage_UNet_1_77NumDims+1);

            % Gather:
            [Hemorrhage_UNet__132, Hemorrhage_UNet__132NumDims] = hemorrhage_model.ops.onnxGather(Shape__252_0, this.Vars.Const__266, 0, Shape__252_0NumDims, this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__133 = cast(int32(extractdata(Hemorrhage_UNet__132)), 'like', Hemorrhage_UNet__132);
            Hemorrhage_UNet__133NumDims = Hemorrhage_UNet__132NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__136NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__133, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', Hemorrhage_UNet__133NumDims);
            Hemorrhage_UNet__136 = Hemorrhage_UNet__133(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__137NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__133, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__133NumDims);
            Hemorrhage_UNet__137 = Hemorrhage_UNet__133(Indices{:});

            % Concat:
            [Hemorrhage_UNet__135, Hemorrhage_UNet__135NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__136, this.Vars.Hemorrhage_UNet__144, Hemorrhage_UNet__137}, [Hemorrhage_UNet__136NumDims, this.NumDims.Hemorrhage_UNet__144, Hemorrhage_UNet__137NumDims]);

            % Cast:
            Hemorrhage_UNet__131 = cast(int64(extractdata(Hemorrhage_UNet__135)), 'like', Hemorrhage_UNet__135);
            Hemorrhage_UNet__131NumDims = Hemorrhage_UNet__135NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__130NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Transpose__218_0, Hemorrhage_UNet__131, Transpose__218_0NumDims, 0);
            Hemorrhage_UNet__130 = reshape(Transpose__218_0, shape{:});

            % Unsqueeze:
            [shape, Hemorrhage_UNet__138NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__130, this.Vars.const_fold_opt__286, Hemorrhage_UNet__130NumDims);
            Hemorrhage_UNet__138 = reshape(Hemorrhage_UNet__130, shape);

            % Tile:
            [sz, Hemorrhage_UNet__143NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__143 = repmat(Hemorrhage_UNet__138, sz);

            % Shape:
            [Hemorrhage_UNet__141, Hemorrhage_UNet__141NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet__130, Hemorrhage_UNet__130NumDims, 0, Hemorrhage_UNet__130NumDims+1);

            % Cast:
            Hemorrhage_UNet__142 = cast(int32(extractdata(Hemorrhage_UNet__141)), 'like', Hemorrhage_UNet__141);
            Hemorrhage_UNet__142NumDims = Hemorrhage_UNet__141NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__146NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__142, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', Hemorrhage_UNet__142NumDims);
            Hemorrhage_UNet__146 = Hemorrhage_UNet__142(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__147NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__142, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__142NumDims);
            Hemorrhage_UNet__147 = Hemorrhage_UNet__142(Indices{:});

            % Concat:
            [Hemorrhage_UNet__145, Hemorrhage_UNet__145NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__146, this.Vars.Hemorrhage_UNet__144, Hemorrhage_UNet__147}, [Hemorrhage_UNet__146NumDims, this.NumDims.Hemorrhage_UNet__144, Hemorrhage_UNet__147NumDims]);

            % Cast:
            Hemorrhage_UNet__140 = cast(int64(extractdata(Hemorrhage_UNet__145)), 'like', Hemorrhage_UNet__145);
            Hemorrhage_UNet__140NumDims = Hemorrhage_UNet__145NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__139NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Hemorrhage_UNet__143, Hemorrhage_UNet__140, Hemorrhage_UNet__143NumDims, 0);
            Hemorrhage_UNet__139 = reshape(Hemorrhage_UNet__143, shape{:});

            % Set graph output arguments
            Hemorrhage_UNet__139NumDims1002 = Hemorrhage_UNet__139NumDims;

        end

    end

end