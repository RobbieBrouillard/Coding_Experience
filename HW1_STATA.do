* Install freduse
	ssc install freduse, replace
* Question 1 
	*A, Used Total Index as question was ambiguous
drop _all
freduse INDPRO
gen datem=mofd(daten) 
format datem %tm
tsset datem
tsline INDPRO if tin(1972m1,2017m12)
	*B
clear 
freduse IPGMFN
gen datem=mofd(daten) 
format datem %tm
tsset datem
tsline IPGMFN if tin(1972m1,2017m12)
	*C
drop _all
freduse INDPRO IPGMFN
gen datem=mofd(daten) 
format datem %tm
gen lnINDPRO = ln(INDPRO)
gen lnIPGMFN = ln(IPGMFN)
tsset datem
tsline lnINDPRO lnIPGMFN if tin(1972m1,2017m12)

*Question 2
	*A
 program findmean, rclass
	drop _all
	set obs 100
	gen x = rnormal(-1,sqrt(2))
	quietly summarize x, detail
	return scalar mu = r(mean)
end
* figure out how to call funciton
set seed 6219
simulate xmean=r(mu), reps(5000): findmean
summarize, detail

	*B
program findmedian, rclass
	drop _all	
	set obs 100
	gen x = rnormal(-1,sqrt(2))
	quietly summarize x, detail
	return scalar med = r(p50)
end
set seed 6219
simulate xmed=r(med), reps(5000): findmedian
summarize, detail
	
	*C1
program findmeany, rclass
	drop _all
	set obs 100
	gen x = rnormal(-1,sqrt(2))
	gen y = exp(x)
	quietly summarize y, detail
	return scalar mu = r(mean)
end
set seed 6219
simulate ymean=r(mu), reps(5000): findmeany
summarize, detail

	*C2
program findmediany, rclass
	drop _all	
	set obs 100
	gen x = rnormal(-1,sqrt(2))
	gen y = exp(x)
	quietly summarize y, detail
	return scalar med = r(p50)
end
set seed 6219
simulate ymed=r(med), reps(5000): findmediany
summarize, detail

*Question 3
	*A
drop _all
use "\\apporto.com\dfs\CLT\Users\rbrouill_uncc\Desktop\FINN\SPShiller.dta"
gen time = tm(1871m1) + _n-1
format time %tm
tsset time
rename var1 p
label variable p "S&P500 price index"

*equation 1
regress p l.p if tin(1953m4,2013m12), robust
*equation 2
regress d.p l.p if tin(1953m4,2013m12), robust

	*B
*equation 3
clear
freduse GS10
rename GS10 r
gen time = mofd(daten)
format time %tm
tsset time
regress r l.r l2.r l3.r if tin(1953m4,2013m12), robust
*equation 4
regress d.r l.r l2.r l3.r if tin(1953m4,2013m12), robust

	*C
program findrsq, rclass
	drop _all
	set obs 100
	gen time = _n
	tsset time
	gen y = rnormal(0,1)
	quietly regress y L.y
	return scalar rsq = e(r2)
	quietly regress D.y L.y
	return scalar rsqdiff = e(r2)
end
set seed 6219
simulate r2=r(rsq) r2diff=r(rsqdiff), reps(1000): findrsq
summarize


