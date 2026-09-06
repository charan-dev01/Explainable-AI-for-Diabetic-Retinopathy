classdef Unsqueeze_To_ReshapeLayer1000 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1000(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = hemorrhage_model.Unsqueeze_To_ReshapeLayer1000(cgInstance.Name);
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
        function this = Unsqueeze_To_ReshapeLayer1000(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'Hemorrhage_UNet__139'};
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

        function [Hemorrhage_UNet__139] = predict(this, Hemorrhage_UNet_1_77__)
            if isdlarray(Hemorrhage_UNet_1_77__)
                Hemorrhage_UNet_1_77_ = stripdims(Hemorrhage_UNet_1_77__);
            else
                Hemorrhage_UNet_1_77_ = Hemorrhage_UNet_1_77__;
            end
            Hemorrhage_UNet_1_77NumDims = 4;
            Hemorrhage_UNet_1_77 = hemorrhage_model.coder.ops.permuteInputVar(Hemorrhage_UNet_1_77_, [4 3 1 2], 4);

            [Hemorrhage_UNet__139__, Hemorrhage_UNet__139NumDims__] = Unsqueeze_To_ReshapeGraph1000(this, Hemorrhage_UNet_1_77, Hemorrhage_UNet_1_77NumDims, false);
            Hemorrhage_UNet__139_ = hemorrhage_model.coder.ops.permuteOutputVar(Hemorrhage_UNet__139__, [2 3 4 1], 4);

            Hemorrhage_UNet__139 = dlarray(single(Hemorrhage_UNet__139_), 'SSCB');
        end

        function [Hemorrhage_UNet__139, Hemorrhage_UNet__139NumDims1002] = Unsqueeze_To_ReshapeGraph1000(this, Hemorrhage_UNet_1_77, Hemorrhage_UNet_1_77NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape1000, Hemorrhage_UNet_1_upNumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_77, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet_1_77NumDims));
            Hemorrhage_UNet_1_up = reshape(Hemorrhage_UNet_1_77, shape1000);

            % Tile:
            [sz1001, Hemorrhage_UNet__134NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__134 = repmat(Hemorrhage_UNet_1_up, sz1001);

            % Transpose:
            [perm1002, Transpose__218_0NumDims] = hemorrhage_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1001, coder.const(Hemorrhage_UNet__134NumDims));
            if isempty(perm1002)
                Transpose__218_0 = Hemorrhage_UNet__134;
            else
                Transpose__218_0 = permute(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__134), perm1002);
            end

            % Shape:
            [Shape__252_0, Shape__252_0NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet_1_77, coder.const(Hemorrhage_UNet_1_77NumDims), 0, coder.const(Hemorrhage_UNet_1_77NumDims)+1);

            % Gather:
            [Hemorrhage_UNet__132, Hemorrhage_UNet__132NumDims] = hemorrhage_model.coder.ops.onnxGather(Shape__252_0, this.Vars.Const__266, 0, coder.const(Shape__252_0NumDims), this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__133 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__132)), 'like', Hemorrhage_UNet__132);
            Hemorrhage_UNet__133NumDims = coder.const(Hemorrhage_UNet__132NumDims);

            % Slice:
            [indices1003, Hemorrhage_UNet__136NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__133, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__133NumDims));
            Hemorrhage_UNet__136 = Hemorrhage_UNet__133(indices1003{:});

            % Slice:
            [indices1004, Hemorrhage_UNet__137NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__133, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__133NumDims));
            Hemorrhage_UNet__137 = Hemorrhage_UNet__133(indices1004{:});

            % Concat:
            [Hemorrhage_UNet__135, Hemorrhage_UNet__135NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__136, this.Vars.Hemorrhage_UNet__144, Hemorrhage_UNet__137}, [coder.const(Hemorrhage_UNet__136NumDims), this.NumDims.Hemorrhage_UNet__144, coder.const(Hemorrhage_UNet__137NumDims)]);

            % Cast:
            Hemorrhage_UNet__131 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__135)), 'like', Hemorrhage_UNet__135);
            Hemorrhage_UNet__131NumDims = coder.const(Hemorrhage_UNet__135NumDims);

            % Reshape:
            [shape1005, Hemorrhage_UNet__130NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Transpose__218_0, Hemorrhage_UNet__131, coder.const(Transpose__218_0NumDims), 0);
            Hemorrhage_UNet__130 = reshape(Transpose__218_0, shape1005{:});

            % Unsqueeze:
            [shape1006, Hemorrhage_UNet__138NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__130, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet__130NumDims));
            Hemorrhage_UNet__138 = reshape(Hemorrhage_UNet__130, shape1006);

            % Tile:
            [sz1007, Hemorrhage_UNet__143NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__143 = repmat(Hemorrhage_UNet__138, sz1007);

            % Shape:
            [Hemorrhage_UNet__141, Hemorrhage_UNet__141NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet__130, coder.const(Hemorrhage_UNet__130NumDims), 0, coder.const(Hemorrhage_UNet__130NumDims)+1);

            % Cast:
            Hemorrhage_UNet__142 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__141)), 'like', Hemorrhage_UNet__141);
            Hemorrhage_UNet__142NumDims = coder.const(Hemorrhage_UNet__141NumDims);

            % Slice:
            [indices1008, Hemorrhage_UNet__146NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__142, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__142NumDims));
            Hemorrhage_UNet__146 = Hemorrhage_UNet__142(indices1008{:});

            % Slice:
            [indices1009, Hemorrhage_UNet__147NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__142, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__142NumDims));
            Hemorrhage_UNet__147 = Hemorrhage_UNet__142(indices1009{:});

            % Concat:
            [Hemorrhage_UNet__145, Hemorrhage_UNet__145NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__146, this.Vars.Hemorrhage_UNet__144, Hemorrhage_UNet__147}, [coder.const(Hemorrhage_UNet__146NumDims), this.NumDims.Hemorrhage_UNet__144, coder.const(Hemorrhage_UNet__147NumDims)]);

            % Cast:
            Hemorrhage_UNet__140 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__145)), 'like', Hemorrhage_UNet__145);
            Hemorrhage_UNet__140NumDims = coder.const(Hemorrhage_UNet__145NumDims);

            % Reshape:
            [shape1010, Hemorrhage_UNet__139NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Hemorrhage_UNet__143, Hemorrhage_UNet__140, coder.const(Hemorrhage_UNet__143NumDims), 0);
            Hemorrhage_UNet__139 = reshape(Hemorrhage_UNet__143, shape1010{:});

            % Set graph output arguments
            Hemorrhage_UNet__139NumDims1002 = coder.const(Hemorrhage_UNet__139NumDims);

        end

    end

end