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
            this_cg = exudate_model.coder.Shape_To_ReshapeLayer1002(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = exudate_model.Shape_To_ReshapeLayer1002(cgInstance.Name);
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
            this.OutputNames = {'functional_3_1_up_30'};
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

        function [functional_3_1_up_30] = predict(this, functional_3_1_ba_33__)
            if isdlarray(functional_3_1_ba_33__)
                functional_3_1_ba_33_ = stripdims(functional_3_1_ba_33__);
            else
                functional_3_1_ba_33_ = functional_3_1_ba_33__;
            end
            functional_3_1_ba_33NumDims = 4;
            functional_3_1_ba_33 = exudate_model.coder.ops.permuteInputVar(functional_3_1_ba_33_, [4 3 1 2], 4);

            [functional_3_1_up_30__, functional_3_1_up_30NumDims__] = Shape_To_ReshapeGraph1006(this, functional_3_1_ba_33, functional_3_1_ba_33NumDims, false);
            functional_3_1_up_30_ = exudate_model.coder.ops.permuteOutputVar(functional_3_1_up_30__, [2 3 4 1], 4);

            functional_3_1_up_30 = dlarray(single(functional_3_1_up_30_), 'SSCB');
        end

        function [functional_3_1_up_30, functional_3_1_up_30NumDims1008] = Shape_To_ReshapeGraph1006(this, functional_3_1_ba_33, functional_3_1_ba_33NumDims, Training)

            % Execute the operators:
            % Shape:
            [Shape__946_0, Shape__946_0NumDims] = exudate_model.coder.ops.onnxShape(functional_3_1_ba_33, coder.const(functional_3_1_ba_33NumDims), 0, coder.const(functional_3_1_ba_33NumDims)+1);

            % Gather:
            [functional_3_1_up_22, functional_3_1_up_22NumDims] = exudate_model.coder.ops.onnxGather(Shape__946_0, this.Vars.Const__940, 0, coder.const(Shape__946_0NumDims), this.NumDims.Const__940);

            % Cast:
            functional_3_1_up_23 = cast(int32(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_22)), 'like', functional_3_1_up_22);
            functional_3_1_up_23NumDims = coder.const(functional_3_1_up_22NumDims);

            % Slice:
            [indices1022, functional_3_1_up_27NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_23, this.Vars.const_axes__811, this.Vars.const_ends__801, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_23NumDims));
            functional_3_1_up_27 = functional_3_1_up_23(indices1022{:});

            % Slice:
            [indices1023, functional_3_1_up_28NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_23, this.Vars.const_starts__765, this.Vars.const_ends__810, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_23NumDims));
            functional_3_1_up_28 = functional_3_1_up_23(indices1023{:});

            % Concat:
            [functional_3_1_up_26, functional_3_1_up_26NumDims] = exudate_model.coder.ops.onnxConcat(0, {functional_3_1_up_27, this.Vars.functional_3_1_up_25, functional_3_1_up_28}, [coder.const(functional_3_1_up_27NumDims), this.NumDims.functional_3_1_up_25, coder.const(functional_3_1_up_28NumDims)]);

            % Cast:
            functional_3_1_up_21 = cast(int64(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_26)), 'like', functional_3_1_up_26);
            functional_3_1_up_21NumDims = coder.const(functional_3_1_up_26NumDims);

            % Unsqueeze:
            [shape1024, functional_3_1_up_19NumDims] = exudate_model.coder.ops.prepareUnsqueezeArgs(functional_3_1_ba_33, this.Vars.const_starts__809, coder.const(functional_3_1_ba_33NumDims));
            functional_3_1_up_19 = reshape(functional_3_1_ba_33, shape1024);

            % Tile:
            [sz1025, functional_3_1_up_24NumDims] = exudate_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_24 = repmat(functional_3_1_up_19, sz1025);

            % Transpose:
            [perm1026, Transpose__910_0NumDims] = exudate_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1007, coder.const(functional_3_1_up_24NumDims));
            if isempty(perm1026)
                Transpose__910_0 = functional_3_1_up_24;
            else
                Transpose__910_0 = permute(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_24), perm1026);
            end

            % Reshape:
            [shape1027, functional_3_1_up_20NumDims] = exudate_model.coder.ops.prepareReshapeArgs(Transpose__910_0, functional_3_1_up_21, coder.const(Transpose__910_0NumDims), 0);
            functional_3_1_up_20 = reshape(Transpose__910_0, shape1027{:});

            % Unsqueeze:
            [shape1028, functional_3_1_up_29NumDims] = exudate_model.coder.ops.prepareUnsqueezeArgs(functional_3_1_up_20, this.Vars.const_starts__809, coder.const(functional_3_1_up_20NumDims));
            functional_3_1_up_29 = reshape(functional_3_1_up_20, shape1028);

            % Tile:
            [sz1029, functional_3_1_up_34NumDims] = exudate_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__980);
            functional_3_1_up_34 = repmat(functional_3_1_up_29, sz1029);

            % Shape:
            [functional_3_1_up_32, functional_3_1_up_32NumDims] = exudate_model.coder.ops.onnxShape(functional_3_1_up_20, coder.const(functional_3_1_up_20NumDims), 0, coder.const(functional_3_1_up_20NumDims)+1);

            % Cast:
            functional_3_1_up_33 = cast(int32(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_32)), 'like', functional_3_1_up_32);
            functional_3_1_up_33NumDims = coder.const(functional_3_1_up_32NumDims);

            % Slice:
            [indices1030, functional_3_1_up_36NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_33, this.Vars.const_axes__811, this.Vars.const_starts__765, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_33NumDims));
            functional_3_1_up_36 = functional_3_1_up_33(indices1030{:});

            % Slice:
            [indices1031, functional_3_1_up_37NumDims] = exudate_model.coder.ops.prepareSliceArgs(functional_3_1_up_33, this.Vars.const_starts__809, this.Vars.const_ends__810, this.Vars.const_axes__811, '', coder.const(functional_3_1_up_33NumDims));
            functional_3_1_up_37 = functional_3_1_up_33(indices1031{:});

            % Concat:
            [functional_3_1_up_35, functional_3_1_up_35NumDims] = exudate_model.coder.ops.onnxConcat(0, {functional_3_1_up_36, this.Vars.functional_3_1_up_25, functional_3_1_up_37}, [coder.const(functional_3_1_up_36NumDims), this.NumDims.functional_3_1_up_25, coder.const(functional_3_1_up_37NumDims)]);

            % Cast:
            functional_3_1_up_31 = cast(int64(exudate_model.coder.ops.extractIfDlarray(functional_3_1_up_35)), 'like', functional_3_1_up_35);
            functional_3_1_up_31NumDims = coder.const(functional_3_1_up_35NumDims);

            % Reshape:
            [shape1032, functional_3_1_up_30NumDims] = exudate_model.coder.ops.prepareReshapeArgs(functional_3_1_up_34, functional_3_1_up_31, coder.const(functional_3_1_up_34NumDims), 0);
            functional_3_1_up_30 = reshape(functional_3_1_up_34, shape1032{:});

            % Set graph output arguments
            functional_3_1_up_30NumDims1008 = coder.const(functional_3_1_up_30NumDims);

        end

    end

end