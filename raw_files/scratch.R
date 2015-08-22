
library(ggplot2)
library(caret)
library(randomForest)

source ("multiclass.R")

trainFile <- "data/pml-training.csv"

wleData <- read.csv(trainFile, na.strings = c("NA", "#DIV/0!"))
inTrain <- createDataPartition(wleData$classe, p = 0.75, list = FALSE)
training <- wleData[inTrain, ]
testing <- wleData[-inTrain, ]

dim(training); dim(testing)

names(training)
sapply(training, class)

# remove columns with more than 80% NAs
nonNACols <- colSums(is.na(training)) < (nrow(training) * 0.8)
training <- training[nonNACols]
testing <- testing[nonNACols]

# remove non relevant temporal info
timecols <- c("X", "raw_timestamp_part_1", "raw_timestamp_part_2",
              "cvtd_timestamp", "new_window")
training[timecols] <- list(NULL)
testing[timecols] <- list(NULL)

names(training)

# remove zerovar covariates
nsv <- nearZeroVar(training, saveMetrics = T)
training <- training[!nsv$nzv]
testing <- testing[!nsv$nzv]

# train model using random forest
modelFit <- train(classe ~., data = training, method = "rf", trControl = trainControl(method = "cv", number = 10, verboseIter = TRUE, summaryFunction = multiClassSummary, classProbs = TRUE), ntree = 10, metric = "ROC")

# out of sample error
predictions <- predict(modelFit, newdata = testing)
confusionMatrix(predictions, testing$classe)



