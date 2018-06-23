function FD = GetFlowDist(x,y,NODATA)

% flow distance
NodeFD=nan(length(x),1);
FD(1)=0;
x(x==NODATA)=NaN;
y(x==NODATA)=NaN;
AvgNodeSpacing=200;
for i=2:length(x)
    if isnan(x(i)) || isnan(x(i-1))
        FD(i)=FD(i-1)+AvgNodeSpacing;
    else
        FD(i)=FD(i-1)+ sqrt( (x(i)-x(i-1))^2 + (y(i)-y(i-1))^2 );
    end
end
FD=FD./1000; %km

return