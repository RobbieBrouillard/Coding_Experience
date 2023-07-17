
import numpy as np

# Covariance matricies
sigA = np.array([[1, .5, .5], [.5, 1, .5], [.5, .5, 1]])
sigB = np.array([[1, .5, .25], [.5, 1, .5], [.25, .5, 1]])

# Mean vector
mean = np.array([0,0,0])

# Simulations
N = 1000
simA = np.random.multivariate_normal(mean, sigA, N)
simB = np.random.multivariate_normal(mean, sigB, N)

# Calculating means and covariances of simulations
simAMean = np.mean(simA, axis=0)
simBMean = np.mean(simB, axis=0)
simACov = np.cov(simA.T)
simBCov = np.cov(simB.T)


# Print simulated means and covariances
print("\nCovariance Matrix A:\n", sigA)
print("\nFirst 10 scenarios from Matrix A:\n", simA[:10,:])
print("\nMean: ", simAMean)
print("\nCovariance:\n", simACov)

print("\nCovariance Matrix B:\n", sigB)
print("\nFirst 10 scenarios from Matrix B:\n", simB[:10,:])
print("\nMean: ", simBMean)
print("\nCovariance:\n", simBCov)
