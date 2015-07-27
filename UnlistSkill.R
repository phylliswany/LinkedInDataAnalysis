UnlistSkill <- function(training){
  library(reshape2)
  library(dplyr)
  
  data <- training[, c("industry", "skills")] # select the column of interests
  mutate <- dplyr::mutate
  data <- mutate(data, ID=1:nrow(data)) # append an ID column to the data
  melt <- reshape2::melt
  data1 <- melt(lapply(setNames(data$skills, data$ID), function(x) unlist(x))) # decompose the list of skills into database elements
  rename <- dplyr::rename
  data1 <- rename(data1, skill=value, ID=L1) # rename the column
  data2 <- merge(data1, data, by.x="ID", by.y="ID", all=TRUE, sort=TRUE) # append industry and skiils to the data
  data3 <- split(data2, data2$ID) # split the data by ID
  
  # remove any duplicates and append a rank column to the data
  AddColumn <- function(data){
    data <- unique(data)
    data <- mutate(data, rank=1:nrow(data))
  }
  data4 <- lapply(data3, AddColumn)
  
  data5 <- do.call("rbind", data4) # combind the list into a dataframe
  data5$skills <- NULL # remove the column of skills
  newdata <- data5
}
  