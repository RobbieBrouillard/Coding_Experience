/* Assignment 1 */
/* Import the data */
proc import datafile='C:\Users\Robbie\Desktop\SAS\College.csv'
DBMS=csv out=college replace;
proc print data=college;
run;

/* create dummy variable for 'private' */
data college2;
set college;
if private = 'Yes' then privatedummy=1; else privatedummy=0;
run;
proc print data=college2;
run;

/* Q1 */
/* Generate box plots */
proc univariate data=college2 plot;
var accept top10perc enroll;
run;

/* cutoff value for enroll = 902 +1.5*660 = 1892 */
/* cutoff value for accept = 2424 +1.5*1820 = 5154 */
/* cutoff value for top10perc = 35 + 1.5*20 = 65 */
/* removing outliers */
data mod_college;
set college2;
if enroll > 1892 then delete;
if accept > 5154 then delete;
if top10perc > 65 then delete;
run;
proc print data=mod_college;
run;
proc univariate data=mod_college plot;
var accept top10perc enroll;
run;

/* Q2 */
/* taking log transformation of p_undergrad */
data log_college;
set college2;
lp_undergrad = log(p_undergrad);
run;
proc print data=log_college;
run;

/* splitting data into ENROLLTRAIN and ENROLLTEST */
data ENROLLTRAIN;
set log_college(firstobs=1 obs=544);
run;
proc print data=ENROLLTRAIN;
run;

data ENROLLTEST;
set log_college(firstobs=545 obs=777);
run;
proc print data=ENROLLTEST;
run;

/* Q3 */
/* Part A */
/* regressiong for train data */
proc reg data=ENROLLTRAIN;
model enroll = accept top10perc f_undergrad lp_undergrad room_board grad_rate privatedummy/ tol vif collin;
run;
/* eliminating the varibale one by one untill all variables left are significant */
/* first elimination of 'lp_undergrad */
proc reg data=ENROLLTRAIN;
model enroll = accept top10perc f_undergrad room_board grad_rate privatedummy/ tol vif collin;
run;
/*elimination of grad_rate */
proc reg data=ENROLLTRAIN;
model enroll = accept top10perc f_undergrad room_board privatedummy/ tol vif collin;
run;
/*elimination of privatedummy */
proc reg data=ENROLLTRAIN;
model enroll = accept top10perc f_undergrad room_board/ tol vif collin;
run;

/* Part B */
/*regression for test data */
proc reg data=ENROLLTEST;
model enroll = accept top10perc f_undergrad lp_undergrad room_board grad_rate privatedummy;
run;

/* Part C */
/* check normality of dependent variable enroll */
proc univariate data=college2 normal plot;
var enroll;
run;

