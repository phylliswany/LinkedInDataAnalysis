# list the online links for the LinkedIn data
file_list <- c("https://s3.amazonaws.com/michaelfy_linkedinquire/a/1339943811.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/a/1340908651.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/a/1341183840.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/a/1342291185.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/a/1343600993.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/a/1346079419.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/b/1339924049.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/b/1340856843.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/b/1343599675.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/b/1346080769.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/c/1339936359.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/c/1340919790.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/c/1341183282.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/d/1340404404.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/d/1341046986.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/d/1341185084.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/d/1343601474.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/d/1346079024.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/e/1340321519.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/e/1340679843.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/f/1340273836.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/f/1341019617.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/f/1341183840.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/f/1346850632.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/g/1339943811.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/g/1340931760.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/g/1341183541.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/g/1346850740.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/h/1340396840.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/h/1341061543.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/h/1341185293.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/h/1346850815.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/i/1339943811.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/i/1340504581.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/j/1342291712.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/j/1342825035.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/k/1342292185.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/k/1342539907.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/l/1341185427.zip", 
               "https://s3.amazonaws.com/michaelfy_linkedinquire/l/1343599362.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/l/1346850961.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/l/1350271655.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/m/1343599007.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/m/1346081973.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/o/1352042646.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/o/1352733662.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/u/1350271486.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/v/1350271655.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/v/1352734169.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/w/1350271655.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/x/1347479675.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/y/1349035890.zip",
               "https://s3.amazonaws.com/michaelfy_linkedinquire/z/1349035890.zip")

# download the online LinkedIn data and unzip them into Json files
for (i in 1:length(file_list)){
  file_name_1 <- substr(file_list[i], nchar(file_list[i])-15, nchar(file_list[i])-15)
  file_name_2 <- substr(file_list[i], nchar(file_list[i])-13, nchar(file_list[i]))
  file_name <- paste("/Users/yanwang/Desktop/LinkedinData/", file_name_1, "_", file_name_2, sep="")
  download.file(file_list[i], destfile=file_name, method="curl")
  unzip(file_name, exdir="/Users/yanwang/Desktop/LinkedinData/JsonFile")
}


