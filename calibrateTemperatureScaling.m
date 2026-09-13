function calibration = calibrateTemperatureScaling(logits, labels, varargin)
%CALIBRATETEMPERATURESCALING Fit scalar temperature on held-out validation logits.
% Call only with a validation split that was not used to train the model.
p=inputParser; addParameter(p,'OutputFile',""); parse(p,varargin{:}); opt=p.Results;
if isempty(logits) || size(logits,1)~=numel(labels), error('calibrateTemperatureScaling:Input','Logits rows must match labels.'); end
labels=double(labels(:)); if any(labels<0) || any(labels>=size(logits,2)), error('calibrateTemperatureScaling:Labels','Labels must be zero-based class indices.'); end
loss=@(x)nll(logits,labels,exp(x)); x=fminsearch(loss,0,optimset('Display','off'));
T=max(exp(x),0.05); before=softmaxRows(logits); after=softmaxRows(logits/T);
calibration=struct('temperature',T,'validationCount',numel(labels),'uncalibratedNLL',nll(logits,labels,1), ...
 'calibratedNLL',nll(logits,labels,T),'uncalibratedECE',ece(before,labels),'calibratedECE',ece(after,labels), ...
 'note',"Fitted on supplied held-out validation logits only; save and apply prospectively.");
if strlength(string(opt.OutputFile))>0, save(char(opt.OutputFile),'calibration'); end
end
function y=nll(z,l,t), p=softmaxRows(z/t); y=-mean(log(p(sub2ind(size(p),(1:numel(l))',l+1))+eps)); end
function p=softmaxRows(z), z=z-max(z,[],2); p=exp(z); p=p./sum(p,2); end
function v=ece(p,l), [c,k]=max(p,[],2); v=0; for i=1:10, q=c>(i-1)/10 & c<=i/10; if any(q), v=v+mean(q)*abs(mean(c(q))-mean((k(q)-1)==l(q))); end,end,end
