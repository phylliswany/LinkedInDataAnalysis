ClassifySubjectWithKeyword <- function(data6, datatype, num){
  
  # load the top keywords of the top industries
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/keyword_", num,".Rda", sep="")
  load(file_name)
  
  # load the feature vector for each industry
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industryfeaturekeyword_", num, ".Rda", sep="")
  load(file_name)
  
  data6 <- split(newdata, newdata$ID) # split the data by ID
  
  # add the column of indicator to label the skill owned (1: yes; 0: no)
  LabelKeyword <- function(subjectdata, industrydata, name){
    subjectdata <- unique(subjectdata)
    data <- merge(x=industrydata, y=subjectdata, by.x="keyword", by.y="keyword", all.x=TRUE)
    mutate <- dplyr::mutate
    data <- mutate(data, indicator=as.numeric(!is.na(data[,name])))
    ID <- subjectdata$ID[1]
    industry <- subjectdata$industry[1]
    data1 <- list(ID=ID, industry=industry, keyword=industrydata$keyword, indicator=data$indicator)
  } 
  data7 <- lapply(data6, LabelKeyword, industrydata=keywords, name="industry")
  
  # extract feature vector of each subject into a dataframe
  ExtractSubjectVector <- function(data, keywords){
    data.frame(as.list(setNames(data$indicator, keywords$keyword)), truth=data$industry, ID=data$ID)
  }
  newdata <- lapply(data7, ExtractSubjectVector, keywords=keywords)
  data <- do.call("rbind", newdata)
  
  # save the dataframe for each subject ready for classification algorithms
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/tree", datatype, ".Rda", sep="")
  save(data, file=file_name)
  
  # calculate the distance between skills owned by subjects and required by industries
  CalculateDistance1 <- function(industrydata, subjectdata){
    skill1 <- industrydata$weight
    skill2 <- subjectdata$indicator
    distance <- (as.vector(skill1) %*% as.vector(skill2))/(sqrt(sum(skill1^2))*sqrt(sum(skill2^2)))
  }
  CalculateDistance <- function(subjectdata, industrydata){
    distance <- lapply(industrydata, CalculateDistance1, subjectdata=subjectdata)
    subjectdata <- c(subjectdata, list(distance=unlist(unname(distance))))
  }
  data8 <- lapply(data7, CalculateDistance, industrydata=industryfeature)
  
  # extract the groud truth of industry for each subject
  truth <- lapply(data8, function(x) x$industry)
  truthvector <- as.factor(unlist(unname(truth)))
  levels(truthvector) <- c(levels(truthvector), "Unknown", "Undetermined", "Misclassification")
  
  # extract the reconmmendation of industry for each subject
  skilllist <- as.factor(c(names(industryfeature)))
  ExtractResult <- function(distancelist, skilllist, undeterminedflag){
    if (sum(is.na(distancelist$distance))){
      pred <- "Unknown"
    }
    else {
      maxdistance <- max(distancelist$distance)
      index <- which(distancelist$distance==maxdistance)
      if (length(index) > 1){
        if (undeterminedflag){
          pred <- "Undetermined"
        }
        else {
          if (sum(skilllist[index] == distancelist$industry)){
            pred <- distancelist$industry
          }
          else {
            pred <- "Misclassification"
          }
        }
      }
      else {
        pred <- as.character(skilllist[index])
      }
    }
  }
  pred <- lapply(data8, ExtractResult, skilllist=skilllist, undeterminedflag=TRUE)
  predvector <- as.factor(unlist(unname(pred)))
  
  pred1 <- lapply(data8, ExtractResult, skilllist=skilllist, undeterminedflag=FALSE)
  predvector1 <- as.factor(unlist(unname(pred1)))
  
  # return the result
  result <- list(prediction=predvector, prediction1=predvector1, truth=truthvector)
}