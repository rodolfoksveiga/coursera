# question 1 ####
library(AppliedPredictiveModeling)
library(caret)
library(dplyr)
data(segmentationOriginal)
index = createDataPartition(segmentationOriginal$Case, p = 0.7, list = FALSE)
train_set = segmentationOriginal[index, ]
test_set = segmentationOriginal[-index, ]
set.seed(125)
model_cart = train(form = Class ~ ., data = train_set, method = 'rpart')
plot(model_cart$finalModel)
text(model_cart$finalModel, all = TRUE)


# question 3 ####
library(pgmm)
data(olive)
olive = olive[, -1]
index = createDataPartition(olive$Area, p = 0.7, list = FALSE)
train_set = olive[index, ]
test_set = olive[-index, ]
train_control = trainControl(method = 'repeatedcv', number = 10, repeats = 5)
model_cart = train(form = Area ~ ., data = train_set,
                   method = 'rpart', trControl = train_control)
predictions = predict(model_cart, newdata = as.data.frame(t(colMeans(olive))))
predictions

# question 4 ####
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1], size = dim(SAheart)[1]/2, replace = F)
train_set = SAheart[train,]
test_set = SAheart[-train,]
MissClass = function(values, prediction) {
  sum(((prediction > 0.5)*1) != values)/length(values)
}
set.seed(13234)
fit4 <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl,
              data = train_set, method = 'glm', family = 'binomial')
pred <- predict(fit4, train_set)
mc_train <- MissClass(train_set$chd, predict(fit4, newdata = train_set))
mc_test <- MissClass(test_set$chd, predict(fit4, newdata = test_set))
mc_train

# question 5 ####
library(ElemStatLearn)
library(randomForest)
data(vowel.train)
data(vowel.test)
vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)
set.seed(33833)
fit5 <- randomForest(y~., data=vowel.train)
order( varImp(fit5),decreasing=TRUE)
