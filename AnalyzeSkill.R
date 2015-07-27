library(dplyr)
library(ggplot2)
source("/Users/yanwang/Dropbox/InsightDataScience/UnlistSkill.R")
source("/Users/yanwang/Dropbox/InsightDataScience/ClassifySubject.R")

# load the training data
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/training.Rda"
load(file_name)

# unlist the skill data
newdata <- UnlistSkill(training)
  
# save the training data with ID, skill, industry and rank
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/skilltraining.Rda"
save(newdata, file=file_name)

industrygroup <- split(newdata, newdata$industry) # split the data into industries

# pick the top skills for each industry
rename <- dplyr::rename
num <- 320
CountSkill <- function(dataframe, n){
  skillgroup <- as.data.frame(table(factor(dataframe$skill)))
  skillgroup <- arrange(skillgroup, desc(Freq))
  topskill <- skillgroup[1:n,]
  topskill <- rename(topskill, skill=Var1)
}
topskill <- lapply(industrygroup, CountSkill, n=num)

# plot the top skills for each of the top industries 
index <- 10
industryname <- names(topskill)
industry <- industryname[index]
skilldata <- topskill[[industry]]
q <- qplot(x=skill, y=Freq, data=skilldata, geom="bar", stat="identity", xlab="", ylab="Number of Cases", main=paste("Top", num, "Skills of", industry), fill=I("red"))
q + theme(axis.text.x = element_text(angle = 45, hjust=1))

# remove any duplicates of skills
skills <- do.call("rbind", topskill)
skills$Freq <- NULL
skills <- unique(skills)

# save the top skills for the top industries
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/skill.Rda"
save(skills, file=file_name)

# create a feature vector for each industry
mutate <- dplyr::mutate
CreateFeature <- function(industrydata, skilldata, name){
  data <- merge(x=skilldata, y=industrydata, by.x="skill", by.y="skill", all.x=TRUE)
  data1 <- mutate(data, indicator=as.numeric(!is.na(data[,name])))
  data2 <- as.list(data1)
}
industryfeature <- lapply(topskill, CreateFeature, skilldata=skills, name="Freq")

# save the industry feature
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industryfeature.Rda"
save(industryfeature, file=file_name)

# classify the subject in the training data
result <- ClassifySubject(newdata)
confusionMatrix(result$prediction, result$truth)
confusionMatrix(result$prediction1, result$truth)

# save the result
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/resulttraining.Rda"
save(result, file=file_name)