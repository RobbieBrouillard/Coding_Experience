
import math
from scipy.stats import norm

# Define all given variables
# Stock price at time zero
S = 32
# Strike prices
K1 = 30
K2 = 32
K3 = 35
# Maturity
T = (1/12)
# Interest rate, continuously coumpounding
r = .02
# Call option premiums
C1 = 2.5
C2 = 1.0
C3 = .75

# Function for the Black-Scholes-Merton call formula
def BSM_call(S, K, T, r, sig):
    d1 = (math.log(S/K) + (r + sig**2/2)*T) / (sig * math.sqrt(T))
    d2 = d1 - (sig * math.sqrt(T))
    return (S*norm.cdf(d1)) - K*math.exp(-r*T)*norm.cdf(d2)

# Function for calculating implied volatility
def imp_vol(S, K, T, r, C):
    x = .01
    y = 1.0
    tolerance = 1e-5
    while (y - x) > tolerance:
        sig = (y+x) / 2
        dif = BSM_call(S, K, T, r, sig) - C
        if dif > 0:
            y = sig
        else:
            x = sig
    return (x+y)/2

# Calculate implied volatilities using given data
ImpVol1 = imp_vol(S, K1, T, r, C1)
ImpVol2 = imp_vol(S, K2, T, r, C2)
ImpVol3 = imp_vol(S, K3, T, r, C3)

# Print implied volatilities
print("\nImplied volatility, Option 1: ", round(ImpVol1,6))
print("\nImplied volatility, Option 2: ", round(ImpVol2,6))
print("\nImplied volatility, Option 3: ", round(ImpVol3,6))



