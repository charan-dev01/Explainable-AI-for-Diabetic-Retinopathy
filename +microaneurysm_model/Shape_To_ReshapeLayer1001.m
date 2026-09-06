classdef Shape_To_ReshapeLayer1001 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'microaneurysm_model.coder.Shape_To_ReshapeLayer1001';
        end
    end


    methods
        function this = Shape_To_ReshapeLayer1001(name)
            this.Name = name;
            this.OutputNames = {'functional_1_up_s_30'};
        end

        function [functional_1_up_s_30] = predict(this, functional_1_batc_39)
            if isdlarray(functional_1_batc_39)
                functional_1_batc_39 = stripdims(functional_1_batc_39);
            end
            functional_1_batc_39NumDims = 4;
            functional_1_batc_39 = microaneurysm_model.ops.permuteInputVar(functional_1_batc_39, [4 3 1 2], 4);

            [functional_1_up_s_30, functional_1_up_s_30NumDims] = Shape_To_ReshapeGraph1003(this, functional_1_batc_39, functional_1_batc_39NumDims, false);
            functional_1_up_s_30 = microaneurysm_model.ops.permuteOutputVar(functional_1_up_s_30, [2 3 4 1], 4);

            functional_1_up_s_30 = dlarray(single(functional_1_up_s_30), 'SSCB');
        end

        function [functional_1_up_s_30] = forward(this, functional_1_batc_39)
            if isdlarray(functional_1_batc_39)
                functional_1_batc_39 = stripdims(functional_1_batc_39);
            end
            functional_1_batc_39NumDims = 4;
            functional_1_batc_39 = microaneurysm_model.ops.permuteInputVar(functional_1_batc_39, [4 3 1 2], 4);

            [functional_1_up_s_30, functional_1_up_s_30NumDims] = Shape_To_ReshapeGraph1003(this, functional_1_batc_39, functional_1_batc_39NumDims, true);
            functional_1_up_s_30 = microaneurysm_model.ops.permuteOutputVar(functional_1_up_s_30, [2 3 4 1], 4);

            functional_1_up_s_30 = dlarray(single(functional_1_up_s_30), 'SSCB');
        end

        function [functional_1_up_s_30, functional_1_up_s_30NumDims1005] = Shape_To_ReshapeGraph1003(this, functional_1_batc_39, functional_1_batc_39NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__266_0, Shape__266_0NumDims] = microaneurysm_model.ops.onnxShape(functional_1_batc_39, functional_1_batc_39NumDims, 0, functional_1_batc_39NumDims+1);

            % Gather:
            [functional_1_up_s_22, functional_1_up_s_22NumDims] = microaneurysm_model.ops.onnxGather(Shape__266_0, this.Vars.Const__268, 0, Shape__266_0NumDims, this.NumDims.Const__268);

            % Cast:
            functional_1_up_s_23 = cast(int32(extractdata(functional_1_up_s_22)), 'like', functional_1_up_s_22);
            functional_1_up_s_23NumDims = functional_1_up_s_22NumDims;

            % Slice:
            [Indices, functional_1_up_s_27NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_23, this.Vars.const_axes__126, this.Vars.const_ends__61, this.Vars.const_axes__126, '', functional_1_up_s_23NumDims);
            functional_1_up_s_27 = functional_1_up_s_23(Indices{:});

            % Slice:
            [Indices, functional_1_up_s_28NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_23, this.Vars.const_starts__89, this.Vars.const_ends__134, this.Vars.const_axes__126, '', functional_1_up_s_23NumDims);
            functional_1_up_s_28 = functional_1_up_s_23(Indices{:});

            % Concat:
            [functional_1_up_s_26, functional_1_up_s_26NumDims] = microaneurysm_model.ops.onnxConcat(0, {functional_1_up_s_27, this.Vars.functional_1_up_s_25, functional_1_up_s_28}, [functional_1_up_s_27NumDims, this.NumDims.functional_1_up_s_25, functional_1_up_s_28NumDims]);

            % Cast:
            functional_1_up_s_21 = cast(int64(extractdata(functional_1_up_s_26)), 'like', functional_1_up_s_26);
            functional_1_up_s_21NumDims = functional_1_up_s_26NumDims;

            % Unsqueeze:
            [shape, functional_1_up_s_19NumDims] = microaneurysm_model.ops.prepareUnsqueezeArgs(functional_1_batc_39, this.Vars.const_starts__89__33, functional_1_batc_39NumDims);
            functional_1_up_s_19 = reshape(functional_1_batc_39, shape);

            % Tile:
            [sz, functional_1_up_s_24NumDims] = microaneurysm_model.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_24 = repmat(functional_1_up_s_19, sz);

            % Transpose:
            [perm, Transpose__218_0NumDims] = microaneurysm_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1004, functional_1_up_s_24NumDims);
            if isempty(perm)
                Transpose__218_0 = functional_1_up_s_24;
            else
                Transpose__218_0 = permute(functional_1_up_s_24, perm);
            end

            % Reshape:
            [shape, functional_1_up_s_20NumDims] = microaneurysm_model.ops.prepareReshapeArgs(Transpose__218_0, functional_1_up_s_21, Transpose__218_0NumDims, 0);
            functional_1_up_s_20 = reshape(Transpose__218_0, shape{:});

            % Unsqueeze:
            [shape, functional_1_up_s_29NumDims] = microaneurysm_model.ops.prepareUnsqueezeArgs(functional_1_up_s_20, this.Vars.const_starts__89__33, functional_1_up_s_20NumDims);
            functional_1_up_s_29 = reshape(functional_1_up_s_20, shape);

            % Tile:
            [sz, functional_1_up_s_34NumDims] = microaneurysm_model.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_34 = repmat(functional_1_up_s_29, sz);

            % Shape:
            [functional_1_up_s_32, functional_1_up_s_32NumDims] = microaneurysm_model.ops.onnxShape(functional_1_up_s_20, functional_1_up_s_20NumDims, 0, functional_1_up_s_20NumDims+1);

            % Cast:
            functional_1_up_s_33 = cast(int32(extractdata(functional_1_up_s_32)), 'like', functional_1_up_s_32);
            functional_1_up_s_33NumDims = functional_1_up_s_32NumDims;

            % Slice:
            [Indices, functional_1_up_s_36NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_33, this.Vars.const_axes__126, this.Vars.const_starts__89, this.Vars.const_axes__126, '', functional_1_up_s_33NumDims);
            functional_1_up_s_36 = functional_1_up_s_33(Indices{:});

            % Slice:
            [Indices, functional_1_up_s_37NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_33, this.Vars.const_starts__89__33, this.Vars.const_ends__134, this.Vars.const_axes__126, '', functional_1_up_s_33NumDims);
            functional_1_up_s_37 = functional_1_up_s_33(Indices{:});

            % Concat:
            [functional_1_up_s_35, functional_1_up_s_35NumDims] = microaneurysm_model.ops.onnxConcat(0, {functional_1_up_s_36, this.Vars.functional_1_up_s_25, functional_1_up_s_37}, [functional_1_up_s_36NumDims, this.NumDims.functional_1_up_s_25, functional_1_up_s_37NumDims]);

            % Cast:
            functional_1_up_s_31 = cast(int64(extractdata(functional_1_up_s_35)), 'like', functional_1_up_s_35);
            functional_1_up_s_31NumDims = functional_1_up_s_35NumDims;

            % Reshape:
            [shape, functional_1_up_s_30NumDims] = microaneurysm_model.ops.prepareReshapeArgs(functional_1_up_s_34, functional_1_up_s_31, functional_1_up_s_34NumDims, 0);
            functional_1_up_s_30 = reshape(functional_1_up_s_34, shape{:});

            % Set graph output arguments
            functional_1_up_s_30NumDims1005 = functional_1_up_s_30NumDims;

        end

    end

end