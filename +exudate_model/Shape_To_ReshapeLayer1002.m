classdef Shape_To_ReshapeLayer1002 < nnet.layer.Layer & nnet.layer.Formattable
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
            name = 'exudate_model.coder.Shape_To_ReshapeLayer1002';
        end
    end


    methods
        function this = Shape_To_ReshapeLayer1002(name)
            this.Name = name;
            this.OutputNames = {'functional_3_1_up_30'};
        end

        function [functional_3_1_up_30] = predict(this, functional_3_1_ba_33)
            if isdlarray(functional_3_1_ba_33)
                functional_3_1_ba_33 = stripdims(functional_3_1_ba_33);
            end
            functional_3_1_ba_33NumDims = 4;
            functional_3_1_ba_33 = exudate_model.ops.permuteInputVar(functional_3_1_ba_33, [4 3 1 2], 4);

            [functional_3_1_up_30, functional_3_1_up_30NumDims] = Shape_To_ReshapeGraph1006(this, functional_3_1_ba_33, functional_3_1_ba_33NumDims, false);
            functional_3_1_up_30 = exudate_model.ops.permuteOutputVar(functional_3_1_up_30, [2 3 4 1], 4);

            functional_3_1_up_30 = dlarray(single(functional_3_1_up_30), 'SSCB');
        end

        function [functional_3_1_up_30] = forward(this, functional_3_1_ba_33)
            if isdlarray(functional_3_1_ba_33)
                functional_3_1_ba_33 = stripdims(functional_3_1_ba_33);
            end
            functional_3_1_ba_33NumDims = 4;
            functional_3_1_ba_33 = exudate_model.ops.permuteInputVar(functional_3_1_ba_33, [4 3 1 2], 4);

            [functional_3_1_up_30, functional_3_1_up_30NumDims] = Shape_To_ReshapeGraph1006(this, functional_3_1_ba_33, functional_3_1_ba_33NumDims, true);
            functional_3_1_up_30 = exudate_model.ops.permuteOutputVar(functional_3_1_up_30, [2 3 4 1], 4);

            functional_3_1_up_30 = dlarray(single(functional_3_1_up_30), 'SSCB');
        end

        function [functional_3_1_up_30, functional_3_1_up_30NumDims1008] = Shape_To_ReshapeGraph1006(this, functional_3_1_ba_33, functional_3_1_ba_33NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__946_0, Shape__946_0NumDims] = exudate_model.ops.onnxShape(functional_3_1_ba_33, functional_3_1_ba_33NumDims, 0, functional_3_1_ba_33NumDims+1);

            % Gather:
            [functional_3_1_up_22, functional_3_1_up_22NumDims] = exudate_model.ops.onnxGather(Shape__946_0, this.Vars.Const__940, 0, Shape__946_0NumDims, this.NumDims.Const__940);

            % Cast:
            functional_3_1_up_23 = cast(int32(extractdata(functional_3_1_up_22)), 'like', functional_3_1_up_22);
            functional_3_1_up_23NumDims = functional_3_1_up_22NumDims;

            % Slice:
            [Indices, functional_3_1_up_27NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_23, this.Vars.const_axes__811, this.Vars.const_ends__801, this.Vars.const_axes__811, '', functional_3_1_up_23NumDims);
            functional_3_1_up_27 = functional_3_1_up_23(Indices{:});

            % Slice:
            [Indices, functional_3_1_up_28NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_23, this.Vars.const_starts__765, this.Vars.const_ends__810, this.Vars.const_axes__811, '', functional_3_1_up_23NumDims);
            functional_3_1_up_28 = functional_3_1_up_23(Indices{:});

            % Concat:
            [functional_3_1_up_26, functional_3_1_up_26NumDims] = exudate_model.ops.onnxConcat(0, {functional_3_1_up_27, this.Vars.functional_3_1_up_25, functional_3_1_up_28}, [functional_3_1_up_27NumDims, this.NumDims.functional_3_1_up_25, functional_3_1_up_28NumDims]);

            % Cast:
            functional_3_1_up_21 = cast(int64(extractdata(functional_3_1_up_26)), 'like', functional_3_1_up_26);
            functional_3_1_up_21NumDims = functional_3_1_up_26NumDims;

            % Unsqueeze:
            [shape, functional_3_1_up_19NumDims] = exudate_model.ops.prepareUnsqueezeArgs(functional_3_1_ba_33, this.Vars.const_starts__809, functional_3_1_ba_33NumDims);
            functional_3_1_up_19 = reshape(functional_3_1_ba_33, shape);

            % Tile:
            [sz, functional_3_1_up_24NumDims] = exudate_model.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_24 = repmat(functional_3_1_up_19, sz);

            % Transpose:
            [perm, Transpose__910_0NumDims] = exudate_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1007, functional_3_1_up_24NumDims);
            if isempty(perm)
                Transpose__910_0 = functional_3_1_up_24;
            else
                Transpose__910_0 = permute(functional_3_1_up_24, perm);
            end

            % Reshape:
            [shape, functional_3_1_up_20NumDims] = exudate_model.ops.prepareReshapeArgs(Transpose__910_0, functional_3_1_up_21, Transpose__910_0NumDims, 0);
            functional_3_1_up_20 = reshape(Transpose__910_0, shape{:});

            % Unsqueeze:
            [shape, functional_3_1_up_29NumDims] = exudate_model.ops.prepareUnsqueezeArgs(functional_3_1_up_20, this.Vars.const_starts__809, functional_3_1_up_20NumDims);
            functional_3_1_up_29 = reshape(functional_3_1_up_20, shape);

            % Tile:
            [sz, functional_3_1_up_34NumDims] = exudate_model.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_34 = repmat(functional_3_1_up_29, sz);

            % Shape:
            [functional_3_1_up_32, functional_3_1_up_32NumDims] = exudate_model.ops.onnxShape(functional_3_1_up_20, functional_3_1_up_20NumDims, 0, functional_3_1_up_20NumDims+1);

            % Cast:
            functional_3_1_up_33 = cast(int32(extractdata(functional_3_1_up_32)), 'like', functional_3_1_up_32);
            functional_3_1_up_33NumDims = functional_3_1_up_32NumDims;

            % Slice:
            [Indices, functional_3_1_up_36NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_33, this.Vars.const_axes__811, this.Vars.const_starts__765, this.Vars.const_axes__811, '', functional_3_1_up_33NumDims);
            functional_3_1_up_36 = functional_3_1_up_33(Indices{:});

            % Slice:
            [Indices, functional_3_1_up_37NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_33, this.Vars.const_starts__809, this.Vars.const_ends__810, this.Vars.const_axes__811, '', functional_3_1_up_33NumDims);
            functional_3_1_up_37 = functional_3_1_up_33(Indices{:});

            % Concat:
            [functional_3_1_up_35, functional_3_1_up_35NumDims] = exudate_model.ops.onnxConcat(0, {functional_3_1_up_36, this.Vars.functional_3_1_up_25, functional_3_1_up_37}, [functional_3_1_up_36NumDims, this.NumDims.functional_3_1_up_25, functional_3_1_up_37NumDims]);

            % Cast:
            functional_3_1_up_31 = cast(int64(extractdata(functional_3_1_up_35)), 'like', functional_3_1_up_35);
            functional_3_1_up_31NumDims = functional_3_1_up_35NumDims;

            % Reshape:
            [shape, functional_3_1_up_30NumDims] = exudate_model.ops.prepareReshapeArgs(functional_3_1_up_34, functional_3_1_up_31, functional_3_1_up_34NumDims, 0);
            functional_3_1_up_30 = reshape(functional_3_1_up_34, shape{:});

            % Set graph output arguments
            functional_3_1_up_30NumDims1008 = functional_3_1_up_30NumDims;

        end

    end

end