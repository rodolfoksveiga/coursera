# question 1 ####
library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
set.seed(62433)
model_gbm = train(diagnosis ~ ., method = 'gbm', data = training)
pred_gbm = predict(model_gbm, newdata = testing)
model_rf = train(diagnosis ~ ., method = 'rf', data = training)
pred_rf = predict(model_rf, newdata = testing)
model_lda = train(diagnosis ~ ., method = 'lda', data = training)
pred_lda = predict(model_lda, newdata = testing)
pred_df = data.frame(p1 = pred_gbm, p2 = pred_rf, p3 = pred_lda, t = testing$diagnosis)
model_stack = train(t ~ ., method = 'rf', data = pred_df)
pred_stack = predict(model_stack, newdata = pred_df)
