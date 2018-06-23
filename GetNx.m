%This script figures out all unique reach & node ids in the database, and
%indices the rows of the reach or node data structure, to allow for
%comparison across passes without all data present. i.e. it handles
%unobserved reaches and nodes

function [NxReach,ObsReachIDs,NxNode,ObsNodeIDs] = GetNx(Reaches,Nodes)

npass=length(Reaches);             %number of passes / obs times

ReachIDs=[];
for i=1:npass
    ReachIDs=[ReachIDs; [Reaches(i).A.Reach_ID]';];            
end

ObsReachIDs=unique(ReachIDs);
NxReach=length(ObsReachIDs);

NodeIDs=[];
for i=1:npass
    NodeIDs=[NodeIDs; [[Nodes(i).A.Reach_ID]' [Nodes(i).A.Node_ID]'];];            
end

ObsNodeIDs=unique(NodeIDs,'rows');
NxNode=length(ObsNodeIDs);


return
