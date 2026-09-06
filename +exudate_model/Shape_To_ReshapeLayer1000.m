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
            name = 'exudate_model.coder.Shape_To_ReshapeLayer1000';
        end
    end


    methods
        function this = Shape_To_ReshapeLayer1000(name)
            this.Name = name;
            this.OutputNames = {'functional_3_1_up_49'};
        end

        function [functional_3_1_up_49] = predict(this, functional_3_1_ba_21)
            if isdlarray(functional_3_1_ba_21)
                functional_3_1_ba_21 = stripdims(functional_3_1_ba_21);
            end
            functional_3_1_ba_21NumDims = 4;
            functional_3_1_ba_21 = exudate_model.ops.permuteInputVar(functional_3_1_ba_21, [4 3 1 2], 4);

            [functional_3_1_up_49, functional_3_1_up_49NumDims] = Shape_To_ReshapeGraph1000(this, functional_3_1_ba_21, functional_3_1_ba_21NumDims, false);
            functional_3_1_up_49 = exudate_model.ops.permuteOutputVar(functional_3_1_up_49, [2 3 4 1], 4);

            functional_3_1_up_49 = dlarray(single(functional_3_1_up_49), 'SSCB');
        end

        function [functional_3_1_up_49] = forward(this, functional_3_1_ba_21)
            if isdlarray(functional_3_1_ba_21)
                functional_3_1_ba_21 = stripdims(functional_3_1_ba_21);
            end
            functional_3_1_ba_21NumDims = 4;
            functional_3_1_ba_21 = exudate_model.ops.permuteInputVar(functional_3_1_ba_21, [4 3 1 2], 4);

            [functional_3_1_up_49, functional_3_1_up_49NumDims] = Shape_To_ReshapeGraph1000(this, functional_3_1_ba_21, functional_3_1_ba_21NumDims, true);
            functional_3_1_up_49 = exudate_model.ops.permuteOutputVar(functional_3_1_up_49, [2 3 4 1], 4);

            functional_3_1_up_49 = dlarray(single(functional_3_1_up_49), 'SSCB');
        end

        function [functional_3_1_up_49, functional_3_1_up_49NumDims1002] = Shape_To_ReshapeGraph1000(this, functional_3_1_ba_21, functional_3_1_ba_21NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__938_0, Shape__938_0NumDims] = exudate_model.ops.onnxShape(functional_3_1_ba_21, functional_3_1_ba_21NumDims, 0, functional_3_1_ba_21NumDims+1);

            % Gather:
            [functional_3_1_up_41, functional_3_1_up_41NumDims] = exudate_model.ops.onnxGather(Shape__938_0, this.Vars.Const__940, 0, Shape__938_0NumDims, this.NumDims.Const__940);

            % Cast:
            functional_3_1_up_42 = cast(int32(extractdata(functional_3_1_up_41)), 'like', functional_3_1_up_41);
            functional_3_1_up_42NumDims = functional_3_1_up_41NumDims;

            % Slice:
            [Indices, functional_3_1_up_46NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_42, this.Vars.const_axes__811, this.Vars.const_ends__801, this.Vars.const_axes__811, '', functional_3_1_up_42NumDims);
            functional_3_1_up_46 = functional_3_1_up_42(Indices{:});

            % Slice:
            [Indices, functional_3_1_up_47NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_42, this.Vars.const_starts__765, this.Vars.const_ends__810, this.Vars.const_axes__811, '', functional_3_1_up_42NumDims);
            functional_3_1_up_47 = functional_3_1_up_42(Indices{:});

            % Concat:
            [functional_3_1_up_45, functional_3_1_up_45NumDims] = exudate_model.ops.onnxConcat(0, {functional_3_1_up_46, this.Vars.functional_3_1_up_44, functional_3_1_up_47}, [functional_3_1_up_46NumDims, this.NumDims.functional_3_1_up_44, functional_3_1_up_47NumDims]);

            % Cast:
            functional_3_1_up_40 = cast(int64(extractdata(functional_3_1_up_45)), 'like', functional_3_1_up_45);
            functional_3_1_up_40NumDims = functional_3_1_up_45NumDims;

            % Unsqueeze:
            [shape, functional_3_1_up_38NumDims] = exudate_model.ops.prepareUnsqueezeArgs(functional_3_1_ba_21, this.Vars.const_starts__809, functional_3_1_ba_21NumDims);
            functional_3_1_up_38 = reshape(functional_3_1_ba_21, shape);

            % Tile:
            [sz, functional_3_1_up_43NumDims] = exudate_model.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_43 = repmat(functional_3_1_up_38, sz);

            % Transpose:
            [perm, Transpose__878_0NumDims] = exudate_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1001, functional_3_1_up_43NumDims);
            if isempty(perm)
                Transpose__878_0 = functional_3_1_up_43;
            else
                Transpose__878_0 = permute(functional_3_1_up_43, perm);
            end

            % Reshape:
            [shape, functional_3_1_up_39NumDims] = exudate_model.ops.prepareReshapeArgs(Transpose__878_0, functional_3_1_up_40, Transpose__878_0NumDims, 0);
            functional_3_1_up_39 = reshape(Transpose__878_0, shape{:});

            % Unsqueeze:
            [shape, functional_3_1_up_48NumDims] = exudate_model.ops.prepareUnsqueezeArgs(functional_3_1_up_39, this.Vars.const_starts__809, functional_3_1_up_39NumDims);
            functional_3_1_up_48 = reshape(functional_3_1_up_39, shape);

            % Tile:
            [sz, functional_3_1_up_53NumDims] = exudate_model.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_53 = repmat(functional_3_1_up_48, sz);

            % Shape:
            [functional_3_1_up_51, functional_3_1_up_51NumDims] = exudate_model.ops.onnxShape(functional_3_1_up_39, functional_3_1_up_39NumDims, 0, functional_3_1_up_39NumDims+1);

            % Cast:
            functional_3_1_up_52 = cast(int32(extractdata(functional_3_1_up_51)), 'like', functional_3_1_up_51);
            functional_3_1_up_52NumDims = functional_3_1_up_51NumDims;

            % Slice:
            [Indices, functional_3_1_up_55NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_52, this.Vars.const_axes__811, this.Vars.const_starts__765, this.Vars.const_axes__811, '', functional_3_1_up_52NumDims);
            functional_3_1_up_55 = functional_3_1_up_52(Indices{:});

            % Slice:
            [Indices, functional_3_1_up_56NumDims] = exudate_model.ops.prepareSliceArgs(functional_3_1_up_52, this.Vars.const_starts__809, this.Vars.const_ends__810, this.Vars.const_axes__811, '', functional_3_1_up_52NumDims);
            functional_3_1_up_56 = functional_3_1_up_52(Indices{:});

            % Concat:
            [functional_3_1_up_54, functional_3_1_up_54NumDims] = exudate_model.ops.onnxConcat(0, {functional_3_1_up_55, this.Vars.functional_3_1_up_44, functional_3_1_up_56}, [functional_3_1_up_55NumDims, this.NumDims.functional_3_1_up_44, functional_3_1_up_56NumDims]);

            % Cast:
            functional_3_1_up_50 = cast(int64(extractdata(functional_3_1_up_54)), 'like', functional_3_1_up_54);
            functional_3_1_up_50NumDims = functional_3_1_up_54NumDims;

            % Reshape:
            [shape, functional_3_1_up_49NumDims] = exudate_model.ops.prepareReshapeArgs(functional_3_1_up_53, functional_3_1_up_50, functional_3_1_up_53NumDims, 0);
            functional_3_1_up_49 = reshape(functional_3_1_up_53, shape{:});

            % Set graph output arguments
            functional_3_1_up_49NumDims1002 = functional_3_1_up_49NumDims;

        end

    end

end