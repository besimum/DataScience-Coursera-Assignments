######################################################################################

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

# One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained: 

# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Here are the data for the project: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#################################################################################

# Merge the training and the test sets to create one data set.
###########################
library(plyr)
library(memisc)

# set the working directory to the location of the zipped UCI HAR Dataset
setwd("C:/Users/BenjaminM/datasciencecoursera/GettingAndCleaningData/Assignments")

###### Since I have the data already, disable the download code etc in order to source the R code faster ###########
# download the file from source to dest folder
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# if(!file.exists("./data")){dir.create("./data")}
# download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

# unzip (decompress) the zip file to a dest folder
# unzip(zipfile="./data/Dataset.zip",exdir="./data")

# real data
XTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

# test data
XTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
SubjectTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# create a new data set using rbind (row bind) of the x, y and subject datas respectively
XData <- rbind(XTrain, XTest)
YData <- rbind(YTrain, YTest)
SubjectData <- rbind(SubjectTrain, SubjectTest)

features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

# Extracts only the measurements on the mean and standard deviation for each measurement.
###########################
# mean and std dev is in the second column of features data frame
mean_and_standard_deviation_measurement <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the columns
XData <- XData [, mean_and_standard_deviation_measurement]

# set the names of the object
names(XData) <- features[mean_and_standard_deviation_measurement, 2]

# Uses descriptive activity names to name the activities in the data set
###########################
activities <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

# obtain respective column names for the values V1 vs V2, i.e. 1 for WALKING etc
YData[, 1] <- activities[YData[, 1], 2]

# Appropriately labels the data set with descriptive variable names. 
# update column names
###########################
names(YData) <- "Activity"
names(SubjectData) <- "Subject"

# Merge all the data
CompleteData <- cbind(XData, YData, SubjectData)

# Appropriately labels the data set with descriptive variable names
names(CompleteData)<- gsub("std", "StandardDeviation", names(CompleteData))
names(CompleteData)<- gsub("^t", "time", names(CompleteData))
names(CompleteData)<- gsub("^f", "frequency", names(CompleteData))
names(CompleteData)<- gsub("Acc", "Accelerometer", names(CompleteData))
names(CompleteData)<- gsub("Gyro", "Gyroscope", names(CompleteData))
names(CompleteData)<- gsub("Mag", "Magnitude", names(CompleteData))
names(CompleteData)<- gsub("BodyBody", "Body", names(CompleteData))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###########################

Data2 <- aggregate(. ~ Subject + Activity, CompleteData, mean)
Data2 <- Data2[order(Data2$Subject, Data2$Activity),]
write.table(Data2, file = "./tidydata.txt", row.names = FALSE)