library(caret)
library(ggplot2)
library(GGally)
library(gbm)

testing = read.csv("C:/Coursera/JohnH/Machine learning/pml-testing.csv",na.strings=c("NA","#DIV/0!",""))
training = read.csv("C:/Coursera/JohnH/Machine learning/pml-training.csv", na.strings=c("NA","#DIV/0!",""))

testing$classe = "A"
testing$control = 1
training$control = 0
training$problem_id = 999

combined = rbind(testing,training)

# Remove columns with zero variance (useless columns for prediction)
levelsPerColumn = lapply(combined, function(x) length(unique(x)))
drop = which(levelsPerColumn == 1)
if (length(drop) > 0){
  combined = combined[,-unlist(drop)]
}
nums = sapply(combined, is.numeric)
Allnumeric = combined[, nums]
Allfactors = combined[, !nums]

for(i in c(1:ncol(Allnumeric))) {
  Allnumeric[,i] = as.numeric(Allnumeric[,i])
}

for(i in c(1:ncol(Allfactors))) {
  Allfactors[,i] = as.factor(Allfactors[,i])
}

combined = cbind(Allnumeric, Allfactors)

testing = subset(combined, combined$control == 1)
training = subset(combined, combined$control == 0)

set.seed(123) 
inTrain = createDataPartition(training$classe, p = 3/4)[[1]]
training = training[ inTrain,]
testingcross = training[-inTrain,]

training = training[, -which(colMeans(is.na(training)) > 0.4)]

training$control = NULL
testingcross$control = NULL
testing$control = NULL

training$X = NULL

Control = trainControl(method = "repeatedcv",
                           number = 6,
                           repeats = 2)

mod_gbm = train(classe  ~ ., data = training, method = "gbm",na.action = na.omit,trControl = Control,verbose=FALSE)

testing_pred = predict(mod_gbm, testingcross, type = "raw")
fitgbm = confusionMatrix(testing_pred, testingcross$classe)
fitgbm
varImp(mod_gbm)

control = trainControl(method="repeatedcv", number=10, repeats=3)
metric = "Accuracy"
mtry = sqrt(ncol(training))
tunegrid = expand.grid(.mtry=mtry)
mod_rf = train(classe~., data=training, method="rf", metric=metric, tuneGrid=tunegrid, trControl=control)

mod_rf = train(classe  ~ ., data = training, method = "rf",ntree=500,nodesize = 50 , verbose=FALSE,na.action = na.omit,try=3,allowParallel = TRUE)

testing_predRF = predict(mod_rf, testingcross, type = "raw")
fitrf = confusionMatrix(testing_predRF, testingcross$classe)
fitrf

varImp(mod_rf)

table(testing_predRF, testingcross$classe)
table(testing_pred, testingcross$classe)

testing$GBM = predict(mod_gbm,testing, type = "raw")
testing$RF = predict(mod_rf,testing, type = "raw")



