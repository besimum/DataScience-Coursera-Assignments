#######################################################

## Getting and Cleaning Data Course Project
## Benjamin Sila Mutuku
## 06/15/2015

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions
# related to the project. 

# You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you performed 
# to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  

# One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Here are the data for the project: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

######################################################

# set the working directory to the location of the zipped UCI HAR Dataset
setwd("C:/Users/BenjaminM/Coursera-DataScience-Assignments/DataScience-Coursera-Assignments/GettingAndCleaningData")

# read the train data from the files
XTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header = FALSE);
YTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header = FALSE);
subjectTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header = FALSE);

features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", header = FALSE);
activityLabels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header = FALSE);

# create column names for the data frames above
colnames(XTrain)        = features[,2]; 
colnames(YTrain)        = "activityId";
colnames(subjectTrain)  = "subjectId";
colnames(activityLabels) = c('activityId','activityType');

# Merge the training data set :: use cbind (to column bind) the data frames
CompleteTrainingData <- cbind(XTrain, YTrain, subjectTrain);

# Now, let's obtain the test data
XTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header = FALSE);
YTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header = FALSE);
subjectTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header = FALSE);

colnames(XTest) = features[,2];
colnames(YTest) = "activityId";
colnames(subjectTest) = "subjectId";

# Merge the test data set :: use cbind(to column bind) the data frames
CompleteTestData <- cbind(XTest, YTest, subjectTest);

# Merge the training and test data :: use rbind (to row bind) the data frames
CompleteData <- rbind(CompleteTrainingData, CompleteTestData);

# Columnize the CompleteFinalData
colNamesCompleteFinalData <- colnames(CompleteData)

# Mean and Standard Deviation logical vector
logicalVectorMeanSTDV <- (grepl("activity...", colNamesCompleteFinalData) 
                          | grepl("subject...", colNamesCompleteFinalData)
                          | grepl("-mean..",colNamesCompleteFinalData) & !grepl("-meanFreq..",colNamesCompleteFinalData) & !grepl("mean..-",colNamesCompleteFinalData) 
                          | grepl("-std..",colNamesCompleteFinalData) & !grepl("-std()..-",colNamesCompleteFinalData))

# Subset the data based on the logical vector
CompleteData <- CompleteData[logicalVectorMeanSTDV == TRUE];

# include column names
CompleteData <- merge(CompleteData,
                      activityLabels,
                      by.activityId='activityId',
                      all.x=TRUE);

# Merge all data to show activity columns
CompleteData <- colnames(CompleteData);

# Appropriately labels the data set with descriptive variable names
for (i in 1:length(CompleteData)) 
{
  CompleteData[i] = gsub("\\()","",CompleteData[i])
  CompleteData[i] = gsub("-std$","StandardDeviation",CompleteData[i])
  CompleteData[i] = gsub("-mean","Mean",CompleteData[i])
  CompleteData[i] = gsub("^(t)","time",CompleteData[i])
  CompleteData[i] = gsub("^(f)","frequency",CompleteData[i])
  CompleteData[i] = gsub("([Gg]ravity)","Gravity",CompleteData[i])
  CompleteData[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",CompleteData[i])
  CompleteData[i] = gsub("[Gg]yro","Gyro",CompleteData[i])
  CompleteData[i] = gsub("AccMag","AccMagnitude",CompleteData[i])
  CompleteData[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",CompleteData[i])
  CompleteData[i] = gsub("JerkMag","JerkMagnitude",CompleteData[i])
  CompleteData[i] = gsub("GyroMag","GyroMagnitude",CompleteData[i])
};

# Reassigning the new descriptive column names to the finalData set
CompleteData <- colnames(CompleteData);

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
FinalDataNoActivityType  <- CompleteData[,names(CompleteData) != 'activityLabels'];

# Mean of activities and subjects
tidyData <- aggregate(FinalDataNoActivityType[,names(FinalDataNoActivityType) != c('activityId','subjectId')],
                      by=list(activityId=FinalDataNoActivityType$activityId,
                              subjectId = FinalDataNoActivityType$subjectId), mean);

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Export the tidyData set 
# write.table(tidyData, "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/tidyData.txt",row.names=TRUE,sep