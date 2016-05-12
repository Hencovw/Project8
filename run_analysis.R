#set working directory, since the files was already downloaded and extracted
setwd("~/Coursra/week4, cleening/UCI HAR Dataset")
library(ddply)

#Read all the reqiured txt files into tables, make sure no headers, and seperator ""
#also made sure the table names are descriptive
features <- read.table("./features.txt", header=FALSE, sep="")
activityType <- read.table("./activity_labels.txt", header=FALSE, sep="")
subjectTrain <- read.table("./train/subject_train.txt", header=FALSE, sep="") 
xTrain <- read.table("./train/X_train.txt", header=FALSE, sep="")
yTrain <- read.table("./train/Y_train.txt" ,header=FALSE, sep="")

subjectTest <- read.table("./test/subject_test.txt", header=FALSE, sep="") 
xTest <- read.table("./test/X_test.txt", header=FALSE, sep="")
yTest <- read.table("./test/Y_test.txt" ,header=FALSE, sep="")


#use features to colnames all the heading
colnames(xTrain) <- features[,2]
colnames(xTest) <- features[,2]

#Couldnt find a table with headings for them, so manually made it something descriptive
colnames(activityType) <- c('activityId','activityType')

colnames(subjectTrain) <- "subjectId"
colnames(subjectTest) <- "subjectId"

colnames(yTrain) <- "ID"
colnames(yTest) <- "ID"

#combine the tables togeather with cbind, merge cant work due to lack of keys 
test <- cbind(subjectTest, xTest, yTest)
train <- cbind(subjectTrain, xTrain, yTrain)


#combine the tables togeather with cbind, merge cant work due to lack of keys
finalData <- rbind(train, test)

#names(finalData) <- gsub("[:punct:]"  ,"", names(finalData))
names(finalData) <- gsub("-"  ,"", names(finalData))
names(finalData) <- gsub("[()]"  ,"", names(finalData))

#Merge the acticity type descriptions to the ID key
finalData <- merge(finalData, activityType, by.x="ID", by.y = "activityId", all=TRUE)

#Summarise the data sets
tidy = ddply(finalData, c("subjectId","activityType"), numcolwise(mean))

#Write out to a file called tidy, so it can be stored
write.table(tidy, file = "tidy.txt", row.names = FALSE)