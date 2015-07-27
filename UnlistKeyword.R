UnlistKeyword <- function(training){
  library(reshape2)
  library(dplyr)
  
  data <- training[, c("industry", "skills")] # select the column of interests
  mutate <- dplyr::mutate
  data <- mutate(data, ID=1:nrow(data)) # append an ID column to the data
  melt <- reshape2::melt
  data1 <- melt(lapply(setNames(data$skills, data$ID), 
                       function(x) unlist(strsplit(tolower(x), split=" |/|\\(|\\)|,|\\.")))) # decompose the list of keywords into database elements
  rename <- dplyr::rename
  data1 <- rename(data1, keyword=value, ID=L1) # rename the column
  data2 <- merge(data1, data, by.x="ID", by.y="ID", all=TRUE, sort=TRUE) # append industry and skiils to the data
  data3 <- split(data2, data2$ID) # split the data by ID
  data4 <- do.call("rbind", data3) # combind the list into a dataframe
  data4$skills <- NULL # remove the column of skills
  newdata <- data4
}