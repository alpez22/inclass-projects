# add your code to this file
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#Question 1
def plot_data(df):
    ''' num of frozen days vs num of frozen in a year '''
    plt.figure()
    plt.plot(df['year'], df['days'], 'o', label='Data')
    plt.xlabel("Year")
    plt.ylabel("Ice Days")
    plt.savefig("data_plot.jpg")
    plt.close()

#Question 2
def normalize_data(df):
    '''perform min-max normalization on our input feature (that is, on the x’s)'''
    
    x = df['year'].values
    y = df['days'].values
    m = np.min(x)
    M = np.max(x)
    
    #min-max normalization on x
    x_norm = (x - m) / (M - m)
    
    #augment normalized feature, bold x tilde, with a constant term (for bias)
    X_aug = np.column_stack((x_norm, np.ones(len(x_norm))))
    
    return X_aug, y, m, M

#Question 3
def closed_form_solution(X, y):
    '''find a weight w and bias b to minimize the MSE loss
    
    X = design matrix (normalized feature values, 1's)

    returns weights (w = slope/weight ; b = intercept/bias)
    '''
    weights = np.linalg.inv(X.T @ X) @ (X.T @ y) #(inverse of the (2,2) matrix) * (transposed matrix * target values y)
    return weights

#Question 4
def gradient_descent(X, y, alpha, iterations):
    '''an alternative way, besides the closed-form solution, to learn the best linear model parameters'''
    
    n = len(y)
    #get normalized feature values - first column of X
    x_norm = X[:, 0]
    
    w, b = 0.0, 0.0
    loss_list = []

    print(np.array([w, b])) #print [0,0] weight and bias
    
    #run gradient descent
    for t in range(iterations):
        #compute predictions y_hat = w*x_norm + b
        y_hat = w * x_norm + b
        error = y_hat - y
        
        #compute gradients for w and b
        w_gradient = (1/n) * np.sum(error * x_norm)
        b_gradient = (1/n) * np.sum(error)
  
        w = w - alpha * w_gradient
        b = b - alpha * b_gradient
        
        #compute loss (1/(2*n)) * sum((y_hat - y)^2).
        loss = (1/(2*n)) * np.sum(error**2)
        loss_list.append(loss)
        
        #print weight and bias every 10 iterations
        if (t+1) % 10 == 0 and (t+1) < iterations:
            print(np.array([w, b]))

    return w, b, loss_list

def main():
    filename = sys.argv[1]
    alpha = float(sys.argv[2])
    iterations = int(sys.argv[3])
    df = pd.read_csv(filename)
    
    #Question 1: Data Visualization
    plot_data(df)
    
    #Question 2: Data Normalization
    X_normalized, y, m, M = normalize_data(df)
    print("Q2:")
    print(X_normalized)
    
    #Question 3: Closed-Form Solution to Linear Regression
    weights = closed_form_solution(X_normalized, y)
    print("Q3:")
    print(weights)
    
    #Question 4: Linear Regression with Gradient Descent
    print("Q4a:")
    w_gradient, b_gradient, loss_list = gradient_descent(X_normalized, y, alpha, iterations)
    print("Q4b: " + str(alpha))
    print("Q4c: " + str(iterations))
    print("Q4d: In order to get a good learning weight, The final parameters w and b must reach values that are close to the closed‐form solution which is within a small tolerance like 0.01. I started with a low learning rate and gradually increased it until the gradient descent converged within 500 iterations. I observed that having too high of a rate caused divergence, which I found was around 1.6, and settled on a rate that converged within 500 iterations to weights near the closed-form values. The range I found that still converged was 0.27 through 1.5.")
    
    #Question 4e: Plot the MSE loss
    plt.figure()
    plt.plot(range(iterations), loss_list)
    plt.xlabel("Iteration")
    plt.ylabel("Loss")
    plt.savefig("loss_plot.jpg")
    plt.close()
    
    #Question 5: Prediction for winter 2023-24
    w = weights[0]
    b = weights[1]
    x_2023_norm = (2023 - m) / (M - m)
    y_hat = w * x_2023_norm + b
    print("Q5: " + str(y_hat))
    
    #Question 6: Model Interpretation
    symbol = ">" if w > 0 else ("<" if w < 0 else "=")
    print("Q6a: " + symbol)
    print("Q6b: w > 0 suggests that ice days increase over time, w < 0 indicates they decrease over time, and w = 0 shows no change in ice days with time.")
    
    #Question 7: Model Limitations
    if w != 0:
        x_star = m - (b * (M - m) / w)
    else:
        x_star = float('inf')
    print("Q7a: " + str(x_star))
    print("Q7b: This estimate relies on a simple linear approach that may not capture nonlinear climate effects or other external influences. Extrapolating beyond the data can lead to unreliable results and could overlook factors like climate change or other variables.")

    '''tolerance = 0.01
    diff_w = abs(w_gradient - weights[0])
    diff_b = abs(b_gradient - weights[1])

    if diff_w < tolerance and diff_b < tolerance:
        print("Good learning rate")
    else:
        print("Bad learning rate")'''



if __name__ == "__main__":
    main()
