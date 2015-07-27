library(jsonlite)

alphabet <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "o", "u", "v", "w", "x", "y", "z")
for (j in 1:length(alphabet)){
  rexp <- paste("^", alphabet[j], ".*json$", sep="")
  file_list <- list.files(path="/Users/yanwang/Desktop/LinkedinData/JsonFile", pattern=rexp)
  print(length(file_list))
  
  # keep the data only have full information on location, positions, industry, skills and educations
  linkedin_data <- NULL
  for (i in 1:length(file_list)){
    tryCatch({
      print(file_list[i])
      jsonData <- fromJSON(paste("/Users/yanwang/Desktop/LinkedinData/JsonFile/", file_list[i], sep=""))
      field_name <- names(jsonData)
      index1 <- (jsonData$location != "NULL")
      index2 <- (jsonData$positions != "NULL")
      index3 <- (jsonData$industry != "NULL")
      index4 <- (jsonData$skills != "NULL")
      index5 <- (jsonData$educations != "NULL")
      index <- (index1 & index2 & index3 & index4 & index5)
      selected_data <- jsonData[index, c("location", "positions", "industry", "skills", "educations")] 
      linkedin_data <- rbind(linkedin_data, selected_data)
    },
    error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  }
  nrow(linkedin_data)
  
  # save the cleaned data
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/CleanedData/", alphabet[j], '.Rda', sep="")
  save(linkedin_data, file=file_name)
}
