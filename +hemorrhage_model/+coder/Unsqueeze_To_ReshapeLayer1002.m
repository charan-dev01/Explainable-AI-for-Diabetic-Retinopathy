classdef Unsqueeze_To_ReshapeLayer1002 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1002(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = hemorrhage_model.Unsqueeze_To_ReshapeLayer1002(cgInstance.Name);
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
        function this = Unsqueeze_To_ReshapeLayer1002(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'Hemorrhage_UNet__178'};
            if isstruct(mlInstance.Vars)
                names = fieldnames(mlInstance.Vars);
                for i=1:numel(names)
                    fieldname = names{i};
                    this.Vars.(fieldname) = hemorrhage_model.coder.ops.extractIfDlarray(mlInstance.Vars.(fieldname));
                end
            else
                this.Vars = [];
            end

            this.NumDims = mlInstance.NumDims;
        end

        function [Hemorrhage_UNet__178] = predict(this, Hemorrhage_UNet_1_22__)
            if isdlarray(Hemorrhage_UNet_1_22__)
                Hemorrhage_UNet_1_22_ = stripdims(Hemorrhage_UNet_1_22__);
            else
                Hemorrhage_UNet_1_22_ = Hemorrhage_UNet_1_22__;
            end
            Hemorrhage_UNet_1_22NumDims = 4;
            Hemorrhage_UNet_1_22 = hemorrhage_model.coder.ops.permuteInputVar(Hemorrhage_UNet_1_22_, [4 3 1 2], 4);

            [Hemorrhage_UNet__178__, Hemorrhage_UNet__178NumDims__] = Unsqueeze_To_ReshapeGraph1006(this, Hemorrhage_UNet_1_22, Hemorrhage_UNet_1_22NumDims, false);
            Hemorrhage_UNet__178_ = hemorrhage_model.coder.ops.permuteOutputVar(Hemorrhage_UNet__178__, [2 3 4 1], 4);

            Hemorrhage_UNet__178 = dlarray(single(Hemorrhage_UNet__178_), 'SSCB');
        end

        function [Hemorrhage_UNet__178, Hemorrhage_UNet__178NumDims1008] = Unsqueeze_To_ReshapeGraph1006(this, Hemorrhage_UNet_1_22, Hemorrhage_UNet_1_22NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape1022, Hemorrhage_UNet__167NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_22, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet_1_22NumDims));
            Hemorrhage_UNet__167 = reshape(Hemorrhage_UNet_1_22, shape1022);

            % Tile:
            [sz1023, Hemorrhage_UNet__172NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__172 = repmat(Hemorrhage_UNet__167, sz1023);

            % Transpose:
            [perm1024, Transpose__228_0NumDims] = hemorrhage_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1007, coder.const(Hemorrhage_UNet__172NumDims));
            if isempty(perm1024)
                Transpose__228_0 = Hemorrhage_UNet__172;
            else
                Transpose__228_0 = permute(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__172), perm1024);
            end

            % Shape:
            [Shape__260_0, Shape__260_0NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet_1_22, coder.const(Hemorrhage_UNet_1_22NumDims), 0, coder.const(Hemorrhage_UNet_1_22NumDims)+1);

            % Gather:
            [Hemorrhage_UNet__170, Hemorrhage_UNet__170NumDims] = hemorrhage_model.coder.ops.onnxGather(Shape__260_0, this.Vars.Const__266, 0, coder.const(Shape__260_0NumDims), this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__171 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__170)), 'like', Hemorrhage_UNet__170);
            Hemorrhage_UNet__171NumDims = coder.const(Hemorrhage_UNet__170NumDims);

            % Slice:
            [indices1025, Hemorrhage_UNet__175NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__171, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__171NumDims));
            Hemorrhage_UNet__175 = Hemorrhage_UNet__171(indices1025{:});

            % Slice:
            [indices1026, Hemorrhage_UNet__176NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__171, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__171NumDims));
            Hemorrhage_UNet__176 = Hemorrhage_UNet__171(indices1026{:});

            % Concat:
            [Hemorrhage_UNet__174, Hemorrhage_UNet__174NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__175, this.Vars.Hemorrhage_UNet__173, Hemorrhage_UNet__176}, [coder.const(Hemorrhage_UNet__175NumDims), this.NumDims.Hemorrhage_UNet__173, coder.const(Hemorrhage_UNet__176NumDims)]);

            % Cast:
            Hemorrhage_UNet__169 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__174)), 'like', Hemorrhage_UNet__174);
            Hemorrhage_UNet__169NumDims = coder.const(Hemorrhage_UNet__174NumDims);

            % Reshape:
            [shape1027, Hemorrhage_UNet__168NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Transpose__228_0, Hemorrhage_UNet__169, coder.const(Transpose__228_0NumDims), 0);
            Hemorrhage_UNet__168 = reshape(Transpose__228_0, shape1027{:});

            % Unsqueeze:
            [shape1028, Hemorrhage_UNet__177NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__168, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet__168NumDims));
            Hemorrhage_UNet__177 = reshape(Hemorrhage_UNet__168, shape1028);

            % Tile:
            [sz1029, Hemorrhage_UNet__182NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__182 = repmat(Hemorrhage_UNet__177, sz1029);

            % Shape:
            [Hemorrhage_UNet__180, Hemorrhage_UNet__180NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet__168, coder.const(Hemorrhage_UNet__168NumDims), 0, coder.const(Hemorrhage_UNet__168NumDims)+1);

            % Cast:
            Hemorrhage_UNet__181 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__180)), 'like', Hemorrhage_UNet__180);
            Hemorrhage_UNet__181NumDims = coder.const(Hemorrhage_UNet__180NumDims);

            % Slice:
            [indices1030, Hemorrhage_UNet__184NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__181, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__181NumDims));
            Hemorrhage_UNet__184 = Hemorrhage_UNet__181(indices1030{:});

            % Slice:
            [indices1031, Hemorrhage_UNet__185NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__181, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__181NumDims));
            Hemorrhage_UNet__185 = Hemorrhage_UNet__181(indices1031{:});

            % Concat:
            [Hemorrhage_UNet__183, Hemorrhage_UNet__183NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__184, this.Vars.Hemorrhage_UNet__173, Hemorrhage_UNet__185}, [coder.const(Hemorrhage_UNet__184NumDims), this.NumDims.Hemorrhage_UNet__173, coder.const(Hemorrhage_UNet__185NumDims)]);

            % Cast:
            Hemorrhage_UNet__179 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__183)), 'like', Hemorrhage_UNet__183);
            Hemorrhage_UNet__179NumDims = coder.const(Hemorrhage_UNet__183NumDims);

            % Reshape:
            [shape1032, Hemorrhage_UNet__178NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Hemorrhage_UNet__182, Hemorrhage_UNet__179, coder.const(Hemorrhage_UNet__182NumDims), 0);
            Hemorrhage_UNet__178 = reshape(Hemorrhage_UNet__182, shape1032{:});

            % Set graph output arguments
            Hemorrhage_UNet__178NumDims1008 = coder.const(Hemorrhage_UNet__178NumDims);

        end

    end

end