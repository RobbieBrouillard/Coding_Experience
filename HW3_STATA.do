* Problem Set 3

drop _all

* Question 1
import excel using "\\apporto.com\dfs\CLT\Users\rbrouill_uncc\Desktop\FINN\HW3\PS3data.xlsx", firstrow
gen time=mofd(Date) 
format time %tm
label variable time "time"
label variable USDEuro "Exchange rate"
tsset time

*A
dfuller CPI, lags (3) regress
dfuller USDEuro, lags (3) regress
	*fail to reject presence of unit root at 10% for both

*B
forvalues i = 1/3 {
	quietly arima CPI, arima(`i',1,0)
	estimates store m`i'
}
quietly arima CPI, arima(1,1,1)
estimates store m4

estimates stats m1 m2 m3 m4
	*m2, ARIMA(2,1,0), according to both AIC and BIC

*C
forvalues i = 1/3 {
	quietly arima USDEuro, arima(`i',1,0)
	estimates store m`i'
}
quietly arima USDEuro, arima(1,1,1)
estimates store m4

estimates stats m1 m2 m3 m4
	*m1, ARIMA(1,1,0) is best for AIC and BIC

*D
gen Delta_CPI = D.CPI
gen Delta_Ex = D.USDEuro
varsoc Delta_CPI Delta_Ex, maxlag(6)
	*AIC selects model VAR(2)

*E
quietly var Delta_CPI Delta_Ex if time < tm(2015m10), lags(1/2)
predict pred_cpi
label variable pred_cpi "forecast"
predict std_cpi, equation(Delta_CPI) stdp
gen lcl = pred_cpi - 1.96*std_cpi
gen hcl = pred_cpi + 1.96*std_cpi

twoway (rarea lcl hcl time, fintensity(inten20)) ///
(line Delta_CPI pred_cpi time, lpattern(solid dash)) in -40/l, ///
legend(order(2 3 1) label(1 "95% CI")) name(Q1EGraph, replace) xtitle("Time") ytitle("CPI Value") title("CPI Forecast")

*F
vargranger
	* Reject at 5%; conclude: Delta_Ex causes/helps predict/forecasts Delt_CPI at 5%
	* Fail to reject at 10%, conclude: Delta_CPI has no influence on DElta_Ex at 10%

*G
quietly var Delta_CPI Delta_Ex if time < tm(2015m10), lags(1/2)
irf create iuf, set(myExamp) step(10) replace
irf graph oirf, impulse(Delta_Ex) response(Delta_CPI)  
graph rename P1, replace
irf graph oirf, impulse(Delta_CPI) response(Delta_Ex)  
graph rename P2, replace
graph combine P1 P2
	*as d_ex inc, d_cpi is predicted to increase for 5 following months w/ max influence 2 steps forward. Makes most sense from economic standpoint
	* d_cpi has almost zero influence over future d_ex

*Question 2
drop _all
ssc install tsmktim
import excel using "\\apporto.com\dfs\CLT\Users\rbrouill_uncc\Desktop\FINN\HW3\industry.xlsx", firstrow
tsmktim time, start (1963m7)
tsset time
drop if time > tm(2018m9)

*A
arch Drugs, arch(1) garch(1)
predict conVar, variance
gen conVolDrugs = sqrt(conVar)
label var conVolDrugs "Cond. Vol. Drugs"
drop conVar

arch Util, arch(1) garch(1)
predict conVar, variance
gen conVolUtil = sqrt(conVar)
label var conVolUtil "Cond. Vol. Util"
drop conVar

arch Banks, arch(1) garch(1)
predict conVar, variance
gen conVolBanks = sqrt(conVar)
label var conVolBanks "Cond. Vol Banks"
drop conVar

twoway (tsline conVolDrugs conVolUtil conVolBanks), name(Q2AGraph) xtitle("Time") ytitle("Volatility") title("Estimated Conditional Volatilities")

*B
mgarch dcc (Drugs Util Banks), arch(1) garch(1)

*C
predict rho*, correlation
label var rho_Util_Drugs "corr(Util,Drugs)"
label var rho_Banks_Drugs "corr(Banks,Drugs)"
label var rho_Banks_Util "corr(Banks,Util)"
twoway (tsline rho_Util_Drugs rho_Banks_Drugs rho_Banks_Util), name(Q2CGraph, replace) xtitle("Time") ytitle("Correlations") title("Estimated Correlations")

*D
predict m*, xb
predict s*, variance
gen mbar = ((m_Drugs + m_Util + m_Banks)/3)
gen var = ((1/3)^2)*(s_Drugs_Drugs + s_Util_Util + s_Banks_Banks) + (2/9)*(s_Util_Drugs + s_Banks_Drugs + s_Banks_Util)
gen conVolportfolio = sqrt(var)
gen VaR = (mbar - (1.645*conVolportfolio))
twoway(tsline VaR), name(Q2DGraph,replace) xtitle(" ") ytitle("VaR") title("Daily VaR at 95%")

*E
gen port_ret = (1/3)*(Drugs + Util + Banks)
arch port_ret, arch(1) garch(1)
predict conVar, variance
gen conVolreturns = sqrt(conVar)
egen mreturns = mean(port_ret)
gen VaR2 = mreturns - 1.645*(conVolreturns)
gen VaRSpread = VaR-VaR2
twoway (tsline VaRSpread), name(Q2EGraph,replace) xtitle(" ") ytitle("VaR Spread") title("VaR Spread at 95%")
graph combine Q2DGraph Q2EGraph, row(2) col(1)

*F
  
generate hit = ((port_ret)-VaR < 0)
summarize hit
 
egen aHat=mean(hit)  
egen tOne=sum((port_ret)-VaR < 0)

gen logNum = (tOne*log(0.05))+((_N-tOne)*log(0.95))
gen logDenom = (tOne*log(aHat))+((_N-tOne)*log(1-aHat))
gen UC=-2*(logNum-logDenom)

gen pval=1-chi2(1,UC)

display UC[1]
display pval[1]  
* unconditional coverage = 0.055, test-stat = 0.454, p-value=0.500
	* Fail to reject that the exceedance rate found, 0.055, is statistcally different that 0.05
	
* for VaR2
drop hit aHat tOne logNum logDenom UC pval
generate hit = ((port_ret)-VaR2 < 0)
summarize hit

egen aHat=mean(hit)  
egen tOne=sum((port_ret)-VaR2 < 0)

gen logNum = (tOne*log(0.05))+((_N-tOne)*log(0.95))
gen logDenom = (tOne*log(aHat))+((_N-tOne)*log(1-aHat))
gen UC=-2*(logNum-logDenom)

gen pval=1-chi2(1,UC)

display UC[1]
display pval[1]  
* unconditional coverage = 0.054, test-stat = 0.251, p-value=0.616
	* Fail to reject that the exceedance rate found, 0.054, is statistcally different that 0.05
	
* Perform basically the same