classdef Shape_To_ReshapeLayer1001 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = microaneurysm_model.coder.Shape_To_ReshapeLayer1001(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = microaneurysm_model.Shape_To_ReshapeLayer1001(cgInstance.Name);
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
        function this = Shape_To_ReshapeLayer1001(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'functional_1_up_s_30'};
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

        function [functional_1_up_s_30] = predict(this, functional_1_batc_39__)
            if isdlarray(functional_1_batc_39__)
                functional_1_batc_39_ = stripdims(functional_1_batc_39__);
            else
                functional_1_batc_39_ = functional_1_batc_39__;
            end
            functional_1_batc_39NumDims = 4;
            functional_1_batc_39 = microaneurysm_model.coder.ops.permuteInputVar(functional_1_batc_39_, [4 3 1 2], 4);

            [functional_1_up_s_30__, functional_1_up_s_30NumDims__] = Shape_To_ReshapeGraph1003(this, functional_1_batc_39, functional_1_batc_39NumDims, false);
            functional_1_up_s_30_ = microaneurysm_model.coder.ops.permuteOutputVar(functional_1_up_s_30__, [2 3 4 1], 4);

            functional_1_up_s_30 = dlarray(single(functional_1_up_s_30_), 'SSCB');
        end

        function [functional_1_up_s_30, functional_1_up_s_30NumDims1005] = Shape_To_ReshapeGraph1003(this, functional_1_batc_39, functional_1_batc_39NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__266_0, Shape__266_0NumDims] = microaneurysm_model.coder.ops.onnxShape(functional_1_batc_39, coder.const(functional_1_batc_39NumDims), 0, coder.const(functional_1_batc_39NumDims)+1);

            % Gather:
            [functional_1_up_s_22, functional_1_up_s_22NumDims] = microaneurysm_model.coder.ops.onnxGather(Shape__266_0, this.Vars.Const__268, 0, coder.const(Shape__266_0NumDims), this.NumDims.Const__268);

            % Cast:
            functional_1_up_s_23 = cast(int32(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_22)), 'like', functional_1_up_s_22);
            functional_1_up_s_23NumDims = coder.const(functional_1_up_s_22NumDims);

            % Slice:
            [indices1011, functional_1_up_s_27NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_23, this.Vars.const_axes__126, this.Vars.const_ends__61, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_23NumDims));
            functional_1_up_s_27 = functional_1_up_s_23(indices1011{:});

            % Slice:
            [indices1012, functional_1_up_s_28NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_23, this.Vars.const_starts__89, this.Vars.const_ends__134, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_23NumDims));
            functional_1_up_s_28 = functional_1_up_s_23(indices1012{:});

            % Concat:
            [functional_1_up_s_26, functional_1_up_s_26NumDims] = microaneurysm_model.coder.ops.onnxConcat(0, {functional_1_up_s_27, this.Vars.functional_1_up_s_25, functional_1_up_s_28}, [coder.const(functional_1_up_s_27NumDims), this.NumDims.functional_1_up_s_25, coder.const(functional_1_up_s_28NumDims)]);

            % Cast:
            functional_1_up_s_21 = cast(int64(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_26)), 'like', functional_1_up_s_26);
            functional_1_up_s_21NumDims = coder.const(functional_1_up_s_26NumDims);

            % Unsqueeze:
            [shape1013, functional_1_up_s_19NumDims] = microaneurysm_model.coder.ops.prepareUnsqueezeArgs(functional_1_batc_39, this.Vars.const_starts__89__33, coder.const(functional_1_batc_39NumDims));
            functional_1_up_s_19 = reshape(functional_1_batc_39, shape1013);

            % Tile:
            [sz1014, functional_1_up_s_24NumDims] = microaneurysm_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_24 = repmat(functional_1_up_s_19, sz1014);

            % Transpose:
            [perm1015, Transpose__218_0NumDims] = microaneurysm_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1004, coder.const(functional_1_up_s_24NumDims));
            if isempty(perm1015)
                Transpose__218_0 = functional_1_up_s_24;
            else
                Transpose__218_0 = permute(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_24), perm1015);
            end

            % Reshape:
            [shape1016, functional_1_up_s_20NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(Transpose__218_0, functional_1_up_s_21, coder.const(Transpose__218_0NumDims), 0);
            functional_1_up_s_20 = reshape(Transpose__218_0, shape1016{:});

            % Unsqueeze:
            [shape1017, functional_1_up_s_29NumDims] = microaneurysm_model.coder.ops.prepareUnsqueezeArgs(functional_1_up_s_20, this.Vars.const_starts__89__33, coder.const(functional_1_up_s_20NumDims));
            functional_1_up_s_29 = reshape(functional_1_up_s_20, shape1017);

            % Tile:
            [sz1018, functional_1_up_s_34NumDims] = microaneurysm_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_34 = repmat(functional_1_up_s_29, sz1018);

            % Shape:
            [functional_1_up_s_32, functional_1_up_s_32NumDims] = microaneurysm_model.coder.ops.onnxShape(functional_1_up_s_20, coder.const(functional_1_up_s_20NumDims), 0, coder.const(functional_1_up_s_20NumDims)+1);

            % Cast:
            functional_1_up_s_33 = cast(int32(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_32)), 'like', functional_1_up_s_32);
            functional_1_up_s_33NumDims = coder.const(functional_1_up_s_32NumDims);

            % Slice:
            [indices1019, functional_1_up_s_36NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_33, this.Vars.const_axes__126, this.Vars.const_starts__89, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_33NumDims));
            functional_1_up_s_36 = functional_1_up_s_33(indices1019{:});

            % Slice:
            [indices1020, functional_1_up_s_37NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_33, this.Vars.const_starts__89__33, this.Vars.const_ends__134, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_33NumDims));
            functional_1_up_s_37 = functional_1_up_s_33(indices1020{:});

            % Concat:
            [functional_1_up_s_35, functional_1_up_s_35NumDims] = microaneurysm_model.coder.ops.onnxConcat(0, {functional_1_up_s_36, this.Vars.functional_1_up_s_25, functional_1_up_s_37}, [coder.const(functional_1_up_s_36NumDims), this.NumDims.functional_1_up_s_25, coder.const(functional_1_up_s_37NumDims)]);

            % Cast:
            functional_1_up_s_31 = cast(int64(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_35)), 'like', functional_1_up_s_35);
            functional_1_up_s_31NumDims = coder.const(functional_1_up_s_35NumDims);

            % Reshape:
            [shape1021, functional_1_up_s_30NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(functional_1_up_s_34, functional_1_up_s_31, coder.const(functional_1_up_s_34NumDims), 0);
            functional_1_up_s_30 = reshape(functional_1_up_s_34, shape1021{:});

            % Set graph output arguments
            functional_1_up_s_30NumDims1005 = coder.const(functional_1_up_s_30NumDims);

        end

    end

end