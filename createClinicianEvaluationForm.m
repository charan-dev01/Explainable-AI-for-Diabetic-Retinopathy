function form=createClinicianEvaluationForm(outputFile)
%CREATECLINICIANEVALUATIONFORM Blank structured form; no responses are fabricated.
form=table(strings(0,1),strings(0,1),nan(0,1),nan(0,1),nan(0,1),strings(0,1), ...
 'VariableNames',{'CaseID','ReviewerID','GradCAMUsefulness1to5','LesionEvidenceUsefulness1to5','ReportClarity1to5','Comments'});
if nargin>0 && strlength(string(outputFile))>0, writetable(form,char(outputFile)); end
end
