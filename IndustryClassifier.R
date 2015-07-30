library(caret)
library(rattle)

# load the training data to build the classifier
file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/treetraining", "_320.Rda", sep="")
load(file_name)

# train a tree on the training data
selecteddata <- data
selecteddata$"ID" <- NULL
# modFit <- train(truth ~., method="rpart", data=selecteddata)
# modFit <- train(truth ~., method="nb", data=selecteddata)
# modFit <- train(truth ~., method="glm", data=selecteddata) # cannot apply
modFit <- train(truth ~., method="svmLinear", data=selecteddata) 
# modFit <- train(truth ~., method="svmRadial", data=selecteddata) 

# save the tree
# file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/tree.Rda"
# file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/naivebayes.Rda"
# file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/linearregression.Rda"
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/supportvectormachine_320.Rda"
# file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/supportvectormachineRBF.Rda"
save(modFit, file=file_name)

# test the training data
pred <- predict(modFit, newdata=selecteddata)
confusionMatrix(pred, selecteddata$truth)
