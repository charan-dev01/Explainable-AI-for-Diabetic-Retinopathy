function sim=simulateScreeningCapacity(cfg,varargin)
    %SIMULATESCREENINGCAPACITY District-level throughput simulation.
    % Discrete one-minute queues: capture -> upload -> inference -> human review.
    rng(42);
    p=inputParser;
    addParameter(p,"AnnualPatients",cfg.simulation.annualPatients);
    addParameter(p,"OperatingDays",cfg.simulation.operatingDays);
    addParameter(p,"HoursPerDay",cfg.simulation.hoursPerDay);
    addParameter(p,"CaptureStations",ceil(1/cfg.simulation.captureMinPerPatient));
    addParameter(p,"Processors",cfg.simulation.processors);
    addParameter(p,"Reviewers",cfg.simulation.reviewers);
    addParameter(p,"ProcessingSec",cfg.simulation.processingSecPerImage);
    addParameter(p,"ReviewSec",cfg.simulation.reviewSecPerReferable);
    addParameter(p,"ReferralRate",cfg.simulation.referralRate);
    addParameter(p,"ImageSizeMB",cfg.simulation.imageSizeMB);
    addParameter(p,"UplinkMbps",cfg.simulation.uplinkMbps);
    parse(p,varargin{:}); P=p.Results;

    nMinutes=P.OperatingDays*P.HoursPerDay*60;
    minutes=1:nMinutes;
    arrivalRate=double(P.AnnualPatients)/nMinutes;
    arrivals=poissrnd(arrivalRate,size(minutes));
    captureCap=P.CaptureStations*(60/max(P.captureMinPerPatient,eps));
    procCap=P.Processors*(60/max(P.ProcessingSec,eps));
    reviewCap=P.Reviewers*(60/max(P.ReviewSec,eps));
    bwCap=P.UplinkMbps*60/(8*P.ImageSizeMB);

    captureQ=zeros(size(minutes)); uploadQ=zeros(size(minutes)); procQ=zeros(size(minutes)); reviewQ=zeros(size(minutes));
    captured=zeros(size(minutes)); uploaded=zeros(size(minutes)); processed=zeros(size(minutes)); served=zeros(size(minutes));
    for t=1:nMinutes
        if t>1
            captureQ(t)=captureQ(t-1); uploadQ(t)=uploadQ(t-1); procQ(t)=procQ(t-1); reviewQ(t)=reviewQ(t-1);
        end
        captureQ(t)=captureQ(t)+arrivals(t);
        captured(t)=min(captureQ(t),captureCap); captureQ(t)=captureQ(t)-captured(t);
        uploadQ(t)=uploadQ(t)+captured(t);
        uploaded(t)=min(uploadQ(t),bwCap); uploadQ(t)=uploadQ(t)-uploaded(t);
        procQ(t)=procQ(t)+uploaded(t);
        processed(t)=min(procQ(t),procCap); procQ(t)=procQ(t)-processed(t);
        reviewQ(t)=reviewQ(t)+processed(t)*P.ReferralRate;
        served(t)=min(reviewQ(t),reviewCap); reviewQ(t)=reviewQ(t)-served(t);
    end

    sim=struct();
    sim.timeMinutes=minutes; sim.arrivals=arrivals; sim.captured=captured; sim.uploaded=uploaded; sim.processed=processed; sim.reviewed=served;
    sim.captureCapacity=captureCap; sim.processedCapacity=procCap; sim.reviewCapacity=reviewCap; sim.uplinkImageCapacityPerMinute=bwCap;
    sim.captureQueue=captureQ; sim.uploadQueue=uploadQ; sim.processingQueue=procQ; sim.reviewQueue=reviewQ;
    sim.totalArrivals=sum(arrivals); sim.totalCaptured=sum(captured); sim.totalUploaded=sum(uploaded); sim.totalProcessed=sum(processed); sim.totalReviewed=sum(served);
    sim.maxCaptureQueue=max(captureQ); sim.maxUploadQueue=max(uploadQ); sim.maxProcessingQueue=max(procQ); sim.maxReviewQueue=max(reviewQ);
    sim.unprocessedAtEnd=procQ(end); sim.unreviewedAtEnd=reviewQ(end); sim.uncapturedAtEnd=captureQ(end);
    sim.utilizationCapture=min(1,mean(arrivals)/max(captureCap,eps));
    sim.utilizationProcessing=min(1,mean(uploaded)/max(procCap,eps));
    sim.utilizationReview=min(1,mean(processed*P.ReferralRate)/max(reviewCap,eps));
    sim.parameters=P;
end
