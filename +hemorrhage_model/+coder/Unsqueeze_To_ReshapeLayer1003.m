classdef Unsqueeze_To_ReshapeLayer1003 < nnet.layer.Layer & nnet.layer.Formattable
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
            this_cg = hemorrhage_model.coder.Unsqueeze_To_ReshapeLayer1003(mlInstance);
        end
        function this_ml = matlabCodegenFromRedirected(cgInstance)
            this_ml = hemorrhage_model.Unsqueeze_To_ReshapeLayer1003(cgInstance.Name);
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
        function this = Unsqueeze_To_ReshapeLayer1003(mlInstance)
            this.Name = mlInstance.Name;
            this.OutputNames = {'Hemorrhage_UNet__196'};
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

        function [Hemorrhage_UNet__196] = predict(this, Hemorrhage_UNet_1_30__)
            if isdlarray(Hemorrhage_UNet_1_30__)
                Hemorrhage_UNet_1_30_ = stripdims(Hemorrhage_UNet_1_30__);
            else
                Hemorrhage_UNet_1_30_ = Hemorrhage_UNet_1_30__;
            end
            Hemorrhage_UNet_1_30NumDims = 4;
            Hemorrhage_UNet_1_30 = hemorrhage_model.coder.ops.permuteInputVar(Hemorrhage_UNet_1_30_, [4 3 1 2], 4);

            [Hemorrhage_UNet__196__, Hemorrhage_UNet__196NumDims__] = Unsqueeze_To_ReshapeGraph1009(this, Hemorrhage_UNet_1_30, Hemorrhage_UNet_1_30NumDims, false);
            Hemorrhage_UNet__196_ = hemorrhage_model.coder.ops.permuteOutputVar(Hemorrhage_UNet__196__, [2 3 4 1], 4);

            Hemorrhage_UNet__196 = dlarray(single(Hemorrhage_UNet__196_), 'SSCB');
        end

        function [Hemorrhage_UNet__196, Hemorrhage_UNet__196NumDims1011] = Unsqueeze_To_ReshapeGraph1009(this, Hemorrhage_UNet_1_30, Hemorrhage_UNet_1_30NumDims, Training)

            % Execute the operators:
            % Unsqueeze:
            [shape1033, Hemorrhage_UNet__186NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet_1_30, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet_1_30NumDims));
            Hemorrhage_UNet__186 = reshape(Hemorrhage_UNet_1_30, shape1033);

            % Tile:
            [sz1034, Hemorrhage_UNet__191NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__191 = repmat(Hemorrhage_UNet__186, sz1034);

            % Transpose:
            [perm1035, Transpose__232_0NumDims] = hemorrhage_model.coder.ops.prepareTransposeArgs(this.Vars.TransposePerm1010, coder.const(Hemorrhage_UNet__191NumDims));
            if isempty(perm1035)
                Transpose__232_0 = Hemorrhage_UNet__191;
            else
                Transpose__232_0 = permute(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__191), perm1035);
            end

            % Shape:
            [Shape__264_0, Shape__264_0NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet_1_30, coder.const(Hemorrhage_UNet_1_30NumDims), 0, coder.const(Hemorrhage_UNet_1_30NumDims)+1);

            % Gather:
            [Hemorrhage_UNet__189, Hemorrhage_UNet__189NumDims] = hemorrhage_model.coder.ops.onnxGather(Shape__264_0, this.Vars.Const__266, 0, coder.const(Shape__264_0NumDims), this.NumDims.Const__266);

            % Cast:
            Hemorrhage_UNet__190 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__189)), 'like', Hemorrhage_UNet__189);
            Hemorrhage_UNet__190NumDims = coder.const(Hemorrhage_UNet__189NumDims);

            % Slice:
            [indices1036, Hemorrhage_UNet__193NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__190, this.Vars.const_starts__74, this.Vars.const_ends__75, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__190NumDims));
            Hemorrhage_UNet__193 = Hemorrhage_UNet__190(indices1036{:});

            % Slice:
            [indices1037, Hemorrhage_UNet__194NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__190, this.Vars.const_starts__135, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__190NumDims));
            Hemorrhage_UNet__194 = Hemorrhage_UNet__190(indices1037{:});

            % Concat:
            [Hemorrhage_UNet__192, Hemorrhage_UNet__192NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__193, this.Vars.Hemorrhage_UNet__201, Hemorrhage_UNet__194}, [coder.const(Hemorrhage_UNet__193NumDims), this.NumDims.Hemorrhage_UNet__201, coder.const(Hemorrhage_UNet__194NumDims)]);

            % Cast:
            Hemorrhage_UNet__188 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__192)), 'like', Hemorrhage_UNet__192);
            Hemorrhage_UNet__188NumDims = coder.const(Hemorrhage_UNet__192NumDims);

            % Reshape:
            [shape1038, Hemorrhage_UNet__187NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Transpose__232_0, Hemorrhage_UNet__188, coder.const(Transpose__232_0NumDims), 0);
            Hemorrhage_UNet__187 = reshape(Transpose__232_0, shape1038{:});

            % Unsqueeze:
            [shape1039, Hemorrhage_UNet__195NumDims] = hemorrhage_model.coder.ops.prepareUnsqueezeArgs(Hemorrhage_UNet__187, this.Vars.const_fold_opt__286, coder.const(Hemorrhage_UNet__187NumDims));
            Hemorrhage_UNet__195 = reshape(Hemorrhage_UNet__187, shape1039);

            % Tile:
            [sz1040, Hemorrhage_UNet__200NumDims] = hemorrhage_model.coder.ops.prepareTileArgs(this.Vars.const_fold_opt__287_);
            Hemorrhage_UNet__200 = repmat(Hemorrhage_UNet__195, sz1040);

            % Shape:
            [Hemorrhage_UNet__198, Hemorrhage_UNet__198NumDims] = hemorrhage_model.coder.ops.onnxShape(Hemorrhage_UNet__187, coder.const(Hemorrhage_UNet__187NumDims), 0, coder.const(Hemorrhage_UNet__187NumDims)+1);

            % Cast:
            Hemorrhage_UNet__199 = cast(int32(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__198)), 'like', Hemorrhage_UNet__198);
            Hemorrhage_UNet__199NumDims = coder.const(Hemorrhage_UNet__198NumDims);

            % Slice:
            [indices1041, Hemorrhage_UNet__203NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__199, this.Vars.const_starts__74, this.Vars.const_starts__135, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__199NumDims));
            Hemorrhage_UNet__203 = Hemorrhage_UNet__199(indices1041{:});

            % Slice:
            [indices1042, Hemorrhage_UNet__204NumDims] = hemorrhage_model.coder.ops.prepareSliceArgs(Hemorrhage_UNet__199, this.Vars.const_fold_opt__286, this.Vars.const_ends__72, this.Vars.const_starts__74, '', coder.const(Hemorrhage_UNet__199NumDims));
            Hemorrhage_UNet__204 = Hemorrhage_UNet__199(indices1042{:});

            % Concat:
            [Hemorrhage_UNet__202, Hemorrhage_UNet__202NumDims] = hemorrhage_model.coder.ops.onnxConcat(0, {Hemorrhage_UNet__203, this.Vars.Hemorrhage_UNet__201, Hemorrhage_UNet__204}, [coder.const(Hemorrhage_UNet__203NumDims), this.NumDims.Hemorrhage_UNet__201, coder.const(Hemorrhage_UNet__204NumDims)]);

            % Cast:
            Hemorrhage_UNet__197 = cast(int64(hemorrhage_model.coder.ops.extractIfDlarray(Hemorrhage_UNet__202)), 'like', Hemorrhage_UNet__202);
            Hemorrhage_UNet__197NumDims = coder.const(Hemorrhage_UNet__202NumDims);

            % Reshape:
            [shape1043, Hemorrhage_UNet__196NumDims] = hemorrhage_model.coder.ops.prepareReshapeArgs(Hemorrhage_UNet__200, Hemorrhage_UNet__197, coder.const(Hemorrhage_UNet__200NumDims), 0);
            Hemorrhage_UNet__196 = reshape(Hemorrhage_UNet__200, shape1043{:});

            % Set graph output arguments
            Hemorrhage_UNet__196NumDims1011 = coder.const(Hemorrhage_UNet__196NumDims);

        end

    end

end