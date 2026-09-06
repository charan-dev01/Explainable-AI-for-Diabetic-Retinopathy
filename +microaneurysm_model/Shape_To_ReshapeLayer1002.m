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
            name = 'microaneurysm_model.coder.Shape_To_ReshapeLayer1002';
        end
    end


    methods
        function this = Shape_To_ReshapeLayer1002(name)
            this.Name = name;
            this.OutputNames = {'functional_1_up_s_48'};
        end

        function [functional_1_up_s_48] = predict(this, functional_1_batch_6)
            if isdlarray(functional_1_batch_6)
                functional_1_batch_6 = stripdims(functional_1_batch_6);
            end
            functional_1_batch_6NumDims = 4;
            functional_1_batch_6 = microaneurysm_model.ops.permuteInputVar(functional_1_batch_6, [4 3 1 2], 4);

            [functional_1_up_s_48, functional_1_up_s_48NumDims] = Shape_To_ReshapeGraph1006(this, functional_1_batch_6, functional_1_batch_6NumDims, false);
            functional_1_up_s_48 = microaneurysm_model.ops.permuteOutputVar(functional_1_up_s_48, [2 3 4 1], 4);

            functional_1_up_s_48 = dlarray(single(functional_1_up_s_48), 'SSCB');
        end

        function [functional_1_up_s_48] = forward(this, functional_1_batch_6)
            if isdlarray(functional_1_batch_6)
                functional_1_batch_6 = stripdims(functional_1_batch_6);
            end
            functional_1_batch_6NumDims = 4;
            functional_1_batch_6 = microaneurysm_model.ops.permuteInputVar(functional_1_batch_6, [4 3 1 2], 4);

            [functional_1_up_s_48, functional_1_up_s_48NumDims] = Shape_To_ReshapeGraph1006(this, functional_1_batch_6, functional_1_batch_6NumDims, true);
            functional_1_up_s_48 = microaneurysm_model.ops.permuteOutputVar(functional_1_up_s_48, [2 3 4 1], 4);

            functional_1_up_s_48 = dlarray(single(functional_1_up_s_48), 'SSCB');
        end

        function [functional_1_up_s_48, functional_1_up_s_48NumDims1008] = Shape_To_ReshapeGraph1006(this, functional_1_batch_6, functional_1_batch_6NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__270_0, Shape__270_0NumDims] = microaneurysm_model.ops.onnxShape(functional_1_batch_6, functional_1_batch_6NumDims, 0, functional_1_batch_6NumDims+1);

            % Gather:
            [functional_1_up_s_41, functional_1_up_s_41NumDims] = microaneurysm_model.ops.onnxGather(Shape__270_0, this.Vars.Const__268, 0, Shape__270_0NumDims, this.NumDims.Const__268);

            % Cast:
            functional_1_up_s_42 = cast(int32(extractdata(functional_1_up_s_41)), 'like', functional_1_up_s_41);
            functional_1_up_s_42NumDims = functional_1_up_s_41NumDims;

            % Slice:
            [Indices, functional_1_up_s_45NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_42, this.Vars.const_axes__126, this.Vars.const_ends__61, this.Vars.const_axes__126, '', functional_1_up_s_42NumDims);
            functional_1_up_s_45 = functional_1_up_s_42(Indices{:});

            % Slice:
            [Indices, functional_1_up_s_46NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_42, this.Vars.const_starts__89, this.Vars.const_ends__134, this.Vars.const_axes__126, '', functional_1_up_s_42NumDims);
            functional_1_up_s_46 = functional_1_up_s_42(Indices{:});

            % Concat:
            [functional_1_up_s_44, functional_1_up_s_44NumDims] = microaneurysm_model.ops.onnxConcat(0, {functional_1_up_s_45, this.Vars.functional_1_up_s_53, functional_1_up_s_46}, [functional_1_up_s_45NumDims, this.NumDims.functional_1_up_s_53, functional_1_up_s_46NumDims]);

            % Cast:
            functional_1_up_s_40 = cast(int64(extractdata(functional_1_up_s_44)), 'like', functional_1_up_s_44);
            functional_1_up_s_40NumDims = functional_1_up_s_44NumDims;

            % Unsqueeze:
            [shape, functional_1_up_s_38NumDims] = microaneurysm_model.ops.prepareUnsqueezeArgs(functional_1_batch_6, this.Vars.const_starts__89__33, functional_1_batch_6NumDims);
            functional_1_up_s_38 = reshape(functional_1_batch_6, shape);

            % Tile:
            [sz, functional_1_up_s_43NumDims] = microaneurysm_model.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_43 = repmat(functional_1_up_s_38, sz);

            % Transpose:
            [perm, Transpose__234_0NumDims] = microaneurysm_model.ops.prepareTransposeArgs(this.Vars.TransposePerm1007, functional_1_up_s_43NumDims);
            if isempty(perm)
                Transpose__234_0 = functional_1_up_s_43;
            else
                Transpose__234_0 = permute(functional_1_up_s_43, perm);
            end

            % Reshape:
            [shape, functional_1_up_s_39NumDims] = microaneurysm_model.ops.prepareReshapeArgs(Transpose__234_0, functional_1_up_s_40, Transpose__234_0NumDims, 0);
            functional_1_up_s_39 = reshape(Transpose__234_0, shape{:});

            % Unsqueeze:
            [shape, functional_1_up_s_47NumDims] = microaneurysm_model.ops.prepareUnsqueezeArgs(functional_1_up_s_39, this.Vars.const_starts__89__33, functional_1_up_s_39NumDims);
            functional_1_up_s_47 = reshape(functional_1_up_s_39, shape);

            % Tile:
            [sz, functional_1_up_s_52NumDims] = microaneurysm_model.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_52 = repmat(functional_1_up_s_47, sz);

            % Shape:
            [functional_1_up_s_50, functional_1_up_s_50NumDims] = microaneurysm_model.ops.onnxShape(functional_1_up_s_39, functional_1_up_s_39NumDims, 0, functional_1_up_s_39NumDims+1);

            % Cast:
            functional_1_up_s_51 = cast(int32(extractdata(functional_1_up_s_50)), 'like', functional_1_up_s_50);
            functional_1_up_s_51NumDims = functional_1_up_s_50NumDims;

            % Slice:
            [Indices, functional_1_up_s_55NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_51, this.Vars.const_axes__126, this.Vars.const_starts__89, this.Vars.const_axes__126, '', functional_1_up_s_51NumDims);
            functional_1_up_s_55 = functional_1_up_s_51(Indices{:});

            % Slice:
            [Indices, functional_1_up_s_56NumDims] = microaneurysm_model.ops.prepareSliceArgs(functional_1_up_s_51, this.Vars.const_starts__89__33, this.Vars.const_ends__134, this.Vars.const_axes__126, '', functional_1_up_s_51NumDims);
            functional_1_up_s_56 = functional_1_up_s_51(Indices{:});

            % Concat:
            [functional_1_up_s_54, functional_1_up_s_54NumDims] = microaneurysm_model.ops.onnxConcat(0, {functional_1_up_s_55, this.Vars.functional_1_up_s_53, functional_1_up_s_56}, [functional_1_up_s_55NumDims, this.NumDims.functional_1_up_s_53, functional_1_up_s_56NumDims]);

            % Cast:
            functional_1_up_s_49 = cast(int64(extractdata(functional_1_up_s_54)), 'like', functional_1_up_s_54);
            functional_1_up_s_49NumDims = functional_1_up_s_54NumDims;

            % Reshape:
            [shape, functional_1_up_s_48NumDims] = microaneurysm_model.ops.prepareReshapeArgs(functional_1_up_s_52, functional_1_up_s_49, functional_1_up_s_52NumDims, 0);
            functional_1_up_s_48 = reshape(functional_1_up_s_52, shape{:});

            % Set graph output arguments
            functional_1_up_s_48NumDims1008 = functional_1_up_s_48NumDims;

        end

    end

end