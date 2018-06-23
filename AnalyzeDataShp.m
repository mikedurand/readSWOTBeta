%script to read example data product

clear all; close all;

addpath ./src     %replace this line with local path to : https://github.com/mikedurand/readSWOTBeta
uselib('aprime')  %replace this line with local path to : https://github.com/mikedurand/SWOTAprimeCalcs

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
DataDir='v20/';  %replace with path to example dataset: go.osu.edu/swotbeta

% read reaches & nodes
[SWOTReaches,TrueReaches,SWOTNodes,TrueNodes]=ReadShapeData(Cycles,Passes,tObs,DataDir);

% extract reaches & nodes
ExtractHWS;

% error stats
CalcErrStats;

% check partial observation
for i=1:nObs
    for j=1:nReach
        fracObs(j,i)=sum(~isnan(Hn(NodesInReach{j},i)))/sum(NodesInReach{j});
    end
end

for i=1:nPass
    for j=1:nReach
        fracObsPass(j,i)=median(fracObs(j,[i:3:nObs]),2);
    end
end

zone = utmzone(latn(1),lonn(1));
utmstruct=defaultm('utm');
utmstruct.zone=zone;
utmstruct=defaultm(utmstruct);
[X, Y] = mfwdtran(utmstruct,latn(:,1), lonn(:,1));
FD = GetFlowDist(nan(size(X)),Y,-9999);
for i=1:nObs
    [~,iSort{i}]=sort(ReachIDnt(:,i));
end

for i=1:nReach
    FDr(i,1)=FD(find(ReachIDnt(:,1)==i,1,'first'));
    FDr(i,2)=FD(find(ReachIDnt(:,1)==i,1,'last'));    
    RL(i)=FDr(i,2)-FDr(i,1);
end

%% overview plots
figure(1)
subplot(131)
mapshow(TrueReaches(1).S,'Color','Blue')
mapshow(SWOTNodes(1).S,'Color','Red','Marker','o')
set(gca,'FontSize',14)
title('Pass 249')
subplot(132)
mapshow(TrueReaches(1).S,'Color','Blue')
mapshow(SWOTNodes(2).S,'Color','Red','Marker','o')
set(gca,'FontSize',14)
title('Pass 264')
subplot(133)
mapshow(TrueReaches(1).S,'Color','Blue')
mapshow(SWOTNodes(3).S,'Color','Red','Marker','o')
set(gca,'FontSize',14)
title('Pass 527')

figure(2) %missing data and reach overveiw
subplot(311)
pcolor(Hr)
colorbar
set(gca,'FontSize',14)
title('Reach height [m]')
ylabel('Reach #')
subplot(312)
pcolor(Sr)
set(gca,'FontSize',14)
title('Reach slope [mm/km]')
ylabel('Reach #')
colorbar
subplot(313)
pcolor(Wr)
colorbar
set(gca,'FontSize',14)
title('Reach width [m]')
xlabel('Observation #')
ylabel('Reach #')

figure(3)
subplot(131)
boxplot(Err.RchHeight.All.Allv)
set(gca,'FontSize',14)
title('Height')
ylabel('Height error, m')
subplot(132)
boxplot(Err.RchSlope.All.Allv)
set(gca,'FontSize',14)
title('Width')
ylabel('Width error, m')
subplot(133)
boxplot(Err.RchSlope.All.Allv)
set(gca,'FontSize',14)
title('Slope')
ylabel('Slope error, mm/km')


figure(4)
plot(1:nReach,fracObsPass,'o-','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Reach #')
ylabel('Fraction Observed (Median across cycles)')
legend('Pass 249','Pass 264','Pass 527','Location','Best')
grid on


%% height plots

figure(5) %reach height error by pass
subplot(131)
boxplot(Err.RchHeight.Pass249.Allv)
set(gca,'FontSize',14)
ylabel('Height error, m')
title('Pass 249')
subplot(132)
boxplot(Err.RchHeight.Pass264.Allv)
set(gca,'FontSize',14)
title('Pass 264')
subplot(133)
boxplot(Err.RchHeight.Pass527.Allv)
set(gca,'FontSize',14)
title('Pass 527')

