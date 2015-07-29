library(caret)
# source("/Users/yanwang/Dropbox/InsightDataScience/UnlistSkill.R")
# source("/Users/yanwang/Dropbox/InsightDataScience/ClassifySubject.R")
source("/Users/yanwang/Dropbox/InsightDataScience/UnlistKeyword.R")
source("/Users/yanwang/Dropbox/InsightDataScience/ClassifySubjectWithKeyword.R")

# load the testing data
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/testing.Rda"
load(file_name)

# unlist the skill data
# newdata <- UnlistSkill(testing)
# unlist the keyword data
newdata <- UnlistKeyword(testing)

# save the testing data with ID, skill, industry and rank
# file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/skilltesting.Rda"
# save(newdata, file=file_name)
# save the testing data with ID, keyword and industry
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/keywordtesting.Rda"
save(newdata, file=file_name)

newdata <- newdata[-which(newdata$keyword == ""),] # remove the space in the keyword list

# classify the subject in the testing data
# result <- ClassifySubject(newdata)
result <- ClassifySubjectWithKeyword(newdata, "testing", 320)
confusionMatrix(result$prediction, result$truth)
confusionMatrix(result$prediction1, result$truth)

# save the result
# file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/resulttesting.Rda"
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/resulttestingkeyword.Rda"
save(result, file=file_name)