
import yfinance as yf
import numpy as np
from scipy.stats import skew, kurtosis

# Download the historical S&P500 data
sp = yf.download('^GSPC', start='1980-01-01', end='2021-12-31')

# Calculate daily returns using log returns formula
spReturns = np.log(sp['Adj Close']/sp['Adj Close'].shift(1)).dropna()

# Calculate sample mean, variance, skew, and kurtosis
mean = spReturns.mean()
var = spReturns.var()
skew = spReturns.skew()
kurtosis = spReturns.kurtosis()

# Print reulsts
print("\nSample-mean: ", round(mean,6))
print("Sample-variance: ", round(var,6))
print("Sampe-skewness: ", round(skew,6))
print("Sample-kurtosis: ", round(kurtosis,6))

# Estimate probability of 10% decline
# Calculate percentage change in returns
changeReturn = sp['Adj Close'].pct_change().dropna()
negChange = changeReturn.loc[changeReturn <= -.1]
negCount = len(negChange)

# Estimate probability of 10% decline in the market
totalReturns = len(changeReturn)
probNeg = (negCount/totalReturns) * 100

# Print results
print("\nProbability of a 10% decline in market is: ", round(probNeg,4), "%")
