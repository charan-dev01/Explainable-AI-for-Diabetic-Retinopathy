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
            this_cg = exudate_model.coder.Shape_To_ReshapeLayer1001(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = exudate_model.Shape_To_ReshapeLayer1001(cgInstance.Name);
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
            this.OutputNames = {'functional_3_1_up_10'};
            if isstruct(mlInstance.Vars)
                names = fieldnames(mlInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this.Vars.(fieldname) = exudate_model.coder.ops.extractIfDlarray(mlInstance.Vars.(fieldname));
                end
            else
                this.Vars = [];
            end

            this.NumDims = mlInstance.NumDims;
        end

        function [functional_3_1_up_10] = predict(this, functional_3_1_ba_27__)
            if isdlarray(functional_3_1_ba_27__)
                functional_3_1_ba_27_ = stripdims(functional_3_1_ba_27__);
            else
                functional_3_1_ba_27_ = functional_3_1_ba_27__;
            end
            functional_3_1_ba_27NumDims = 4;
            functional_3_1_ba_27 = exudate_model.coder.ops.permuteInputVar(functional_3_1_ba_27_, [4 3 1 2], 4);

            [functional_3_1_up_10__, functional_3_1_up_10NumDims__] = Shape_To_ReshapeGraph1003(this, functional_3_1_ba_27, functional_3_1_ba_27NumDims, false);
            functional_3_1_up_10_ = exudate_model.coder.ops.permuteOutputVar(functional_3_1_up_10__, [2 3 4 1], 4);

            functional_3_1_up_10 = dlarray(single(functional_3_1_up_10_), 'SSCB');
        end

        function [functional_3_1_up_10, functional_3_1_up_10NumDims1005] = Shape_To_ReshapeGraph1003(this, functional_3_1_ba_27, functional_3_1_ba_27NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__942_0, Shape__942_0NumDims] = exudate_model.coder.ops.onnxShape(functional_3_1_ba_27, coder.const(functional_3_1_ba_27NumDims), 0, coder.const(functional_3_1_ba_27NumDims)+1);

            % Gather:
            [functional_3_1_up__3, functional_3_1_up__3NumDims] = exudate_model.coder.ops.onnxGather(Shape__942_0, this.Vars.Const__940, 0, coder.const(Shape__942_0NumDims), this.NumDims.Const__940);

            % Cast:
            functional_3_1_up__4 = cast(int32(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up__3)), 'like', functional_3_1_up__3);
            functional_3_1_up__4NumDims = coder.const(functional_3_1_up__3NumDims);

            % Slice:
            [indices1011, functional_3_1_up__7NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up__4, this.Vars.const_axes__811, this.Vars.const_ends__801, this.Vars.const_axes__811, '', coder.const(functional_3_1_up__4NumDims));
            functional_3_1_up__7 = functional_3_1_up__4(indices1011{:});

            % Slice:
            [indices1012, functional_3_1_up__8NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up__4, this.Vars.const_starts__765, this.Vars.const_ends__810, this.Vars.const_axes__811, '', coder.const(functional_3_1_up__4NumDims));
            functional_3_1_up__8 = functional_3_1_up__4(indices1012{:});

            % Concat:
            [functional_3_1_up__6, functional_3_1_up__6NumDims] = exudate_model.coder.ops.onnxConcat(0, {functional_3_1_up__7, this.Vars.functional_3_1_up_15, functional_3_1_up__8}, [coder.const(functional_3_1_up__7NumDims), this.NumDims.functional_3_1_up_15, coder.const(functional_3_1_up__8NumDims)]);

            % Cast:
            functional_3_1_up__2 = cast(int64(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up__6)), 'like', functional_3_1_up__6);
            functional_3_1_up__2NumDims = coder.const(functional_3_1_up__6NumDims);

            % Unsqueeze:
            [shape1013, functional_3_1_up_saNumDims] = exudate_model.coder.ops.prepareUnsqueezeArgs(functional_3_1_ba_27, this.Vars.const_starts__809, coder.const(functional_3_1_ba_27NumDims));
            functional_3_1_up_sa = reshape(functional_3_1_ba_27, shape1013);

            % Tile:
            [sz1014, functional_3_1_up__5NumDims] = exudate_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up__5 = repmat(functional_3_1_up_sa, sz1014);

            % Transpose:
            [perm1015, Transpose__898_0NumDims] = exudate_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1004, coder.const(functional_3_1_up__5NumDims));
            if isempty(perm1015)
                Transpose__898_0 = functional_3_1_up__5;
            else
                Transpose__898_0 = permute(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up__5), perm1015);
            end

            % Reshape:
            [shape1016, functional_3_1_up__1NumDims] = exudate_model.coder.ops.prepareReshapeArgs(Transpose__898_0, functional_3_1_up__2, coder.const(Transpose__898_0NumDims), 0);
            functional_3_1_up__1 = reshape(Transpose__898_0, shape1016{:});

            % Unsqueeze:
            [shape1017, functional_3_1_up__9NumDims] = exudate_model.coder.ops.prepareUnsqueezeArgs(functional_3_1_up__1, this.Vars.const_starts__809, coder.const(functional_3_1_up__1NumDims));
            functional_3_1_up__9 = reshape(functional_3_1_up__1, shape1017);

            % Tile:
            [sz1018, functional_3_1_up_14NumDims] = exudate_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_14 = repmat(functional_3_1_up__9, sz1018);

            % Shape:
            [functional_3_1_up_12, functional_3_1_up_12NumDims] = exudate_model.coder.ops.onnxShape(functional_3_1_up__1, coder.const(functional_3_1_up__1NumDims), 0, coder.const(functional_3_1_up__1NumDims)+1);

            % Cast:
            functional_3_1_up_13 = cast(int32(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_12)), 'like', functional_3_1_up_12);
            functional_3_1_up_13NumDims = coder.const(functional_3_1_up_12NumDims);

            % Slice:
            [indices1019, functional_3_1_up_17NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_13, this.Vars.const_axes__811, this.Vars.const_starts__765, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_13NumDims));
            functional_3_1_up_17 = functional_3_1_up_13(indices1019{:});

            % Slice:
            [indices1020, functional_3_1_up_18NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_13, this.Vars.const_starts__809, this.Vars.const_ends__810, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_13NumDims));
            functional_3_1_up_18 = functional_3_1_up_13(indices1020{:});

            % Concat:
            [functional_3_1_up_16, functional_3_1_up_16NumDims] = exudate_model.coder.ops.onnxConcat(0, {functional_3_1_up_17, this.Vars.functional_3_1_up_15, functional_3_1_up_18}, [coder.const(functional_3_1_up_17NumDims), this.NumDims.functional_3_1_up_15, coder.const(functional_3_1_up_18NumDims)]);

            % Cast:
            functional_3_1_up_11 = cast(int64(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_16)), 'like', functional_3_1_up_16);
            functional_3_1_up_11NumDims = coder.const(functional_3_1_up_16NumDims);

            % Reshape:
            [shape1021, functional_3_1_up_10NumDims] = exudate_model.coder.ops.prepareReshapeArgs(functional_3_1_up_14, functional_3_1_up_11, coder.const(functional_3_1_up_14NumDims), 0);
            functional_3_1_up_10 = reshape(functional_3_1_up_14, shape1021{:});

            % Set graph output arguments
            functional_3_1_up_10NumDims1005 = coder.const(functional_3_1_up_10NumDims);

        end

    end

end