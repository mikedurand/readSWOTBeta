
[NxReach,ObsReachIDs,NxNode,ObsNodeIDs] = GetNx(SWOTReaches,SWOTNodes);

Hrt=ExtractData(TrueReaches,'Height',NODATA,NxReach,ObsReachIDs,'Reach');
Hr=ExtractData(SWOTReaches,'Height',NODATA,NxReach,ObsReachIDs,'Reach');
Srt=ExtractData(TrueReaches,'Slope',NODATA,NxReach,ObsReachIDs,'Reach');
Sr=ExtractData(SWOTReaches,'Slope',NODATA,NxReach,ObsReachIDs,'Reach');
Sre=ExtractData(SWOTReaches,'Slope_Enh',NODATA,NxReach,ObsReachIDs,'Reach');
Srte=ExtractData(TrueReaches,'Slope_Enh',NODATA,NxReach,ObsReachIDs,'Reach');
Wrt=ExtractData(TrueReaches,'Width',NODATA,NxReach,ObsReachIDs,'Reach');
Wr=ExtractData(SWOTReaches,'Width',NODATA,NxReach,ObsReachIDs,'Reach');

dAr=ExtractData(SWOTReaches,'del_X_Area',NODATA,NxReach,ObsReachIDs,'Reach');

Hnt=ExtractData(TrueNodes,'N_Height',NODATA,NxNode,ObsNodeIDs,'Node');
Hn=ExtractData(SWOTNodes,'N_Height',NODATA,NxNode,ObsNodeIDs,'Node');
Wnt=ExtractData(TrueNodes,'N_width',NODATA,NxNode,ObsNodeIDs,'Node');
Wn=ExtractData(SWOTNodes,'N_width',NODATA,NxNode,ObsNodeIDs,'Node');
XTDn=ExtractData(SWOTNodes,'X_trk_dist',NODATA,NxNode,ObsNodeIDs,'Node');
latn=ExtractData(TrueNodes,'Lat_Node',NODATA,NxNode,ObsNodeIDs,'Node');
lonn=ExtractData(TrueNodes,'Lon_Node',NODATA,NxNode,ObsNodeIDs,'Node');
ReachIDnt=ExtractData(TrueNodes,'Reach_ID',NODATA,NxNode,ObsNodeIDs,'Node');
NodeID=ExtractData(TrueNodes,'Node_ID',NODATA,NxNode,ObsNodeIDs,'Node');
nPix=ExtractData(SWOTNodes,'N_gd_pix',NODATA,NxNode,ObsNodeIDs,'Node');
% Hsign=ExtractData(SWOTNodes,'N_Hght_un',NODATA); %argh these are currently nans

nReach=size(Hr,1);
nNode=size(Hn,1);

for i=1:nReach
    NodesInReach{i}=[TrueNodes(1).A.Reach_ID]==i;
    nNodesInReach(i)=sum(NodesInReach{i});
    for j=1:nPass
        XTDr(i,j)=nanmean(XTDn(NodesInReach{i},j));
    end
end

% RL=ExtractData(SWOTReaches,'Length',NODATA,NxReach,ObsReachIDs,'Reach'); 
% RL=RL(:,1);
% FD = GetFlowDist(xn,yn,NODATA);