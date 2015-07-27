library(caret)

# load the data set with a uniform number of cases in each of the top industries
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/data.Rda"
load(file_name)

# split the data into the training and testing set
percent <- 0.5
set.seed(913)
train_index <- createDataPartition(y=selecteddata$industry, p=percent, list=FALSE)
training <- selecteddata[train_index,]
testing <- selecteddata[-train_index,]
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/training.Rda"
save(training, file=file_name)
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/testing.Rda"
save(testing, file=file_name)