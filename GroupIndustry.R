library(sparcl)
library(dplyr)

# load the industry feature vector
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industryfeaturekeyword_320.Rda"
load(file_name)

# plot the dendrogram of the industries based on the Euclidean distance of the feature vectors between each two indsutries
newdata <- lapply(industryfeature, function(data) data.frame(as.list(setNames(data$weight, data$keyword))))
data <- do.call("rbind", newdata)
hc <- hclust(dist(data))

# cut the tree based on the number of desired groups
y <- cutree(hc, k=17)
ColorDendrogram(hc, y = y, labels = names(y), branchlength=0.05, xlab="Industry", main="Industry Group")

# save the tree
file_name <- "/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/industrygroup.Rda"
save(y, file=file_name)

# convert the data group into a data frame
z <- data.frame(industry=names(y), value=y)
z <- rbind(z, data.frame(industry="Unknown", value=0))

# recalculate the classification accuray by grouping industries
name_list <- c("20_0.4212", "40_0.4477", "80_0.4672", "160_0.4779", "320_0.4832")
data <- NULL
for (i in 1:length(name_list)){
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/resulttestingkeyword_", name_list[i], ".Rda", sep="")
  load(file_name)
  
  result1 <- merge(x=result, y=z, by.x="truth", by.y="industry", all.x=TRUE)
  result2 <- merge(x=result1, y=z, by.x="prediction", by.y="industry", all.x=TRUE)
  rename <- dplyr::rename
  result3 <- rename(result2, truthvalue=value.x, predictionvalue=value.y)
  
  result3$truthvalue <- as.factor(result3$truthvalue)
  result3$predictionvalue <- as.factor(result3$predictionvalue)
  levels(result3$truthvalue) <- c(levels(result3$truthvalue), 0)
  
  accuracy <- confusionMatrix(result3$predictionvalue, result3$truthvalue)
  print(accuracy)
  
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/IndustryAnlysis/resultgroup_", name_list[i], ".Rda", sep="")
  save(accuracy, file=file_name)
}
