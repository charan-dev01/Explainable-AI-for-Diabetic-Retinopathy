classdef Shape_To_ReshapeLayer1002 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = microaneurysm_model.coder.Shape_To_ReshapeLayer1002(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = microaneurysm_model.Shape_To_ReshapeLayer1002(cgInstance.Name);
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
        function this = Shape_To_ReshapeLayer1002(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'functional_1_up_s_48'};
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

        function [functional_1_up_s_48] = predict(this, functional_1_batch_6__)
            if isdlarray(functional_1_batch_6__)
                functional_1_batch_6_ = stripdims(functional_1_batch_6__);
            else
                functional_1_batch_6_ = functional_1_batch_6__;
            end
            functional_1_batch_6NumDims = 4;
            functional_1_batch_6 = microaneurysm_model.coder.ops.permuteInputVar(functional_1_batch_6_, [4 3 1 2], 4);

            [functional_1_up_s_48__, functional_1_up_s_48NumDims__] = Shape_To_ReshapeGraph1006(this, functional_1_batch_6, functional_1_batch_6NumDims, false);
            functional_1_up_s_48_ = microaneurysm_model.coder.ops.permuteOutputVar(functional_1_up_s_48__, [2 3 4 1], 4);

            functional_1_up_s_48 = dlarray(single(functional_1_up_s_48_), 'SSCB');
        end

        function [functional_1_up_s_48, functional_1_up_s_48NumDims1008] = Shape_To_ReshapeGraph1006(this, functional_1_batch_6, functional_1_batch_6NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__270_0, Shape__270_0NumDims] = microaneurysm_model.coder.ops.onnxShape(functional_1_batch_6, coder.const(functional_1_batch_6NumDims), 0, coder.const(functional_1_batch_6NumDims)+1);

            % Gather:
            [functional_1_up_s_41, functional_1_up_s_41NumDims] = microaneurysm_model.coder.ops.onnxGather(Shape__270_0, this.Vars.Const__268, 0, coder.const(Shape__270_0NumDims), this.NumDims.Const__268);

            % Cast:
            functional_1_up_s_42 = cast(int32(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_41)), 'like', functional_1_up_s_41);
            functional_1_up_s_42NumDims = coder.const(functional_1_up_s_41NumDims);

            % Slice:
            [indices1022, functional_1_up_s_45NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_42, this.Vars.const_axes__126, this.Vars.const_ends__61, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_42NumDims));
            functional_1_up_s_45 = functional_1_up_s_42(indices1022{:});

            % Slice:
            [indices1023, functional_1_up_s_46NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_42, this.Vars.const_starts__89, this.Vars.const_ends__134, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_42NumDims));
            functional_1_up_s_46 = functional_1_up_s_42(indices1023{:});

            % Concat:
            [functional_1_up_s_44, functional_1_up_s_44NumDims] = microaneurysm_model.coder.ops.onnxConcat(0, {functional_1_up_s_45, this.Vars.functional_1_up_s_53, functional_1_up_s_46}, [coder.const(functional_1_up_s_45NumDims), this.NumDims.functional_1_up_s_53, coder.const(functional_1_up_s_46NumDims)]);

            % Cast:
            functional_1_up_s_40 = cast(int64(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_44)), 'like', functional_1_up_s_44);
            functional_1_up_s_40NumDims = coder.const(functional_1_up_s_44NumDims);

            % Unsqueeze:
            [shape1024, functional_1_up_s_38NumDims] = microaneurysm_model.coder.ops.prepareUnsqueezeArgs(functional_1_batch_6, this.Vars.const_starts__89__33, coder.const(functional_1_batch_6NumDims));
            functional_1_up_s_38 = reshape(functional_1_batch_6, shape1024);

            % Tile:
            [sz1025, functional_1_up_s_43NumDims] = microaneurysm_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_43 = repmat(functional_1_up_s_38, sz1025);

            % Transpose:
            [perm1026, Transpose__234_0NumDims] = microaneurysm_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1007, coder.const(functional_1_up_s_43NumDims));
            if isempty(perm1026)
                Transpose__234_0 = functional_1_up_s_43;
            else
                Transpose__234_0 = permute(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_43), perm1026);
            end

            % Reshape:
            [shape1027, functional_1_up_s_39NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(Transpose__234_0, functional_1_up_s_40, coder.const(Transpose__234_0NumDims), 0);
            functional_1_up_s_39 = reshape(Transpose__234_0, shape1027{:});

            % Unsqueeze:
            [shape1028, functional_1_up_s_47NumDims] = microaneurysm_model.coder.ops.prepareUnsqueezeArgs(functional_1_up_s_39, this.Vars.const_starts__89__33, coder.const(functional_1_up_s_39NumDims));
            functional_1_up_s_47 = reshape(functional_1_up_s_39, shape1028);

            % Tile:
            [sz1029, functional_1_up_s_52NumDims] = microaneurysm_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__304_);
            functional_1_up_s_52 = repmat(functional_1_up_s_47, sz1029);

            % Shape:
            [functional_1_up_s_50, functional_1_up_s_50NumDims] = microaneurysm_model.coder.ops.onnxShape(functional_1_up_s_39, coder.const(functional_1_up_s_39NumDims), 0, coder.const(functional_1_up_s_39NumDims)+1);

            % Cast:
            functional_1_up_s_51 = cast(int32(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_50)), 'like', functional_1_up_s_50);
            functional_1_up_s_51NumDims = coder.const(functional_1_up_s_50NumDims);

            % Slice:
            [indices1030, functional_1_up_s_55NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_51, this.Vars.const_axes__126, this.Vars.const_starts__89, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_51NumDims));
            functional_1_up_s_55 = functional_1_up_s_51(indices1030{:});

            % Slice:
            [indices1031, functional_1_up_s_56NumDims] = microaneurysm_model.coder.ops.prepareSliceArgs(functional_1_up_s_51, this.Vars.const_starts__89__33, this.Vars.const_ends__134, this.Vars.const_axes__126, '', coder.const(functional_1_up_s_51NumDims));
            functional_1_up_s_56 = functional_1_up_s_51(indices1031{:});

            % Concat:
            [functional_1_up_s_54, functional_1_up_s_54NumDims] = microaneurysm_model.coder.ops.onnxConcat(0, {functional_1_up_s_55, this.Vars.functional_1_up_s_53, functional_1_up_s_56}, [coder.const(functional_1_up_s_55NumDims), this.NumDims.functional_1_up_s_53, coder.const(functional_1_up_s_56NumDims)]);

            % Cast:
            functional_1_up_s_49 = cast(int64(microaneurysm_model.coder.ops.extractIfDlarray(functional_1_up_s_54)), 'like', functional_1_up_s_54);
            functional_1_up_s_49NumDims = coder.const(functional_1_up_s_54NumDims);

            % Reshape:
            [shape1032, functional_1_up_s_48NumDims] = microaneurysm_model.coder.ops.prepareReshapeArgs(functional_1_up_s_52, functional_1_up_s_49, coder.const(functional_1_up_s_52NumDims), 0);
            functional_1_up_s_48 = reshape(functional_1_up_s_52, shape1032{:});

            % Set graph output arguments
            functional_1_up_s_48NumDims1008 = coder.const(functional_1_up_s_48NumDims);

        end

    end

end