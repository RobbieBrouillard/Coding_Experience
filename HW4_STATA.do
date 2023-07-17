* Install freduse
	drop _all
	ssc install freduse, replace
* Part A
freduse GS10 TB3MS USREC
gen datem = mofd(daten)
format datem %tm
tsset datem
gen spread = GS10 - TB3MS
probit USREC L12.spread if tin(1959m1,2005m12)
gen Rprob = normal(-.424951 - (.7887162*spread)) 
tsline Rprob if tin(1968m1, 2005m12), title("Probability of Recession in U.S. 12-Months Ahead") xtitle("") ytitle("Probability")

*Part B
*format spread into quarterly spread
gen dateq = qofd(dofm(datem))
format dateq %tq
keep if mod(month(dofm(datem)),3) == 0
drop date USREC daten TB3MS GS10 datem TB3 Rprob
*download then drop spread and dateq
drop spread dateq
*import GDP GDI
freduse GDPC1 A261RX1Q020SBEA
rename (GDPC1 A261RX1Q020SBEA) (GDP GDI)
gen datem = mofd(daten)
format datem %tm
gen dateq = qofd(dofm(datem))
format dateq %tq
*merge spread, GDP, and GDI
merge 1:1 dateq using "\\apporto.com\dfs\CLT\Users\rbrouill_uncc\Desktop\FINN\HW4\spread.dta", keep(match)
tsset dateq
gen changeGDP = (GDP-L.GDP)/(L.GDP)
gen changeGDI = (GDI-L.GDI)/(L.GDI)

reg changeGDP L5.spread if tin(1959q1,2005q4), robust
reg changeGDI L5.spread if tin(1959q1,2005q4), robust

*Part C
reg changeGDP L5.spread L5.changeGDP L5.changeGDI if tin(1959q1,2005q4), robust
reg changeGDI L5.spread L5.changeGDP L5.changeGDI if tin(1959q1,2005q4), robust

*Part D
varsoc GDP GDI if tin(1959q1,2005q4), maxlag(10)
vecrank GDP GDI if tin(1959q1,2005q4), lags(2)