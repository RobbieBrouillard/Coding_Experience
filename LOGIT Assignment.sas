/* Logit assignment */
proc import datafile='C:\Users\Robbie\Desktop\SAS\CSM.xls'
DBMS=xls out=CSM replace;
proc print data=CSM;
run;

/* creation of hits */
data logit;
set CSM;
hits = (Ratings>= 6.0);
run;
proc print data=logit;
run;

/* logistic regression */
proc logistic data = logit descending;
model hits = Likes Comments Screens;
run;
