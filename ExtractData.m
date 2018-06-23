function Data=ExtractData(Package,Field,NODATA,Nx,ObsIDs,Type)

npass=length(Package);             %number of passes / obs times
Data=nan(Nx,npass);

for i=1:npass
    
    switch Type
        case 'Node'
            PassIDs=[[Package(i).A.Reach_ID]' [Package(i).A.Node_ID]'];
        case 'Reach'
            PassIDs=[Package(i).A.Reach_ID]';
    end
    
    PassData=[Package(i).A.(Field)]';
    
    iMap=nan(length(PassIDs),1);
    for j=1:length(PassIDs)
        [~,iMap(j)]=ismember(PassIDs(j,:),ObsIDs,'rows'); %need to add error handling 
        Data(iMap(j),i)=PassData(j);
    end    
    
end
    
Data(Data==NODATA)=NaN;

return