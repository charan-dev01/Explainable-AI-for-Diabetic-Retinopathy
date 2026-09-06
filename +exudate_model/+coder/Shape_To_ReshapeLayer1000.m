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
            this_cg = exudate_model.coder.Shape_To_ReshapeLayer1000(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = exudate_model.Shape_To_ReshapeLayer1000(cgInstance.Name);
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
            this.OutputNames = {'functional_3_1_up_49'};
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

        function [functional_3_1_up_49] = predict(this, functional_3_1_ba_21__)
            if isdlarray(functional_3_1_ba_21__)
                functional_3_1_ba_21_ = stripdims(functional_3_1_ba_21__);
            else
                functional_3_1_ba_21_ = functional_3_1_ba_21__;
            end
            functional_3_1_ba_21NumDims = 4;
            functional_3_1_ba_21 = exudate_model.coder.ops.permuteInputVar(functional_3_1_ba_21_, [4 3 1 2], 4);

            [functional_3_1_up_49__, functional_3_1_up_49NumDims__] = Shape_To_ReshapeGraph1000(this, functional_3_1_ba_21, functional_3_1_ba_21NumDims, false);
            functional_3_1_up_49_ = exudate_model.coder.ops.permuteOutputVar(functional_3_1_up_49__, [2 3 4 1], 4);

            functional_3_1_up_49 = dlarray(single(functional_3_1_up_49_), 'SSCB');
        end

        function [functional_3_1_up_49, functional_3_1_up_49NumDims1002] = Shape_To_ReshapeGraph1000(this, functional_3_1_ba_21, functional_3_1_ba_21NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__938_0, Shape__938_0NumDims] = exudate_model.coder.ops.onnxShape(functional_3_1_ba_21, coder.const(functional_3_1_ba_21NumDims), 0, coder.const(functional_3_1_ba_21NumDims)+1);

            % Gather:
            [functional_3_1_up_41, functional_3_1_up_41NumDims] = exudate_model.coder.ops.onnxGather(Shape__938_0, this.Vars.Const__940, 0, coder.const(Shape__938_0NumDims), this.NumDims.Const__940);

            % Cast:
            functional_3_1_up_42 = cast(int32(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_41)), 'like', functional_3_1_up_41);
            functional_3_1_up_42NumDims = coder.const(functional_3_1_up_41NumDims);

            % Slice:
            [indices1000, functional_3_1_up_46NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_42, this.Vars.const_axes__811, this.Vars.const_ends__801, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_42NumDims));
            functional_3_1_up_46 = functional_3_1_up_42(indices1000{:});

            % Slice:
            [indices1001, functional_3_1_up_47NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_42, this.Vars.const_starts__765, this.Vars.const_ends__810, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_42NumDims));
            functional_3_1_up_47 = functional_3_1_up_42(indices1001{:});

            % Concat:
            [functional_3_1_up_45, functional_3_1_up_45NumDims] = exudate_model.coder.ops.onnxConcat(0, {functional_3_1_up_46, this.Vars.functional_3_1_up_44, functional_3_1_up_47}, [coder.const(functional_3_1_up_46NumDims), this.NumDims.functional_3_1_up_44, coder.const(functional_3_1_up_47NumDims)]);

            % Cast:
            functional_3_1_up_40 = cast(int64(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_45)), 'like', functional_3_1_up_45);
            functional_3_1_up_40NumDims = coder.const(functional_3_1_up_45NumDims);

            % Unsqueeze:
            [shape1002, functional_3_1_up_38NumDims] = exudate_model.coder.ops.prepareUnsqueezeArgs(functional_3_1_ba_21, this.Vars.const_starts__809, coder.const(functional_3_1_ba_21NumDims));
            functional_3_1_up_38 = reshape(functional_3_1_ba_21, shape1002);

            % Tile:
            [sz1003, functional_3_1_up_43NumDims] = exudate_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_43 = repmat(functional_3_1_up_38, sz1003);

            % Transpose:
            [perm1004, Transpose__878_0NumDims] = exudate_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1001, coder.const(functional_3_1_up_43NumDims));
            if isempty(perm1004)
                Transpose__878_0 = functional_3_1_up_43;
            else
                Transpose__878_0 = permute(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_43), perm1004);
            end

            % Reshape:
            [shape1005, functional_3_1_up_39NumDims] = exudate_model.coder.ops.prepareReshapeArgs(Transpose__878_0, functional_3_1_up_40, coder.const(Transpose__878_0NumDims), 0);
            functional_3_1_up_39 = reshape(Transpose__878_0, shape1005{:});

            % Unsqueeze:
            [shape1006, functional_3_1_up_48NumDims] = exudate_model.coder.ops.prepareUnsqueezeArgs(functional_3_1_up_39, this.Vars.const_starts__809, coder.const(functional_3_1_up_39NumDims));
            functional_3_1_up_48 = reshape(functional_3_1_up_39, shape1006);

            % Tile:
            [sz1007, functional_3_1_up_53NumDims] = exudate_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_53 = repmat(functional_3_1_up_48, sz1007);

            % Shape:
            [functional_3_1_up_51, functional_3_1_up_51NumDims] = exudate_model.coder.ops.onnxShape(functional_3_1_up_39, coder.const(functional_3_1_up_39NumDims), 0, coder.const(functional_3_1_up_39NumDims)+1);

            % Cast:
            functional_3_1_up_52 = cast(int32(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_51)), 'like', functional_3_1_up_51);
            functional_3_1_up_52NumDims = coder.const(functional_3_1_up_51NumDims);

            % Slice:
            [indices1008, functional_3_1_up_55NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_52, this.Vars.const_axes__811, this.Vars.const_starts__765, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_52NumDims));
            functional_3_1_up_55 = functional_3_1_up_52(indices1008{:});

            % Slice:
            [indices1009, functional_3_1_up_56NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_52, this.Vars.const_starts__809, this.Vars.const_ends__810, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_52NumDims));
            functional_3_1_up_56 = functional_3_1_up_52(indices1009{:});

            % Concat:
            [functional_3_1_up_54, functional_3_1_up_54NumDims] = exudate_model.coder.ops.onnxConcat(0, {functional_3_1_up_55, this.Vars.functional_3_1_up_44, functional_3_1_up_56}, [coder.const(functional_3_1_up_55NumDims), this.NumDims.functional_3_1_up_44, coder.const(functional_3_1_up_56NumDims)]);

            % Cast:
            functional_3_1_up_50 = cast(int64(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_54)), 'like', functional_3_1_up_54);
            functional_3_1_up_50NumDims = coder.const(functional_3_1_up_54NumDims);

            % Reshape:
            [shape1010, functional_3_1_up_49NumDims] = exudate_model.coder.ops.prepareReshapeArgs(functional_3_1_up_53, functional_3_1_up_50, coder.const(functional_3_1_up_53NumDims), 0);
            functional_3_1_up_49 = reshape(functional_3_1_up_53, shape1010{:});

            % Set graph output arguments
            functional_3_1_up_49NumDims1002 = coder.const(functional_3_1_up_49NumDims);

        end

    end

end