figure(6) %reach height errors by cycle and node
subplot(311)
pcolor(Err.RchHeight.Pass249.All)
colorbar
set(gca,'CLim',[-0.2 0.2])
ylabel('reach')
title('Height errors')
subplot(312)
pcolor(Err.RchHeight.Pass264.All)
set(gca,'CLim',[-0.2 0.2])
colorbar
ylabel('reach')
subplot(313)
pcolor(Err.RchHeight.Pass527.All)
set(gca,'CLim',[-0.2 0.2])
colorbar
xlabel('cycle')
ylabel('reach')

figure(7) %it's not cross-track distance!
plot(XTDr(:,1)./1000,rms(Err.RchHeight.Pass249.All,2),'o','LineWidth',2); hold on;
plot(XTDr(:,2)./1000,rms(Err.RchHeight.Pass264.All,2),'o','LineWidth',2);
plot(XTDr(:,3)./1000,rms(Err.RchHeight.Pass527.All,2),'o','LineWidth',2); hold off;
set(gca,'FontSize',14)
legend('Pass 249','Pass 264','Pass 527','Location','Best')
xlabel('Reach-averaged cross-track distance, km')
ylabel('Height RMS error')
grid on

%% partially-observed reach sample calculation

figure(8)
i5=find(NodesInReach{5});
plot(FD(i5),Hnt(i5,3),FD(i5),Hn(i5,3),'LineWidth',2)
% plot(NodeID(i5),Hnt(i5,3),NodeID(i5),Hn(i5,3),'LineWidth',2)
set(gca,'FontSize',14)
xlabel('Flow distance, s, km')
% xlabel('Node ID')
ylabel('Water surface elevation, m')
title('Reach 5, Pass 527, Cycle 1')
legend('True','SWOT')
grid on;

