classdef Shape_To_ReshapeLayer1000 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = microaneurysm_model.coder.Shape_To_ReshapeLayer1000(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = microaneurysm_model.Shape_To_ReshapeLayer1000(cgInstance.Name);
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
        function this = Shape_To_ReshapeLayer1000(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'functional_1_up_s_10'};
            if isstruct(mlInstance.Vars)
                names = fieldnames(mlInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this.Vars.(fieldname) = microaneurysm_model.coder.ops.extractIfDlarray(mlInstance.Vars.(fieldname));
                end
            else
                this.Vars = [];
            end

            this.NumDims = mlInstance.NumDims;
        end

        function [functional_1_up_s_10] = predict(this, functional_1_batc_33__)
            if isdlarray(functional_1_batc_33__)
                functional_1_batc_33_ = stripdims(functional_1_batc_33__);
            else
                functional_1_batc_33_ = functional_1_batc_33__;
            end
            functional_1_batc_33NumDims = 4;
            functional_1_batc_33 = microaneurysm_model.coder.ops.permuteInputVar(functional_1_batc_33_, [4 3 1 2], 4);

            [functional_1_up_s_10__, functional_1_up_s_10NumDims__] = Shape_To_ReshapeGraph1000(this, functional_1_batc_33, functional_1_batc_33NumDims, false);
            functional_1_up_s_10_ = microaneurysm_model.coder.ops.permuteOutputVar(functional_1_up_s_10__, [2 3 4 1], 4);

            functional_1_up_s_10 = dlarray(single(functional_1_up_s_10_), 'SSCB');
        end

        function [functional_1_up_s_10, functional_1_up_s_10NumDims1002] = Shape_To_ReshapeGraph1000(this, functional_1_batc_33, functional_1_batc_33NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__262_0, Shape__262_0NumDims] = microaneurysm_model.coder.ops.onnxShape(functional_1_batc_33, coder.const(functional_1_batc_33NumDims), 0, coder.const(functional_1_batc_33NumDims)+1);

            % Gather:
            [functional_1_up_sa_3, functional_1_up_sa_3NumDims] = microaneurysm_model.coder.ops.onnxGather(Shape__262_0, this.Vars.Const__268, 0, coder.const(Shape__262_0NumDims), this.NumDims.Const__268);

            % Cast:
            functional_1_up_sa_4 = cast(int32(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_sa_3)), 'like', functional_1_up_sa_3);
            functional_1_up_sa_4NumDims = coder.const(functional_1_up_sa_3NumDims);

            % Slice:
            [indices1000, functional_1_up_sa_7NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_sa_4, this.Vars.const_axes__126, this.Vars.const_ends__61, this.Vars.const_axes__126, '', coder.const(functional_1_up_sa_4NumDims));
            functional_1_up_sa_7 = functional_1_up_sa_4(indices1000{:});

            % Slice:
            [indices1001, functional_1_up_sa_8NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_sa_4, this.Vars.const_starts__89, this.Vars.const_ends__134, this.Vars.const_axes__126, '', coder.const(functional_1_up_sa_4NumDims));
            functional_1_up_sa_8 = functional_1_up_sa_4(indices1001{:});

            % Concat:
            [functional_1_up_sa_6, functional_1_up_sa_6NumDims] = microaneurysm_model.coder.ops.onnxConcat(0, {functional_1_up_sa_7, this.Vars.functional_1_up_s_15, functional_1_up_sa_8}, [coder.const(functional_1_up_sa_7NumDims), this.NumDims.functional_1_up_s_15, coder.const(functional_1_up_sa_8NumDims)]);

            % Cast:
            functional_1_up_sa_2 = cast(int64(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_sa_6)), 'like', functional_1_up_sa_6);
            functional_1_up_sa_2NumDims = coder.const(functional_1_up_sa_6NumDims);

            % Unsqueeze:
            [shape1002, functional_1_up_sampNumDims] = microaneurysm_model.coder.ops.prepareUnsqueezeArgs(functional_1_batc_33, this.Vars.const_starts__89__33, coder.const(functional_1_batc_33NumDims));
            functional_1_up_samp = reshape(functional_1_batc_33, shape1002);

            % Tile:
            [sz1003, functional_1_up_sa_5NumDims] = microaneurysm_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_sa_5 = repmat(functional_1_up_samp, sz1003);

            % Transpose:
            [perm1004, Transpose__202_0NumDims] = microaneurysm_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1001, coder.const(functional_1_up_sa_5NumDims));
            if isempty(perm1004)
                Transpose__202_0 = functional_1_up_sa_5;
            else
                Transpose__202_0 = permute(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_sa_5), perm1004);
            end

            % Reshape:
            [shape1005, functional_1_up_sa_1NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(Transpose__202_0, functional_1_up_sa_2, coder.const(Transpose__202_0NumDims), 0);
            functional_1_up_sa_1 = reshape(Transpose__202_0, shape1005{:});

            % Unsqueeze:
            [shape1006, functional_1_up_sa_9NumDims] = microaneurysm_model.coder.ops.prepareUnsqueezeArgs(functional_1_up_sa_1, this.Vars.const_starts__89__33, coder.const(functional_1_up_sa_1NumDims));
            functional_1_up_sa_9 = reshape(functional_1_up_sa_1, shape1006);

            % Tile:
            [sz1007, functional_1_up_s_14NumDims] = microaneurysm_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_14 = repmat(functional_1_up_sa_9, sz1007);

            % Shape:
            [functional_1_up_s_12, functional_1_up_s_12NumDims] = microaneurysm_model.coder.ops.onnxShape(functional_1_up_sa_1, coder.const(functional_1_up_sa_1NumDims), 0, coder.const(functional_1_up_sa_1NumDims)+1);

            % Cast:
            functional_1_up_s_13 = cast(int32(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_12)), 'like', functional_1_up_s_12);
            functional_1_up_s_13NumDims = coder.const(functional_1_up_s_12NumDims);

            % Slice:
            [indices1008, functional_1_up_s_17NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_13, this.Vars.const_axes__126, this.Vars.const_starts__89, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_13NumDims));
            functional_1_up_s_17 = functional_1_up_s_13(indices1008{:});

            % Slice:
            [indices1009, functional_1_up_s_18NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_13, this.Vars.const_starts__89__33, this.Vars.const_ends__134, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_13NumDims));
            functional_1_up_s_18 = functional_1_up_s_13(indices1009{:});

            % Concat:
            [functional_1_up_s_16, functional_1_up_s_16NumDims] = microaneurysm_model.coder.ops.onnxConcat(0, {functional_1_up_s_17, this.Vars.functional_1_up_s_15, functional_1_up_s_18}, [coder.const(functional_1_up_s_17NumDims), this.NumDims.functional_1_up_s_15, coder.const(functional_1_up_s_18NumDims)]);

            % Cast:
            functional_1_up_s_11 = cast(int64(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_16)), 'like', functional_1_up_s_16);
            functional_1_up_s_11NumDims = coder.const(functional_1_up_s_16NumDims);

            % Reshape:
            [shape1010, functional_1_up_s_10NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(functional_1_up_s_14, functional_1_up_s_11, coder.const(functional_1_up_s_14NumDims), 0);
            functional_1_up_s_10 = reshape(functional_1_up_s_14, shape1010{:});

            % Set graph output arguments
            functional_1_up_s_10NumDims1002 = coder.const(functional_1_up_s_10NumDims);

        end

    end

end