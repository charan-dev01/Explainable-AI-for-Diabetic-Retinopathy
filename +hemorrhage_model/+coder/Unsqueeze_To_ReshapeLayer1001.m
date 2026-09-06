classdef Unsqueeze_To_ReshapeLayer1001 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1001(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = hemorrhage_model.Unsqueeze_To_ReshapeLayer1001(cgInstance.Name);
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
        function this = Unsqueeze_To_ReshapeLayer1001(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'Hemorrhage_UNet__159'};
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

        function [Hemorrhage_UNet__159] = predict(this, Hemorrhage_UNet_1_14__)
            if isdlarray(Hemorrhage_UNet_1_14__)
                Hemorrhage_UNet_1_14_ = stripdims(Hemorrhage_UNet_1_14__);
            else
                Hemorrhage_UNet_1_14_ = Hemorrhage_UNet_1_14__;
            end
            Hemorrhage_UNet_1_14NumDims = 4;
            Hemorrhage_UNet_1_14 = hemorrhage_model.coder.ops.permuteInputVar(Hemorrhage_UNet_1_14_, [4 3 1 2], 4);

            [Hemorrhage_UNet__159__, Hemorrhage_UNet__159NumDims__] = Unsqueeze_To_ReshapeGraph1003(this, Hemorrhage_UNet_1_14, Hemorrhage_UNet_1_14NumDims, false);
            Hemorrhage_UNet__159_ = hemorrhage_model.coder.ops.permuteOutputVar(Hemorrhage_UNet__159__, [2 3 4 1], 4);

            Hemorrhage_UNet__159 = dlarray(single(Hemorrhage_UNet__159_), 'SSCB');
        end

        function [Hemorrhage_UNet__159, Hemorrhage_UNet__159NumDims1005] = Unsqueeze_To_ReshapeGraph1003(this, Hemorrhage_UNet_1_14, Hemorrhage_UNet_1_14NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape1011, Hemorrhage_UNet__148NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_14, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet_1_14NumDims));
            Hemorrhage_UNet__148 = reshape(Hemorrhage_UNet_1_14, shape1011);

            % Tile:
            [sz1012, Hemorrhage_UNet__153NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__153 = repmat(Hemorrhage_UNet__148, sz1012);

            % Transpose:
            [perm1013, Transpose__222_0NumDims] = hemorrhage_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1004, coder.const(Hemorrhage_UNet__153NumDims));
            if isempty(perm1013)
                Transpose__222_0 = Hemorrhage_UNet__153;
            else
                Transpose__222_0 = permute(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__153), perm1013);
            end

            % Shape:
            [Shape__256_0, Shape__256_0NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet_1_14, coder.const(Hemorrhage_UNet_1_14NumDims), 0, coder.const(Hemorrhage_UNet_1_14NumDims)+1);

            % Gather:
            [Hemorrhage_UNet__151, Hemorrhage_UNet__151NumDims] = hemorrhage_model.coder.ops.onnxGather(Shape__256_0, this.Vars.Const__266, 0, coder.const(Shape__256_0NumDims), this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__152 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__151)), 'like', Hemorrhage_UNet__151);
            Hemorrhage_UNet__152NumDims = coder.const(Hemorrhage_UNet__151NumDims);

            % Slice:
            [indices1014, Hemorrhage_UNet__156NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__152, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__152NumDims));
            Hemorrhage_UNet__156 = Hemorrhage_UNet__152(indices1014{:});

            % Slice:
            [indices1015, Hemorrhage_UNet__157NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__152, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__152NumDims));
            Hemorrhage_UNet__157 = Hemorrhage_UNet__152(indices1015{:});

            % Concat:
            [Hemorrhage_UNet__155, Hemorrhage_UNet__155NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__156, this.Vars.Hemorrhage_UNet__154, Hemorrhage_UNet__157}, [coder.const(Hemorrhage_UNet__156NumDims), this.NumDims.Hemorrhage_UNet__154, coder.const(Hemorrhage_UNet__157NumDims)]);

            % Cast:
            Hemorrhage_UNet__150 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__155)), 'like', Hemorrhage_UNet__155);
            Hemorrhage_UNet__150NumDims = coder.const(Hemorrhage_UNet__155NumDims);

            % Reshape:
            [shape1016, Hemorrhage_UNet__149NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Transpose__222_0, Hemorrhage_UNet__150, coder.const(Transpose__222_0NumDims), 0);
            Hemorrhage_UNet__149 = reshape(Transpose__222_0, shape1016{:});

            % Unsqueeze:
            [shape1017, Hemorrhage_UNet__158NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__149, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet__149NumDims));
            Hemorrhage_UNet__158 = reshape(Hemorrhage_UNet__149, shape1017);

            % Tile:
            [sz1018, Hemorrhage_UNet__163NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__163 = repmat(Hemorrhage_UNet__158, sz1018);

            % Shape:
            [Hemorrhage_UNet__161, Hemorrhage_UNet__161NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet__149, coder.const(Hemorrhage_UNet__149NumDims), 0, coder.const(Hemorrhage_UNet__149NumDims)+1);

            % Cast:
            Hemorrhage_UNet__162 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__161)), 'like', Hemorrhage_UNet__161);
            Hemorrhage_UNet__162NumDims = coder.const(Hemorrhage_UNet__161NumDims);

            % Slice:
            [indices1019, Hemorrhage_UNet__165NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__162, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__162NumDims));
            Hemorrhage_UNet__165 = Hemorrhage_UNet__162(indices1019{:});

            % Slice:
            [indices1020, Hemorrhage_UNet__166NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__162, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__162NumDims));
            Hemorrhage_UNet__166 = Hemorrhage_UNet__162(indices1020{:});

            % Concat:
            [Hemorrhage_UNet__164, Hemorrhage_UNet__164NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__165, this.Vars.Hemorrhage_UNet__154, Hemorrhage_UNet__166}, [coder.const(Hemorrhage_UNet__165NumDims), this.NumDims.Hemorrhage_UNet__154, coder.const(Hemorrhage_UNet__166NumDims)]);

            % Cast:
            Hemorrhage_UNet__160 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__164)), 'like', Hemorrhage_UNet__164);
            Hemorrhage_UNet__160NumDims = coder.const(Hemorrhage_UNet__164NumDims);

            % Reshape:
            [shape1021, Hemorrhage_UNet__159NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Hemorrhage_UNet__163, Hemorrhage_UNet__160, coder.const(Hemorrhage_UNet__163NumDims), 0);
            Hemorrhage_UNet__159 = reshape(Hemorrhage_UNet__163, shape1021{:});

            % Set graph output arguments
            Hemorrhage_UNet__159NumDims1005 = coder.const(Hemorrhage_UNet__159NumDims);

        end

    end

end