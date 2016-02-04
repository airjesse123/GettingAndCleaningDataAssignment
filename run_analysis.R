#get the data.table library
library(data.table)
library(dplyr)

# set wd and show files in that dir
setwd("U:/GettingAndCleaningDataAssignment")
filepath  <- file.path(getwd(),"UCI HAR Dataset")
list.files(filepath, recursive = TRUE)

# get test data from that directory and create tables from it
testPath <- file.path(filepath,"test/subject_test.txt")
testYPath <- file.path(filepath,"test/y_test.txt")
testXPath <- file.path(filepath,"test/X_test.txt")
testTable<-read.table(testPath)
testXTable<-read.table(testXPath)
testYTable<-read.table(testYPath)

# get test subject numbers
names(testTable)<-"Subject"
testData<-data.table(testTable)

#get test features and crop down to just mean and std
featuresPath <- file.path(filepath,"features.txt")
featuresTable <- read.table(featuresPath)
featuresTable[,2]<-sub("^t","Time of ",featuresTable[,2])
featuresTable[,2]<-sub("^f","Frequency of ",featuresTable[,2])
featuresTable[,2]<-sub("BodyBody","Body x Body ",featuresTable[,2])
featuresTable[,2]<-sub("Body","Body ",featuresTable[,2])
featuresTable[,2]<-sub("Gravity","Gravity ",featuresTable[,2])
featuresTable[,2]<-sub("Gyro","by Gyroscope ",featuresTable[,2])
featuresTable[,2]<-sub("Acc","by Accelerometer ",featuresTable[,2])
featuresTable[,2]<-sub("JerkMag","Jerk x Mag ",featuresTable[,2])
featuresTable[,2]<-sub("Jerk","Mag ",featuresTable[,2])
featuresTable[,2]<-sub("Mag","Jerk ",featuresTable[,2])
featuresLogical <- grepl("mean|std", featuresTable$V2)
names(testXTable)=featuresTable$V2
testXTableNew<-testXTable[,featuresLogical]
testXData<-data.table(testXTableNew)

#get test activities and add a column with their name
activitiesPath <- file.path(filepath,"activity_labels.txt")
activitiesTable <- read.table(activitiesPath)
names(activitiesTable)=c("ActivityNumber","ActivityName")
testYTableNew <- testYTable
testYTableNew[,2] <- activitiesTable$ActivityName[testYTable[,1]]
names(testYTableNew)=c("ActivityNumber","ActivityName")
testYData<-data.table(testYTableNew)

#bind together all test above information
allTest<-cbind(testData,testXData,testYData)

# get train data from that directory and create tables from it
trainPath <- file.path(filepath,"train/subject_train.txt")
trainYPath <- file.path(filepath,"train/y_train.txt")
trainXPath <- file.path(filepath,"train/X_train.txt")
trainTable<-read.table(trainPath)
trainXTable<-read.table(trainXPath)
trainYTable<-read.table(trainYPath)

# get train subject numbers
names(trainTable)<-"Subject"
trainData<-data.table(trainTable)

#get train features and crop down to just mean and std
featuresPath <- file.path(filepath,"features.txt")
featuresTable <- read.table(featuresPath)
featuresTable[,2]<-sub("^t","Time of ",featuresTable[,2])
featuresTable[,2]<-sub("^f","Frequency of ",featuresTable[,2])
featuresTable[,2]<-sub("BodyBody","Body x Body ",featuresTable[,2])
featuresTable[,2]<-sub("Body","Body ",featuresTable[,2])
featuresTable[,2]<-sub("Gravity","Gravity ",featuresTable[,2])
featuresTable[,2]<-sub("Gyro","by Gyroscope ",featuresTable[,2])
featuresTable[,2]<-sub("Acc","by Accelerometer ",featuresTable[,2])
featuresTable[,2]<-sub("JerkMag","Jerk x Mag ",featuresTable[,2])
featuresTable[,2]<-sub("Jerk","Mag ",featuresTable[,2])
featuresTable[,2]<-sub("Mag","Jerk ",featuresTable[,2])
featuresLogical <- grepl("mean|std", featuresTable$V2)
names(trainXTable)=featuresTable$V2
trainXTableNew<-trainXTable[,featuresLogical]
trainXData<-data.table(trainXTableNew)

#get train activities and add a column with their name
activitiesPath <- file.path(filepath,"activity_labels.txt")
activitiesTable <- read.table(activitiesPath)
names(activitiesTable)=c("ActivityNumber","ActivityName")
trainYTableNew <- trainYTable
trainYTableNew[,2] <- activitiesTable$ActivityName[trainYTable[,1]]
names(trainYTableNew)=c("ActivityNumber","ActivityName")
trainYData<-data.table(trainYTableNew)

#bind together all train above information
allTrain<-cbind(trainData,trainXData,trainYData)

#merge together test and train
allData<-rbind(allTest,allTrain)

#query the tidy data ussing aggregate
tidyData = aggregate(allData, by=list(ActivityName = allData$ActivityName,Subject=allData$Subject), mean)
tidyData[,84]=NULL
tidyData[,83]=NULL
tidyData[,3]=NULL
tidyData<-tidyData[,c(c(2,1),seq(from=3,to=81))] #Rearrange first two cols
write.table(tidyData, "tidyData.txt", sep="|",row.name=FALSE)
