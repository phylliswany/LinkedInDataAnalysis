# load the industry table with number of cases in each industry
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industry.Rda"
load(file_name)

# pick the top industries
num <- 20
topindustry <- head(industrytable, 20)

# plot the histogram of top industries
q <- qplot(x=industry, y=Freq, data=topindustry, geom="bar", stat="identity", xlab="", ylab="Number of Cases", main=paste("Top", num, "Industries"), fill=I("red"))
q + theme(axis.text.x = element_text(angle = 45, hjust=1))

# pick the data in the top industries
selecteddata <- NULL
file_list <- list.files(path="/Users/yanwang/Desktop/LinkedinData/CleanedData", pattern=".*Rda")
for (i in 1:length(file_list)){
  print(file_list[i])
  load(paste(path="/Users/yanwang/Desktop/LinkedinData/CleanedData/", file=file_list[i], sep=""))
  tryCatch({
    mergedtable <- merge(linkedin_data, topindustry, by.x="industry", by.y="industry", all=FALSE, sort=TRUE)
    selecteddata <- rbind(selecteddata, mergedtable)
  },
  error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

# randomly pick a subset of cases in each of the top industries 
num <- 2000
datagroup <- split(selecteddata, selecteddata$industry)
SampleDataFrame <- function(dataframe, n){
  index <- sample(nrow(dataframe), n, replace=FALSE)
  newdataframe <- dataframe[index,]
}
sampleddatagroup <- lapply(datagroup, SampleDataFrame, n=num)
selecteddata <- do.call("rbind", sampleddatagroup)

# save the data set
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/data.Rda"
save(selecteddata, file=file_name)