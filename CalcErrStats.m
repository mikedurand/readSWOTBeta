
%reach
Err.RchHeight.All=CalcErrorStats(Hr,Hrt);
i249=Passes==249; i527=Passes==527; i264=Passes==264;
Err.RchHeight.Pass249=CalcErrorStats(Hr(:,i249),Hrt(:,i249));
Err.RchHeight.Pass527=CalcErrorStats(Hr(:,i527),Hrt(:,i527));
Err.RchHeight.Pass264=CalcErrorStats(Hr(:,i264),Hrt(:,i264));

Err.RchSlope.All=CalcErrorStats(Sr,Srt);
Err.RchSlope.Pass249=CalcErrorStats(Sr(:,i249),Srt(:,i249));
Err.RchSlope.Pass527=CalcErrorStats(Sr(:,i527),Srt(:,i527));
Err.RchSlope.Pass264=CalcErrorStats(Sr(:,i264),Srt(:,i264));

Err.RchSlopeEn.All=CalcErrorStats(Sre,Srte);
Err.RchSlopeEn.Pass249=CalcErrorStats(Sre(:,i249),Srte(:,i249));
Err.RchSlopeEn.Pass527=CalcErrorStats(Sre(:,i527),Srte(:,i527));
Err.RchSlopeEn.Pass264=CalcErrorStats(Sre(:,i264),Srte(:,i264));


Err.RchWidth.All=CalcErrorStats(Wr,Wrt);
Err.RchWidth.Pass249=CalcErrorStats(Wr(:,i249),Wrt(:,i249));
Err.RchWidth.Pass527=CalcErrorStats(Wr(:,i527),Wrt(:,i527));
Err.RchWidth.Pass264=CalcErrorStats(Wr(:,i264),Wrt(:,i264));

%node
Err.NodeHeight=CalcErrorStats(Hn,Hnt);
Err.NodeWidth=CalcErrorStats(Wn,Wnt);