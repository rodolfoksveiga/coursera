# setup environment ####
library(caret)
library(corrplot)
library(dplyr)
setwd('~/git/courses/practical_machine_learning/')

# loading ####
# load training and validation data
data = read.csv('pml-training.csv')

# load testing data
data_valid = read.csv('pml-testing.csv')

# cleaning ####
# remove unuseful labels and convert empty fields into na
data = data %>%
  select(-c(1:7)) %>%
  mutate_if(is.character, list(~na_if(., '')))
data_valid = data_valid %>%
  select(-c(1:7)) %>%
  mutate_if(is.character, list(~na_if(., '')))

# check for na values
sum(sapply(data, function(x) any(is.na(x))))

# 100 columns contain na values
unique(colSums(is.na(data))/nrow(data))
# some variables have no na values, while others have 97.9% of na values

# remove variables containing na values
data[, colSums(is.na(data)) > 0] = NULL
data_valid[, colSums(is.na(data_valid)) > 0] = NULL

# pre-processing ####
# split training data into training and validation sets
index = createDataPartition(y = data$classe, p = 0.75, list = FALSE)
data_train = data[index, ]
data_test = data[-index, ]

# check the variable classes
sapply(data_train[, -ncol(data_train)], class)
# all classes are numeric/integer and dummy variables won't be created

# check for near to zero variables
nearZeroVar(data_train)
# no near to zero variables were found

# check for correlation between the input variables
correlations = cor(data_train[, -ncol(data_train)])
corrplot(correlations, method = 'square', type = 'lower', tl.col = 'black', tl.cex = 0.6)
# as it is shown in the graph, some variables have high correlation

# remove high correlated variables
cols <- findCorrelation(correlations, cutoff = 0.9)
data_train = data_train[, -cols]
data_test = data_test[, -cols]

# training ####
# traing algorithms: decision tree, random forest, extreme gradient boosted tree and
  # support vector machine
# sampling method: cross-validation with 5 folders
# pre-process: boxcox

# define a function to fit the models
FitModel = function(method) {
  train_control = trainControl('cv', 3, returnData = FALSE, verboseIter = TRUE)
  model = train(classe ~ ., data_train, method, trControl = train_control,
                tuneLength = 5, preProcess = 'BoxCox')
  return(model)
}

# train models
methods = c(rt = 'rpart', rf = 'rf', xgbt = 'xgbTree', svm = 'lssvmRadial')
models = lapply(methods, FitModel)
saveRDS(models, '~/Desktop/models.rds')

# evaluating ####
# plot training accuracy
comparison = resamples(models)
names(comparison$values)[-1] = names(comparison$values)[-1]
bwplot(comparison, main = 'Models Training Accuracy',
       scales = list(x = list(relation = 'free'), y = list(relation = 'free')))
# rf and xgbt accuracies are pretty similar

# calculate the numeric value for the accuracy, 
mean(comparison$values$'rf~Accuracy')
mean(comparison$values$'xgbt~Accuracy')

# define final model
model = models$rf
model$finalModel
# predict the validation set
preds_test = predict(model, newdata = data_test)
# print out the confusion matrix
confusion_mtx = confusionMatrix(preds_test, as.factor(data_test$classe))
confusion_mtx$table
confusion_mtx$overall[1]

