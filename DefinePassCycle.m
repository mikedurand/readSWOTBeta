%specs
NODATA=-9999;
Cycle=1:9;
nCycle=length(Cycle);
Pass=[249 264 527];
ObsDay=[9 10 19];

nPass=length(Pass);
Passes=repmat(Pass,1,nCycle);
Passes=Passes(1:end-2); %this is because for Cycle 9, we only have Pass 249.
nObs=length(Passes);
Cycles=reshape((Cycle'*ones(1,nPass))',nPass*nCycle,1)';
Cycles=Cycles(1:end-2); %this is because for Cycle 9, we only have Pass 249.
tStart=datenum(2009,1,0,0,0,0);
tObs=[];
for i=1:nCycle
    tObs=[tObs tStart+ObsDay+(i-1)*21];
end
tObs=tObs(1:end-2); %this is because for Cycle 9, we only have Pass 249.