classdef Shape_To_ReshapeLayer1000 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'microaneurysm_model.coder.Shape_To_ReshapeLayer1000';
        end
    end


    methods
        function this = Shape_To_ReshapeLayer1000(name)
            this.Name = name;
            this.OutputNames = {'functional_1_up_s_10'};
        end

        function [functional_1_up_s_10] = predict(this, functional_1_batc_33)
            if isdlarray(functional_1_batc_33)
                functional_1_batc_33 = stripdims(functional_1_batc_33);
            end
            functional_1_batc_33NumDims = 4;
            functional_1_batc_33 = microaneurysm_model.ops.permuteInputVar(functional_1_batc_33, [4 3 1 2], 4);

            [functional_1_up_s_10, functional_1_up_s_10NumDims] = Shape_To_ReshapeGraph1000(this, functional_1_batc_33, functional_1_batc_33NumDims, false);
            functional_1_up_s_10 = microaneurysm_model.ops.permuteOutputVar(functional_1_up_s_10, [2 3 4 1], 4);

            functional_1_up_s_10 = dlarray(single(functional_1_up_s_10), 'SSCB');
        end

        function [functional_1_up_s_10] = forward(this, functional_1_batc_33)
            if isdlarray(functional_1_batc_33)
                functional_1_batc_33 = stripdims(functional_1_batc_33);
            end
            functional_1_batc_33NumDims = 4;
            functional_1_batc_33 = microaneurysm_model.ops.permuteInputVar(functional_1_batc_33, [4 3 1 2], 4);

            [functional_1_up_s_10, functional_1_up_s_10NumDims] = Shape_To_ReshapeGraph1000(this, functional_1_batc_33, functional_1_batc_33NumDims, true);
            functional_1_up_s_10 = microaneurysm_model.ops.permuteOutputVar(functional_1_up_s_10, [2 3 4 1], 4);

            functional_1_up_s_10 = dlarray(single(functional_1_up_s_10), 'SSCB');
        end

        function [functional_1_up_s_10, functional_1_up_s_10NumDims1002] = Shape_To_ReshapeGraph1000(this, functional_1_batc_33, functional_1_batc_33NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__262_0, Shape__262_0NumDims] = microaneurysm_model.ops.onnxShape(functional_1_batc_33, functional_1_batc_33NumDims, 0, functional_1_batc_33NumDims+1);

            % Gather:
            [functional_1_up_sa_3, functional_1_up_sa_3NumDims] = microaneurysm_model.ops.onnxGather(Shape__262_0, this.Vars.Const__268, 0, Shape__262_0NumDims, this.NumDims.Const__268);

            % Cast:
            functional_1_up_sa_4 = cast(int32(extractdata(functional_1_up_sa_3)), 'like', functional_1_up_sa_3);
            functional_1_up_sa_4NumDims = functional_1_up_sa_3NumDims;

            % Slice:
            [Indices, functional_1_up_sa_7NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_sa_4, this.Vars.const_axes__126, this.Vars.const_ends__61, this.Vars.const_axes__126, '', functional_1_up_sa_4NumDims);
            functional_1_up_sa_7 = functional_1_up_sa_4(Indices{:});

            % Slice:
            [Indices, functional_1_up_sa_8NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_sa_4, this.Vars.const_starts__89, this.Vars.const_ends__134, this.Vars.const_axes__126, '', functional_1_up_sa_4NumDims);
            functional_1_up_sa_8 = functional_1_up_sa_4(Indices{:});

            % Concat:
            [functional_1_up_sa_6, functional_1_up_sa_6NumDims] = microaneurysm_model.ops.onnxConcat(0, {functional_1_up_sa_7, this.Vars.functional_1_up_s_15, functional_1_up_sa_8}, [functional_1_up_sa_7NumDims, this.NumDims.functional_1_up_s_15, functional_1_up_sa_8NumDims]);

            % Cast:
            functional_1_up_sa_2 = cast(int64(extractdata(functional_1_up_sa_6)), 'like', functional_1_up_sa_6);
            functional_1_up_sa_2NumDims = functional_1_up_sa_6NumDims;

            % Unsqueeze:
            [shape, functional_1_up_sampNumDims] = microaneurysm_model.ops.prepareUnsqueezeArgs(functional_1_batc_33, this.Vars.const_starts__89__33, functional_1_batc_33NumDims);
            functional_1_up_samp = reshape(functional_1_batc_33, shape);

            % Tile:
            [sz, functional_1_up_sa_5NumDims] = microaneurysm_model.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_sa_5 = repmat(functional_1_up_samp, sz);

            % Transpose:
            [perm, Transpose__202_0NumDims] = microaneurysm_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1001, functional_1_up_sa_5NumDims);
            if isempty(perm)
                Transpose__202_0 = functional_1_up_sa_5;
            else
                Transpose__202_0 = permute(functional_1_up_sa_5, perm);
            end

            % Reshape:
            [shape, functional_1_up_sa_1NumDims] = microaneurysm_model.ops.prepareReshapeArgs(Transpose__202_0, functional_1_up_sa_2, Transpose__202_0NumDims, 0);
            functional_1_up_sa_1 = reshape(Transpose__202_0, shape{:});

            % Unsqueeze:
            [shape, functional_1_up_sa_9NumDims] = microaneurysm_model.ops.prepareUnsqueezeArgs(functional_1_up_sa_1, this.Vars.const_starts__89__33, functional_1_up_sa_1NumDims);
            functional_1_up_sa_9 = reshape(functional_1_up_sa_1, shape);

            % Tile:
            [sz, functional_1_up_s_14NumDims] = microaneurysm_model.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_14 = repmat(functional_1_up_sa_9, sz);

            % Shape:
            [functional_1_up_s_12, functional_1_up_s_12NumDims] = microaneurysm_model.ops.onnxShape(functional_1_up_sa_1, functional_1_up_sa_1NumDims, 0, functional_1_up_sa_1NumDims+1);

            % Cast:
            functional_1_up_s_13 = cast(int32(extractdata(functional_1_up_s_12)), 'like', functional_1_up_s_12);
            functional_1_up_s_13NumDims = functional_1_up_s_12NumDims;

            % Slice:
            [Indices, functional_1_up_s_17NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_13, this.Vars.const_axes__126, this.Vars.const_starts__89, this.Vars.const_axes__126, '', functional_1_up_s_13NumDims);
            functional_1_up_s_17 = functional_1_up_s_13(Indices{:});

            % Slice:
            [Indices, functional_1_up_s_18NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_13, this.Vars.const_starts__89__33, this.Vars.const_ends__134, this.Vars.const_axes__126, '', functional_1_up_s_13NumDims);
            functional_1_up_s_18 = functional_1_up_s_13(Indices{:});

            % Concat:
            [functional_1_up_s_16, functional_1_up_s_16NumDims] = microaneurysm_model.ops.onnxConcat(0, {functional_1_up_s_17, this.Vars.functional_1_up_s_15, functional_1_up_s_18}, [functional_1_up_s_17NumDims, this.NumDims.functional_1_up_s_15, functional_1_up_s_18NumDims]);

            % Cast:
            functional_1_up_s_11 = cast(int64(extractdata(functional_1_up_s_16)), 'like', functional_1_up_s_16);
            functional_1_up_s_11NumDims = functional_1_up_s_16NumDims;

            % Reshape:
            [shape, functional_1_up_s_10NumDims] = microaneurysm_model.ops.prepareReshapeArgs(functional_1_up_s_14, functional_1_up_s_11, functional_1_up_s_14NumDims, 0);
            functional_1_up_s_10 = reshape(functional_1_up_s_14, shape{:});

            % Set graph output arguments
            functional_1_up_s_10NumDims1002 = functional_1_up_s_10NumDims;

        end

    end

end