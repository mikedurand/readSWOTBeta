function Err=CalcErrorStats(Est,Truth)

[nReach,nDays]=size(Est);

Err.All=Est-Truth;
Err.Allv=reshape(Err.All,nReach*nDays,1);
Err.Bias=nanmean(Err.Allv);
Err.RMSE=rms(Err.All(~isnan(Err.Allv)));

return