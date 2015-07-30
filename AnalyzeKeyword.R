library(dplyr)
library(ggplot2)
library(caret)
source("/Users/yanwang/Dropbox/InsightDataScience/UnlistKeyword.R")
source("/Users/yanwang/Dropbox/InsightDataScience/ClassifySubjectWithKeyword.R")

# load the training data
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/training.Rda"
load(file_name)

# unlist the keyword data
newdata <- UnlistKeyword(training)

# save the training data with ID, keyword and industry
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/keywordtraining.Rda"
save(newdata, file=file_name)

newdata <- newdata[-which(newdata$keyword == ""),] # remove the space in the keyword list
industrygroup <- split(newdata, newdata$industry) # split the data into industries

# pick the top keywords for each industry
rename <- dplyr::rename
mutate <- dplyr::mutate
num <- 20
CountKeyword <- function(dataframe, n){
  skillgroup <- as.data.frame(table(factor(dataframe$keyword)))
  skillgroup <- arrange(skillgroup, desc(Freq))
  topskill <- skillgroup[1:n,]
  topskill <- rename(topskill, keyword=Var1)

}
topkeyword <- lapply(industrygroup, CountKeyword, n=num)

# remove the common keyword across the top industries
commonword <- Reduce(intersect, lapply(topkeyword, function(x) x$keyword))
RemoveCommonWord <- function(keyworddata, word){
  for (i in 1:length(word)){
    keyworddata <- keyworddata[-which(keyworddata$keyword==word[i]),]  
  }
  keyworddata <- mutate(keyworddata, weight=Freq/sum(Freq))
}
topkeyword1 <- lapply(topkeyword, RemoveCommonWord, word=commonword)

# plot the top keywords for each of the top industries 
index <- 11
industryname <- names(topkeyword1)
industry <- industryname[index]
keyworddata <- topkeyword1[[industry]]
q <- qplot(x=keyword, y=weight, data=keyworddata, geom="bar", stat="identity", xlab="", ylab="Weight", main=paste("Top", num, "Keywords of", industry), fill=I("red"))
q + theme(axis.text.x = element_text(angle = 45, hjust=1))

# remove any duplicates of keywords
keywords <- do.call("rbind", topkeyword1)
keywords$Freq <- NULL
keywords$weight <- NULL
keywords <- unique(keywords)

# save the top keywords for the top industries
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/keyword.Rda"
save(keywords, file=file_name)

# create a feature vector for each industry
mutate <- dplyr::mutate
CreateFeature <- function(industrydata, skilldata, name){
  data <- merge(x=skilldata, y=industrydata, by.x="keyword", by.y="keyword", all.x=TRUE)
  data1 <- mutate(data, indicator=as.numeric(!is.na(data[,name])))
  data1[is.na(data[,name]), name] <- 0 
  data2 <- as.list(data1)
}
industryfeature <- lapply(topkeyword1, CreateFeature, skilldata=keywords, name="weight")

# save the industry feature
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industryfeaturekeyword.Rda"
save(industryfeature, file=file_name)

# classify the subject in the training data
result <- ClassifySubjectWithKeyword(newdata, "training", num)
confusionMatrix(result$prediction, result$truth)
confusionMatrix(result$prediction1, result$truth)

# save the result
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/resulttrainingkeyword.Rda"
save(result, file=file_name)
