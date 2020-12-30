# course directory ####
course_directory = '~/git/courses/practical_machine_learning/'


# class 2 ####
# setup environment
setwd(course_directory)
library(caret)
library(kernlab)
# load data
data(spam)

# create a training sample with 75% of the data
index = createDataPartition(y = spam$type, p = 0.75, list = FALSE)
df_train = spam[index, ]
df_test = spam[-index, ]
# create 10 folds for cross-validation
  # it can return the 10 folds to train or to test (returnTrain = TRUE or FALSE)
folds = createFolds(y = spam$type, k = 10, list = TRUE, returnTrain = TRUE)
# create resamples with replacement for resampling
resamples = createResample(y = spam$type, times = 10, list = TRUE)
# create time slices
tme = 1:1000
windows = createTimeSlices(y = tme, initialWindow = 20, horizon = 10)
names(windows)


# class 3 ####
setwd(course_directory)
library(caret)
library(ggplot2)
library(Hmisc)
library(ISLR)
library(pdp)
# load data
data(Wage)

# analyze training data, and training data only!
summary(Wage)
index = createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
df_train = Wage[index, ]
df_test = Wage[-index, ]
featurePlot(x = df_train[, c('age', 'education', 'jobclass')],
            y = df_train$wage, plot = 'pairs')
# make 3 factor quantiles using cut2()
cut_wage = cut2(df_train$wage, g = 3)
table(cut_wage)
# useful plots
p1 = qplot(cut_wage, age, data = df_train, fill = cut_wage, geom = c('boxplot'))
p2 = qplot(cut_wage, age, data = df_train, fill = cut_wage, geom = c('boxplot', 'jitter'))
grid.arrange(p1, p2, ncol = 2)
# analysing variables agains each other
t1 = table(cut_wage, df_train$jobclass)
# calculate the proportion of the table per row (1)
prop.table(t1, 1)
# plot density (quite like histogram)
qplot(wage, data = df_train, colour = education, geom = 'density')


# class 4 ####
# setup environment
setwd(course_directory)
library(caret)
library(kernlab)
library(RANN)
# load data
data(spam)

# create a training and testing sets
index = createDataPartition(y = spam$type, p = 0.75, list = FALSE)
df_train = spam[index, ]
df_test = spam[-index, ]
# make some NA values
df_train$capAve = df_train$capitalAve
select_na = rbinom(nrow(df_train), size = 1, prob = 0.05) == 1
df_train$capAve[select_na] = NA
# impute values with k (here equal to 10) nearest neighbors
  # it takes the mean of this 10 nearest neighbors and impute this value
pp_imp = preProcess(df_train[, -58], method = 'knnImpute')
cap_ave = predict(pp_imp, df_train[, -58])$capAve
# it's important to compare the imputed vector with the true vector
quantile(cap_ave - df_train$capitalAve)
# here it compares only the imputed values
quantile((cap_ave - df_train$capitalAve)[select_na])
# here it compares only the ones that were not imputed
quantile((cap_ave - df_train$capitalAve)[-select_na])


# class 5 ####
# setup environment
setwd(course_directory)
library(ISLR)
library(caret)
data(Wage)
index = createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
df_train = Wage[index, ]
df_test = Wage[-index, ]
table(df_train$jobclass)
# dummy variables
dummies = dummyVars(wage ~ jobclass, data = df_train)
head(predict(dummies, newdata = df_train))
# near to zero variables
nsv = nearZeroVar(df_train, saveMetrics = TRUE)
nsv
# splines
library(splines)
bs_basis = bs(df_train$age, df = 3)
bs_basis
