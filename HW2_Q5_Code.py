
import yfinance as yf
import numpy as np
from scipy.stats import skew, kurtosis, norm

# Save ticker names
tickers = {'AAPL', 'BAC', 'KO', 'WFC', 'AXP', 'BK', 'CHTR', 'DAL', 'GS', 'JPM', 'MCO', 'LUV', 'AMZN'}

# Download historical data fro 2018
data = yf.download(tickers, start="2010-01-01", end="2019-12-31")


# Calculate daily returns using log returns formula
returns = np.log(data['Adj Close']/data['Adj Close'].shift(1)).dropna()

# Calculate Mean, covariance matrix, skewness, kurtosis of returns
meanReturns = returns.mean()
covMatrix = returns.cov()
skew = returns.skew()
kurtosis = returns.kurtosis()

# Print resulsts
print("\nSample Means of Returns:")
print(meanReturns)

print("\nSample Covariance Matrix:")
print(covMatrix)

print("\nSample Return Skewness:")
print(skew)

print("\nSample Return Kurtosis:")
print(kurtosis)

