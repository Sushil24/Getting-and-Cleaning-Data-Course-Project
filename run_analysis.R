library(reshape2)
#Setting directory, dowloading data and unzipping it 
setwd("C:/Users/user/coursera/Data")
filename <- "getdata_dataset.zip"
fileurl<- c("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
filename2<- c("UCI HAR Dataset")
if(!file.exists(filename))
  
{
  download.file(fileurl,filename)
}
if(!file.exists(filename2))
{
  unzip(filename)
}
setwd("C:/Users/user/Coursera/Data/UCI HAR Dataset")


# creating Activity & Feature variables 
activity_names<- read.table("activity_labels.txt")
activity_names[,2]<- as.character(activity_names[,2])
feature<- read.table("features.txt")
feature[,2]<- as.character(feature[,2])

# Extracting info on mean and standard deviation
feature_new<- grep(".*mean|.*std.*", feature[,2])
feature_new.names<- feature[feature_new,2]
feature_new.names=gsub('-mean','Mean',feature_new.names)
feature_new.names=gsub('-std','Std',feature_new.names)
feature_new.names=gsub('[-()]','',feature_new.names)

# Loading training Datasets
training<- read.table("train/X_train.txt")[feature_new]
training_Activities <- read.table("train/Y_train.txt")
training_subjects<- read.table("train/subject_train.txt")
training<- cbind(training,training_Activities,training_subjects)

# Loading test Datasets
test<- read.table("test/X_test.txt")[feature_new]
test_Activities <- read.table("test/Y_test.txt")
test_subjects<- read.table("test/subject_test.txt")
test<- cbind(test,test_Activities,test_subjects)

#Merging of training & test datasets
mergedData<- rbind(training,test)
colnames(mergedData)<- c(feature_new.names,"Subject", "Activity")

 #Converting to factors
mergedData$Activity<-factor(mergedData$Activity, levels = activity_names[,1], labels = activity_names[,2])
mergedData$Subject<- as.factor(mergedData$Subject)

#writing to tidy.txt
mergedData.melted<- melt(mergedData, id= c("Subject","Activity"))
mergedData.mean<- dcast(mergedData.melted, Subject + Activity ~ variable,mean)
write.table(mergedData.mean,"tidy.txt")
