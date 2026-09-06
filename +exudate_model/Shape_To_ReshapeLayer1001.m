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
            name = 'exudate_model.coder.Shape_To_ReshapeLayer1001';
        end
    end


    methods
        function this = Shape_To_ReshapeLayer1001(name)
            this.Name = name;
            this.OutputNames = {'functional_3_1_up_10'};
        end

        function [functional_3_1_up_10] = predict(this, functional_3_1_ba_27)
            if isdlarray(functional_3_1_ba_27)
                functional_3_1_ba_27 = stripdims(functional_3_1_ba_27);
            end
            functional_3_1_ba_27NumDims = 4;
            functional_3_1_ba_27 = exudate_model.ops.permuteInputVar(functional_3_1_ba_27, [4 3 1 2], 4);

            [functional_3_1_up_10, functional_3_1_up_10NumDims] = Shape_To_ReshapeGraph1003(this, functional_3_1_ba_27, functional_3_1_ba_27NumDims, false);
            functional_3_1_up_10 = exudate_model.ops.permuteOutputVar(functional_3_1_up_10, [2 3 4 1], 4);

            functional_3_1_up_10 = dlarray(single(functional_3_1_up_10), 'SSCB');
        end

        function [functional_3_1_up_10] = forward(this, functional_3_1_ba_27)
            if isdlarray(functional_3_1_ba_27)
                functional_3_1_ba_27 = stripdims(functional_3_1_ba_27);
            end
            functional_3_1_ba_27NumDims = 4;
            functional_3_1_ba_27 = exudate_model.ops.permuteInputVar(functional_3_1_ba_27, [4 3 1 2], 4);

            [functional_3_1_up_10, functional_3_1_up_10NumDims] = Shape_To_ReshapeGraph1003(this, functional_3_1_ba_27, functional_3_1_ba_27NumDims, true);
            functional_3_1_up_10 = exudate_model.ops.permuteOutputVar(functional_3_1_up_10, [2 3 4 1], 4);

            functional_3_1_up_10 = dlarray(single(functional_3_1_up_10), 'SSCB');
        end

        function [functional_3_1_up_10, functional_3_1_up_10NumDims1005] = Shape_To_ReshapeGraph1003(this, functional_3_1_ba_27, functional_3_1_ba_27NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__942_0, Shape__942_0NumDims] = exudate_model.ops.onnxShape(functional_3_1_ba_27, functional_3_1_ba_27NumDims, 0, functional_3_1_ba_27NumDims+1);

            % Gather:
            [functional_3_1_up__3, functional_3_1_up__3NumDims] = exudate_model.ops.onnxGather(Shape__942_0, this.Vars.Const__940, 0, Shape__942_0NumDims, this.NumDims.Const__940);

            % Cast:
            functional_3_1_up__4 = cast(int32(extractdata(functional_3_1_up__3)), 'like', functional_3_1_up__3);
            functional_3_1_up__4NumDims = functional_3_1_up__3NumDims;

            % Slice:
            [Indices, functional_3_1_up__7NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up__4, this.Vars.const_axes__811, this.Vars.const_ends__801, this.Vars.const_axes__811, '', functional_3_1_up__4NumDims);
            functional_3_1_up__7 = functional_3_1_up__4(Indices{:});

            % Slice:
            [Indices, functional_3_1_up__8NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up__4, this.Vars.const_starts__765, this.Vars.const_ends__810, this.Vars.const_axes__811, '', functional_3_1_up__4NumDims);
            functional_3_1_up__8 = functional_3_1_up__4(Indices{:});

            % Concat:
            [functional_3_1_up__6, functional_3_1_up__6NumDims] = exudate_model.ops.onnxConcat(0, {functional_3_1_up__7, this.Vars.functional_3_1_up_15, functional_3_1_up__8}, [functional_3_1_up__7NumDims, this.NumDims.functional_3_1_up_15, functional_3_1_up__8NumDims]);

            % Cast:
            functional_3_1_up__2 = cast(int64(extractdata(functional_3_1_up__6)), 'like', functional_3_1_up__6);
            functional_3_1_up__2NumDims = functional_3_1_up__6NumDims;

            % Unsqueeze:
            [shape, functional_3_1_up_saNumDims] = exudate_model.ops.prepareUnsqueezeArgs(functional_3_1_ba_27, this.Vars.const_starts__809, functional_3_1_ba_27NumDims);
            functional_3_1_up_sa = reshape(functional_3_1_ba_27, shape);

            % Tile:
            [sz, functional_3_1_up__5NumDims] = exudate_model.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up__5 = repmat(functional_3_1_up_sa, sz);

            % Transpose:
            [perm, Transpose__898_0NumDims] = exudate_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1004, functional_3_1_up__5NumDims);
            if isempty(perm)
                Transpose__898_0 = functional_3_1_up__5;
            else
                Transpose__898_0 = permute(functional_3_1_up__5, perm);
            end

            % Reshape:
            [shape, functional_3_1_up__1NumDims] = exudate_model.ops.prepareReshapeArgs(Transpose__898_0, functional_3_1_up__2, Transpose__898_0NumDims, 0);
            functional_3_1_up__1 = reshape(Transpose__898_0, shape{:});

            % Unsqueeze:
            [shape, functional_3_1_up__9NumDims] = exudate_model.ops.prepareUnsqueezeArgs(functional_3_1_up__1, this.Vars.const_starts__809, functional_3_1_up__1NumDims);
            functional_3_1_up__9 = reshape(functional_3_1_up__1, shape);

            % Tile:
            [sz, functional_3_1_up_14NumDims] = exudate_model.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_14 = repmat(functional_3_1_up__9, sz);

            % Shape:
            [functional_3_1_up_12, functional_3_1_up_12NumDims] = exudate_model.ops.onnxShape(functional_3_1_up__1, functional_3_1_up__1NumDims, 0, functional_3_1_up__1NumDims+1);

            % Cast:
            functional_3_1_up_13 = cast(int32(extractdata(functional_3_1_up_12)), 'like', functional_3_1_up_12);
            functional_3_1_up_13NumDims = functional_3_1_up_12NumDims;

            % Slice:
            [Indices, functional_3_1_up_17NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_13, this.Vars.const_axes__811, this.Vars.const_starts__765, this.Vars.const_axes__811, '', functional_3_1_up_13NumDims);
            functional_3_1_up_17 = functional_3_1_up_13(Indices{:});

            % Slice:
            [Indices, functional_3_1_up_18NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_13, this.Vars.const_starts__809, this.Vars.const_ends__810, this.Vars.const_axes__811, '', functional_3_1_up_13NumDims);
            functional_3_1_up_18 = functional_3_1_up_13(Indices{:});

            % Concat:
            [functional_3_1_up_16, functional_3_1_up_16NumDims] = exudate_model.ops.onnxConcat(0, {functional_3_1_up_17, this.Vars.functional_3_1_up_15, functional_3_1_up_18}, [functional_3_1_up_17NumDims, this.NumDims.functional_3_1_up_15, functional_3_1_up_18NumDims]);

            % Cast:
            functional_3_1_up_11 = cast(int64(extractdata(functional_3_1_up_16)), 'like', functional_3_1_up_16);
            functional_3_1_up_11NumDims = functional_3_1_up_16NumDims;

            % Reshape:
            [shape, functional_3_1_up_10NumDims] = exudate_model.ops.prepareReshapeArgs(functional_3_1_up_14, functional_3_1_up_11, functional_3_1_up_14NumDims, 0);
            functional_3_1_up_10 = reshape(functional_3_1_up_14, shape{:});

            % Set graph output arguments
            functional_3_1_up_10NumDims1005 = functional_3_1_up_10NumDims;

        end

    end

end