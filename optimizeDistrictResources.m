function plan=optimizeDistrictResources(cfg)
    %OPTIMIZEDISTRICTRESOURCES Find small resource configurations for annual target.
    target=double(cfg.simulation.annualPatients);
    hours=double(cfg.simulation.operatingDays*cfg.simulation.hoursPerDay);
    arrivalPerHour=target/hours;

    rows=[]; k=0;
    for captureStations=1:10
        captureRatePerHour=captureStations*60/cfg.simulation.captureMinPerPatient;
        for processors=1:10
            processRatePerHour=processors*3600/cfg.simulation.processingSecPerImage;
            for reviewers=1:10
                reviewRatePerHour=reviewers*3600/cfg.simulation.reviewSecPerReferable;
                for uplink=[1 2 5 10 20 50]
                    uploadRatePerHour=uplink*60/(8*cfg.simulation.imageSizeMB);
                    bottleneck=min([captureRatePerHour,processRatePerHour,uploadRatePerHour]);
                    referableReviewDemand=arrivalPerHour*cfg.simulation.referralRate;
                    reviewOK=reviewRatePerHour>=referableReviewDemand*1.20;
                    demandOK=bottleneck>=arrivalPerHour*1.20 && reviewOK;
                    if demandOK
                        k=k+1;
                        rows(k,:)=[captureStations processors reviewers uplink bottleneck reviewRatePerHour]; %#ok<AGROW>
                    end
                end
            end
        end
    end
    if k==0, error("No feasible configuration in the search bounds."); end
    T=array2table(rows,"VariableNames",{'CaptureStations','Processors','Reviewers','UplinkMbps','BottleneckPatientsPerHour','ReviewCapacityPerHour'});
    % Cheapest-first heuristic, then favor fewer staff and lower bandwidth.
    T.Score=T.CaptureStations+T.Processors+T.Reviewers+0.1*T.UplinkMbps;
    T=sortrows(T,"Score");
    plan=struct("annualPatients",target,"arrivalPerHour",arrivalPerHour,"feasiblePlans",T,"recommended",T(1,:));
    disp(plan.recommended);
end
