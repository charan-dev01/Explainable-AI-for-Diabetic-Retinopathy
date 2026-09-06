function [sz, numDimsY] = prepareTileArgs(ONNXRepeats_)
% Prepares arguments for implementing the ONNX Tile operator.  The
% generated code looks like this: 
%
% [sz, NumDims.Y] = prepareTileArgs(Vars.repeats);
% Vars.Y = repmat(Vars.X, sz)
% 
%#codegen

% Copyright 2024 The MathWorks, Inc.

ONNXRepeats = hemorrhage_model.coder.ops.extractIfDlarray(ONNXRepeats_(:)'); % Make repeats a row.

if isscalar(ONNXRepeats)
    % If scalar, just repmat a 1D vector into a longer 1D vector
    sz = [ONNXRepeats 1];
else
    sz = fliplr(ONNXRepeats);
end

numDimsY = numel(ONNXRepeats);
end
