# question 1 ####
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

# question 2 and 3 ####
featurePlot(x = training[, -ncol(training)],
            y = training[, ncol(training)], plot = 'pairs')
plot(x = rownames(training), y = training$CompressiveStrength)
summary(training$Superplasticizer)
table(training$Superplasticizer)
hist(training$Superplasticizer)
hist(log(training$Superplasticizer + 1))

# question 4 ####
library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
cols = grepl('^IL', colnames(training))
pp_data = preProcess(training[, cols], method = 'pca', thresh = 0.9)
print(pp_data)

# question 5 ####
library(caret)
library(AppliedPredictiveModeling)
# fix random number generation to find similar results
RNGversion("3.0.0")
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis, predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
cols = grepl('^IL|diagnosis', colnames(adData))
training = adData[ inTrain, cols]
testing = adData[-inTrain, cols]
# non-pca
model = train(diagnosis ~ ., data = training, method = 'glm')
predictions = predict(model, newdata = testing)
result = confusionMatrix(predictions, testing$diagnosis)[[c('overall', 'Accuracy')]]
# pca
pp_data = preProcess(training, method = 'pca', thresh = 0.8)
training_pca = predict(pp_data, newdata = training)
testing_pca = predict(pp_data, newdata = testing)
model_pca = train(diagnosis ~ ., data = training_pca, method = 'glm')
predictions_pca = predict(model_pca, newdata = testing_pca)
result_pca = confusionMatrix(predictions_pca, testing_pca$diagnosis)[[c('overall', 'Accuracy')]]
