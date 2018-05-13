# MATH 6380J
# Mini Project 1
# The US Crime Data
# Author: Xia Jiacheng, Dong Chenyang

# Preprocessing, centering and scaling first
data_original = read.csv('crimedata.csv')
data_original = na.omit(data_original)
data1 = scale(data_original[,6:22], center = TRUE, scale = TRUE)
data2 = scale(data_original[,29:35], center = TRUE, scale = TRUE)
data = as.matrix(cbind(data1,data_original[,23:28],data2))

# random 10% as test set
set.seed(123)
dt = sort(sample(nrow(data),0.9*nrow(data)))
train = data[dt,]
test = data[-dt,]

# y: independent variables, x: dependent variables
x = train[,1:23]
y = train[,24:30]

# check PCA
x.pca = prcomp(x, center = TRUE, scale. = FALSE)

# multivariate regression for 7 kinds of crimes
fit_simple_regression = lm(y ~ x)
summary(fit_simple_regression)

# MLE estimator for beta
beta_mle = fit_simple_regression$coefficients # 24*7 matrix, p = 23

########### computing J-S estimator for beta
ones = rep(1,970)
x_1 = cbind(ones,x)
XTX = t(x_1) %*% x_1

# mean squared error of 7 multiple regressions
sigma_hat = c(0.2683,0.3435,0.2578,0.2958,0.2927,0.2506,0.2646)

beta_js = matrix(data = NA, nrow = 24, ncol = 7)

for(i in 1:7){
  beta = beta_mle[,i]
  numerator = 21*sigma_hat[i]**2
  denominator = t(beta)%*%XTX%*%beta
  #print(denominator)
  beta_js[,i] = beta*(1-numerator/denominator)
}
########### done with the computation of J-S estimator of beta

# testing and check the MSE
x_test = test[,1:23]
ones = rep(1,108)
x_test_1 = cbind(ones, x_test)
y_test = test[,24:30]

for(i in 1:7){
  beta = beta_js[,i]
  residual = as.vector(y_test[,i] - x_test_1 %*% beta)
  print(norm(residual, type = "2")^2/108) 
  # print out the MSE for J-S estimator
}

for(i in 1:7){
  beta = beta_mle[,i]
  residual = as.vector(y_test[,i] - x_test_1 %*% beta)
  print(norm(residual, type = "2")^2/108) 
  # print out the MSE for MLE estimator
}


# Lasso with lambda plots

library(glmnet)

# full data to fit lasso first
x = data[,1:23]
y = data[,24:30]

fit_lasso = glmnet(x,y[,1],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Murder")

fit_lasso = glmnet(x,y[,2],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Rape")

fit_lasso = glmnet(x,y[,3],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Robbery")

fit_lasso = glmnet(x,y[,4],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Assault")

fit_lasso = glmnet(x,y[,5],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Burglary")

fit_lasso = glmnet(x,y[,6],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Larceny")

fit_lasso = glmnet(x,y[,7],family = "gaussian", alpha = 1)
plot(fit_lasso,xvar = "lambda",label=TRUE)
print(fit_lasso)
title("Auto")

# 10-fold cross validation for lasso, no.6 crime is Larceny
cvfit = cv.glmnet(x,y[,6],type.measure = "mse", nfolds = 10)
coef(cvfit,s="lambda.min")
plot(cvfit)

# 10-fold cross validation for ridge, no.6 crime is Larceny
cvfit = cv.glmnet(x,y[,6],type.measure = "mse", nfolds = 10, alpha = 0)
coef(cvfit,s="lambda.min")
plot(cvfit)

# adjusting alpha makes no difference
cvfit = cv.glmnet(x,y[,6],type.measure = "mse", nfolds = 10, alpha = 0.1)

# Linearized bregman iteration, 10-fold cross validation
# almost the same performance as Lasso
library(Libra)
cv.lb(x,y[,6],10,1/20,intercept=FALSE,normalize=FALSE)
