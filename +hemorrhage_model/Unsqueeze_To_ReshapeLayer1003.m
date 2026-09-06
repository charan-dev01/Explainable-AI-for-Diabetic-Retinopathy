classdef Unsqueeze_To_ReshapeLayer1003 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1003';
        end
    end


    methods
        function this = Unsqueeze_To_ReshapeLayer1003(name)
            this.Name = name;
            this.OutputNames = {'Hemorrhage_UNet__196'};
        end

        function [Hemorrhage_UNet__196] = predict(this, Hemorrhage_UNet_1_30)
            if isdlarray(Hemorrhage_UNet_1_30)
                Hemorrhage_UNet_1_30 = stripdims(Hemorrhage_UNet_1_30);
            end
            Hemorrhage_UNet_1_30NumDims = 4;
            Hemorrhage_UNet_1_30 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_30, [4 3 1 2], 4);

            [Hemorrhage_UNet__196, Hemorrhage_UNet__196NumDims] = Unsqueeze_To_ReshapeGraph1009(this, Hemorrhage_UNet_1_30, Hemorrhage_UNet_1_30NumDims, false);
            Hemorrhage_UNet__196 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__196, [2 3 4 1], 4);

            Hemorrhage_UNet__196 = dlarray(single(Hemorrhage_UNet__196), 'SSCB');
        end

        function [Hemorrhage_UNet__196] = forward(this, Hemorrhage_UNet_1_30)
            if isdlarray(Hemorrhage_UNet_1_30)
                Hemorrhage_UNet_1_30 = stripdims(Hemorrhage_UNet_1_30);
            end
            Hemorrhage_UNet_1_30NumDims = 4;
            Hemorrhage_UNet_1_30 = hemorrhage_model.ops.permuteInputVar(Hemorrhage_UNet_1_30, [4 3 1 2], 4);

            [Hemorrhage_UNet__196, Hemorrhage_UNet__196NumDims] = Unsqueeze_To_ReshapeGraph1009(this, Hemorrhage_UNet_1_30, Hemorrhage_UNet_1_30NumDims, true);
            Hemorrhage_UNet__196 = hemorrhage_model.ops.permuteOutputVar(Hemorrhage_UNet__196, [2 3 4 1], 4);

            Hemorrhage_UNet__196 = dlarray(single(Hemorrhage_UNet__196), 'SSCB');
        end

        function [Hemorrhage_UNet__196, Hemorrhage_UNet__196NumDims1011] = Unsqueeze_To_ReshapeGraph1009(this, Hemorrhage_UNet_1_30, Hemorrhage_UNet_1_30NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape, Hemorrhage_UNet__186NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_30, this.Vars.const_fold_opt__286, Hemorrhage_UNet_1_30NumDims);
            Hemorrhage_UNet__186 = reshape(Hemorrhage_UNet_1_30, shape);

            % Tile:
            [sz, Hemorrhage_UNet__191NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__191 = repmat(Hemorrhage_UNet__186, sz);

            % Transpose:
            [perm, Transpose__232_0NumDims] = hemorrhage_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1010, Hemorrhage_UNet__191NumDims);
            if isempty(perm)
                Transpose__232_0 = Hemorrhage_UNet__191;
            else
                Transpose__232_0 = permute(Hemorrhage_UNet__191, perm);
            end

            % Shape:
            [Shape__264_0, Shape__264_0NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet_1_30, Hemorrhage_UNet_1_30NumDims, 0, Hemorrhage_UNet_1_30NumDims+1);

            % Gather:
            [Hemorrhage_UNet__189, Hemorrhage_UNet__189NumDims] = hemorrhage_model.ops.onnxGather(Shape__264_0, this.Vars.Const__266, 0, Shape__264_0NumDims, this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__190 = cast(int32(extractdata(Hemorrhage_UNet__189)), 'like', Hemorrhage_UNet__189);
            Hemorrhage_UNet__190NumDims = Hemorrhage_UNet__189NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__193NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__190, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', Hemorrhage_UNet__190NumDims);
            Hemorrhage_UNet__193 = Hemorrhage_UNet__190(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__194NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__190, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__190NumDims);
            Hemorrhage_UNet__194 = Hemorrhage_UNet__190(Indices{:});

            % Concat:
            [Hemorrhage_UNet__192, Hemorrhage_UNet__192NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__193, this.Vars.Hemorrhage_UNet__201, Hemorrhage_UNet__194}, [Hemorrhage_UNet__193NumDims, this.NumDims.Hemorrhage_UNet__201, Hemorrhage_UNet__194NumDims]);

            % Cast:
            Hemorrhage_UNet__188 = cast(int64(extractdata(Hemorrhage_UNet__192)), 'like', Hemorrhage_UNet__192);
            Hemorrhage_UNet__188NumDims = Hemorrhage_UNet__192NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__187NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Transpose__232_0, Hemorrhage_UNet__188, Transpose__232_0NumDims, 0);
            Hemorrhage_UNet__187 = reshape(Transpose__232_0, shape{:});

            % Unsqueeze:
            [shape, Hemorrhage_UNet__195NumDims] = hemorrhage_model.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__187, this.Vars.const_fold_opt__286, Hemorrhage_UNet__187NumDims);
            Hemorrhage_UNet__195 = reshape(Hemorrhage_UNet__187, shape);

            % Tile:
            [sz, Hemorrhage_UNet__200NumDims] = hemorrhage_model.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__200 = repmat(Hemorrhage_UNet__195, sz);

            % Shape:
            [Hemorrhage_UNet__198, Hemorrhage_UNet__198NumDims] = hemorrhage_model.ops.onnxShape(Hemorrhage_UNet__187, Hemorrhage_UNet__187NumDims, 0, Hemorrhage_UNet__187NumDims+1);

            % Cast:
            Hemorrhage_UNet__199 = cast(int32(extractdata(Hemorrhage_UNet__198)), 'like', Hemorrhage_UNet__198);
            Hemorrhage_UNet__199NumDims = Hemorrhage_UNet__198NumDims;

            % Slice:
            [Indices, Hemorrhage_UNet__203NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__199, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', Hemorrhage_UNet__199NumDims);
            Hemorrhage_UNet__203 = Hemorrhage_UNet__199(Indices{:});

            % Slice:
            [Indices, Hemorrhage_UNet__204NumDims] = hemorrhage_model.ops.prepareSliceArgs(Hemorrhage_UNet__199, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', Hemorrhage_UNet__199NumDims);
            Hemorrhage_UNet__204 = Hemorrhage_UNet__199(Indices{:});

            % Concat:
            [Hemorrhage_UNet__202, Hemorrhage_UNet__202NumDims] = hemorrhage_model.ops.onnxConcat(0, {Hemorrhage_UNet__203, this.Vars.Hemorrhage_UNet__201, Hemorrhage_UNet__204}, [Hemorrhage_UNet__203NumDims, this.NumDims.Hemorrhage_UNet__201, Hemorrhage_UNet__204NumDims]);

            % Cast:
            Hemorrhage_UNet__197 = cast(int64(extractdata(Hemorrhage_UNet__202)), 'like', Hemorrhage_UNet__202);
            Hemorrhage_UNet__197NumDims = Hemorrhage_UNet__202NumDims;

            % Reshape:
            [shape, Hemorrhage_UNet__196NumDims] = hemorrhage_model.ops.prepareReshapeArgs(Hemorrhage_UNet__200, Hemorrhage_UNet__197, Hemorrhage_UNet__200NumDims, 0);
            Hemorrhage_UNet__196 = reshape(Hemorrhage_UNet__200, shape{:});

            % Set graph output arguments
            Hemorrhage_UNet__196NumDims1011 = Hemorrhage_UNet__196NumDims;

        end

    end

end