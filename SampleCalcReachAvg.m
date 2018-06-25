function [AvgSlope,AvgHeight] = SampleCalcReachAvg(s,h,Method)

igood=~isnan(h);

switch Method
    case 'Current'
        x=s(igood)-mean(s(igood));
        p=polyfit(x,h(igood),1);  %OLS
    case 'Fixed'
        x=s-mean(s);
        p=polyfit(x(igood),h(igood),1);  %OLS
end

AvgSlope=-p(1);
AvgHeight=p(2);

end