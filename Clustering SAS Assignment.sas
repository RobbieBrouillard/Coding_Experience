/* SAS Clustering Assignment */

proc import 
datafile='C:\Users\Robbie\Desktop\SAS\power_usage.xlsx' 
DBMS=xlsx out=power replace;
proc print data=power;
run;

/* A & B */
proc fastclus data=power maxclusters=6 out=clust  MAXITER=20;
var Global_active_power Global_reactive_power Global_intensity;
run;

/* C, D, E */
proc univariate data=power normal plot;
var Global_active_power Global_reactive_power Global_intensity;
run;

data mod_power; set power;
if Global_active_power > 5.564 then delete;
if Global_reactive_power > 0.3635 then delete;
if Global_intensity > 23.3 then delete;
run;
proc print data=mod_power;
run;

proc fastclus data=mod_power maxclusters=6 out=clust  MAXITER=20;
var Global_active_power Global_reactive_power Global_intensity;
run;
