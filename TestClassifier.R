library(caret)
library(rattle)

# load the testing data to test the classifier
file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/treetesting", "_320.Rda", sep="")
load(file_name)
selecteddata <- data
selecteddata$"ID" <- NULL

# load the classifier
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/supportvectormachine_320_0.8878.Rda"
load(file_name)

# test the testing data
pred <- predict(modFit, newdata=selecteddata)
confusionMatrix(pred, selecteddata$truth)

# save the testing result
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/svmtesting_320.Rda"
save(pred, file=file_name)