Method='Current';
[TrueSlope,TrueHeight] = SampleCalcReachAvg(FD(i5).*1000,Hnt(i5,3)',Method);
[SWOTSlope,SWOTHeight] = SampleCalcReachAvg(FD(i5).*1000,Hn(i5,3)',Method);

disp(['RiverObs vs Sample calc: truth: ' num2str(TrueReaches(3).A(5).Height) ...
    ' vs ' num2str(TrueHeight)])
disp(['RiverObs vs Sample calc: SWOT: ' num2str(SWOTReaches(3).A(5).Height) ...
    ' vs ' num2str(SWOTHeight)])

Method='Fixed';
[SWOTSlopeFix,SWOTHeightFix] = SampleCalcReachAvg(FD(i5).*1000,Hn(i5,3)',Method);

disp(['RiverObs True vs SWOT fixed Sample calc: ' num2str(TrueReaches(3).A(5).Height) ...
    ' vs ' num2str(SWOTHeightFix)])


figure(9) %reach slope errors by cycle and node
subplot(311)
pcolor(Err.RchSlope.Pass249.All)
colorbar
set(gca,'CLim',[-10 10])
xlabel('cycle')
ylabel('reach')
title('Slope errors: Pass 249')
subplot(312)
pcolor(Err.RchSlope.Pass264.All)
set(gca,'CLim',[-10 10])
colorbar
xlabel('cycle')
ylabel('reach')
title('Slope errors: Pass 264')
subplot(313)
pcolor(Err.RchSlope.Pass527.All)
set(gca,'CLim',[-10 10])
colorbar
xlabel('cycle')
ylabel('reach')
title('Slope errors: Pass 527')

figure(10)
subplot(131)
boxplot(Err.RchSlope.Pass249.Allv)
set(gca,'FontSize',14)
ylabel('Slope error, mm/km')
subplot(132)
boxplot(Err.RchSlope.Pass264.Allv)
subplot(133)
boxplot(Err.RchSlope.Pass527.Allv)

figure(11) %reach slope errors by cycle and node
subplot(311)
pcolor(Err.RchWidth.Pass249.All)
colorbar
% set(gca,'CLim',[-10 10])
xlabel('cycle')
ylabel('reach')
title('Width errors: Pass 249')
subplot(312)
pcolor(Err.RchWidth.Pass264.All)
% set(gca,'CLim',[-10 10])
colorbar
xlabel('cycle')
ylabel('reach')
title('Width errors: Pass 264')
subplot(313)
pcolor(Err.RchWidth.Pass527.All)
% set(gca,'CLim',[-10 10])
colorbar
xlabel('cycle')
ylabel('reach')
title('Width errors: Pass 527')

figure(12)
plot(tObs,Hrt([1 2],:),'b-',tObs,Hr([1 2],:),'ro','MarkerSize',8)
set(gca,'FontSize',14)
datetick
ylabel('Water surface elevation, m')
grid

figure(13)
plot(tObs,Srt([4 5],:),'b-',tObs,Sr([4 5],:),'ro','MarkerSize',8)
set(gca,'FontSize',14)
datetick
ylabel('Water surface slope, mm/km')
grid

figure(14)
plot(tObs,Wrt([1 ],:),'b-',tObs,Wr([1 ],:),'ro','MarkerSize',8)
set(gca,'FontSize',14)
datetick
ylabel('Width, m')
grid

figure(15)
subplot(221)
r=1;
plot(Hr(r,:),Wr(r,:),'o','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Height, m'); ylabel('Width, m')
title('Reach 1')
grid on;
subplot(222)
r=4;
plot(Hr(r,:),Wr(r,:),'o','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Height, m'); ylabel('Width, m')
title('Reach 4')
grid on;
subplot(223)
r=7;
plot(Hr(r,:),Wr(r,:),'o','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Height, m'); ylabel('Width, m')
title('Reach 7')
grid on;
subplot(224)
r=10;
plot(Hr(r,:),Wr(r,:),'o','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Height, m'); ylabel('Width, m')
title('Reach 10')
grid on;

for i=1:nReach
    Pass249RMSESlope(i)=(nanmean(Err.RchSlope.Pass249.All(i,:)).^2+ ...
                     nanstd(Err.RchSlope.Pass249.All(i,:)).^2).^.5;
    Pass264RMSESlope(i)=(nanmean(Err.RchSlope.Pass264.All(i,:)).^2+ ...
                     nanstd(Err.RchSlope.Pass264.All(i,:)).^2).^.5;                 
    Pass527RMSESlope(i)=(nanmean(Err.RchSlope.Pass527.All(i,:)).^2+ ...
                     nanstd(Err.RchSlope.Pass527.All(i,:)).^2).^.5;                                  
    Pass249RMSEHeight(i)=(nanmean(Err.RchHeight.Pass249.All(i,:)).^2+ ...
                     nanstd(Err.RchHeight.Pass249.All(i,:)).^2).^.5;
    Pass264RMSEHeight(i)=(nanmean(Err.RchHeight.Pass264.All(i,:)).^2+ ...
                     nanstd(Err.RchHeight.Pass264.All(i,:)).^2).^.5;                 
    Pass527RMSEHeight(i)=(nanmean(Err.RchHeight.Pass527.All(i,:)).^2+ ...
                     nanstd(Err.RchHeight.Pass527.All(i,:)).^2).^.5;                                  
end

figure(18)
plot(RL,Pass249RMSESlope,'o',RL,Pass264RMSESlope,'o',RL,Pass527RMSESlope,'o','LineWidth',2) 

%% nodes

figure(17) 
plot(FD,Hn(iSort{5},7),'.'); hold on;
plot(FD,Hn(iSort{6},8),'.');
plot(FD,Hn(iSort{7},9),'.'); hold off;
set(gca,'FontSize',14)
xlabel('Flow distance, km')
ylabel('Water surface elevation, m')
legend(datestr(tObs(7:9)'),'Location','Best')
title('Passes 249, 264 and 527 from Cycle 3')


figure(18)
hist(Err.NodeHeight.Allv,50)
set(gca,'FontSize',14)
ylabel('Height Error, m')
title('SWOT height errors for nodes')

 
figure(19)
plot(FD,Err.NodeHeight.All,'.')
set(gca,'FontSize',14)
xlabel('Flow distance, km')
ylabel('Height Error, m')
title('SWOT height errors for nodes')

figure(20)
subplot(131)
xt=XTDn(:,i249);
hist(xt(:)./1000)
set(gca,'FontSize',14)
title('Pass 249')
ylabel('Count')
xlabel('Cross-track dist., km')
subplot(132)
xt=XTDn(:,i264);
hist(xt(:)./1000)
set(gca,'FontSize',14)
title('Pass 264')
xlabel('Cross-track dist., km')
subplot(133)
xt=XTDn(:,i527);
hist(xt(:)./1000)
set(gca,'FontSize',14)
title('Pass 527')
xlabel('Cross-track dist., km')

figure(21)
C=get(groot,'defaultAxesColorOrder');
plot(FD,Wnt(:,[7 8 9]),'LineWidth',2); hold on;
h=plot(FD,Wn(:,[7 8 9]),'.','LineWidth',2); hold off;
for i=1:3
    set(h(i),'Color',C(i,:))
end
set(gca,'FontSize',14)
xlabel('Flow distance, km')
ylabel('Width, m')
title('Passes 249, 264 and 527 from Cycle 3')
legend(datestr(tObs(7:9)'),'Location','Best')

figure(22)
XTDnBinBound=[10:62].*1000;
for i=1:length(XTDnBinBound)-1
    j=XTDn(:)>=XTDnBinBound(i) & XTDn(:)<XTDnBinBound(i+1) & ~isnan(Err.NodeWidth.All(:));
    RmsNodeWidthXT(i)=rms(Err.NodeWidth.All(j)); 
end
plot(XTDnBinBound(1:end-1)./1000+.5,RmsNodeWidthXT,'LineWidth',2)
set(gca,'FontSize',14)
xlabel('Cross-track distance, km')
ylabel('Node Width RMSE, m')
title('Node widths')
grid on;


figure(23)
XTDnBinBound=[10:62].*1000;
for i=1:length(XTDnBinBound)-1
    j=XTDn(:)>=XTDnBinBound(i) & XTDn(:)<XTDnBinBound(i+1) & ~isnan(Err.NodeHeight.All(:));
    RmsNodeHeightXT(i)=rms(Err.NodeHeight.All(j)); 
end
plot(XTDnBinBound(1:end-1)./1000+.5,RmsNodeHeightXT.*100,'o-','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Cross-track distance, km')
ylabel('Node height RMSE, cm')
grid on

figure(24)
i=11;  
% j=2:nNode-1;
j=1:nNode;
plot(FD(j),Wnt(j,i),FD(j),Wn(j,i))
set(gca,'FontSize',14)
legend('True','SWOT','Location','Best')
xlabel('Flow distance, km')
ylabel('Node widths, m')
title(['Pass ' num2str(Passes(i)) ', Cycle ' num2str(Cycles(i))])

figure(25)
wcut=100;
hist(Err.NodeWidth.Allv(abs(Err.NodeWidth.Allv)<wcut),50)

figure(26)
hist(Wnt(:),50)
set(gca,'XLim',[0 300],'FontSize',14)
xlabel('River Width, m')
ylabel('Count')
title('True Node Widths')

figure(27)
nids=[1 2];
plot(tObs,Wnt(nids,:),'x-','LineWidth',2); hold on;
h=plot(tObs,Wn(nids,:),'o','LineWidth',2); hold off;
for i=1:2
    set(h(i),'Color',C(i,:))
end
set(gca,'FontSize',14)
datetick
ylabel('River width, m')
legend('True node #1','True node #2','SWOT node #1','SWOT node #2','Location','Best')

figure(28)
nid=375; % 736 works great! 1 doesn't work.
MakePlot=true;
[Wcon,Hcon,igood] = ComputeConstrainedHW(Hn(nid,:),Wn(nid,:),3,.4,30,MakePlot);

plot([nanmin(Wn(nid,:)) nanmax(Wn(nid,:))],[nanmin(Wn(nid,:)) nanmax(Wn(nid,:))],'k-'); 
hold on;
plot(Wnt(nid,igood),Wn(nid,igood),'ro','LineWidth',2,'MarkerSize',10); 
plot(Wnt(nid,igood),Wcon,'bx','LineWidth',2,'MarkerSize',10); 
hold off
set(gca,'FontSize',14)
xlabel('True Width, m')
ylabel('SWOT Width, m')
legend('1:1','Observations','Constrained Obs','Location','Best')
title(['Widths for node #' num2str(nid) '/' num2str(NxNode)])
grid on;

WRMS_ObsNode=rms(Wn(nid,igood)-Wnt(nid,igood));
WRMS_ConNode=rms(Wcon-Wnt(nid,igood));

figure(29)
plot(FD,nanstd(Hnt,[],2),FD,nanstd(Hnt-Hn,[],2))

%% et al.: le geoid!
figure(30)
plot(FD,[TrueNodes(1).A.Geoid_modl])
