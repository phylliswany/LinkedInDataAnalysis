library(dplyr)
library(ggplot2)

# count the number of cases in each industry
file_list <- list.files(path="/Users/yanwang/Desktop/LinkedinData/CleanedData", pattern=".*Rda")
for (i in 1:length(file_list)){
  print(file_list[i])
  load(paste(path="/Users/yanwang/Desktop/LinkedinData/CleanedData/", file=file_list[i], sep=""))
  tryCatch({
    industrydata <- as.data.frame(table(factor(linkedin_data$industry)))
    if (i == 1){
      rename <- dplyr::rename
      industrytable <- rename(industrydata, industry=Var1)
    }
    else {
      industrytable <- merge(industrytable, industrydata, by.x="industry", by.y="Var1", all=TRUE)
      Freq <- rowSums(industrytable[,c("Freq.x","Freq.y")], na.rm=TRUE)
      mutate <- dplyr::mutate
      industrytable <- mutate(industrytable, Freq)
      select <- dplyr::select
      industrytable <- select(industrytable, -(Freq.x:Freq.y))
    }
  },
  error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

# pick the top industries
num <- 20
industrytable <- arrange(industrytable, desc(Freq))
topindustry <- head(industrytable, num)

# plot the histogram of top industries
q <- qplot(x=industry, y=Freq, data=topindustry, geom="bar", stat="identity", xlab="", ylab="Number of Cases", main=paste("Top", num, "Industries"), fill=I("red"))
q + theme(axis.text.x = element_text(angle = 45, hjust=1))

# save the top industry data
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industry.Rda"
save(industrytable, file=file_name)
