---
title: "CodeBook.md"
author: "Benjamin Sila"
date: "Wednesday, June 17, 2015"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

## Getting and Cleaning Data Course Project
### Benjamin Sila Mutuku
### 06/15/2015

A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

### Process

The run_analysis.R script performs the following steps to clean the data:

1. Load the library(plyr)
2. Set the working directory to the location that will contain the zipped UCI HAR Dataset
3. Download the file from source to dest folder and unzip (decompress) the zip file to a dest folder
4. Read in the X_train.txt, subject_train.txt, and  Y_train.txt into variables XTrain, YTrain and SubjectTrain
5. Read in the X_test.txt, subject_test.txt, and  Y_test.txt into variables XTest, YTest and SubjectTest
6. Create new data sets using rbind (row bind) of the x, y and subject data's respectively
7. Extracts the measurements on the mean and standard deviation for each measurement.
8. Reads features from *features.txt* and activities from *activity_labels.txt* and store them in "features" and "activities" variables respectively.
9. Subset the columns
10. Set the names of the object
11. Uses descriptive activity names to name the activities in the data set via the activities and YData ariables.
12. Merge all the data
13. Appropriately labels the data set with descriptive variable names e.g. StandardDeviation for std, or Accelerometer for Acc. 
14. From the data set creates a second, independent tidy data set with the average of each variable for each activity and each subject.
15. Write to *tidydata.txt* the results.

### Variables

* activities
* CompleteData
* Data2
* features
* mean_and_standard_deviation_measurement
* SubjectData
* SubjectTest                            
* SubjectTrain
* XData
* XTest
* XTrain
* YData                                  
* YTest
* YTrain

### Description of variables is shown below

````
str(activities) - 'data.frame':	6 obs. of  2 variables:
str(CompleteData) - 'data.frame':	10299 obs. of  68 variables:
str(Data2) - 'data.frame':	180 obs. of  68 variables:
str(features) - 'data.frame':	561 obs. of  2 variables:
 $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
 $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 237 238 239 240 ...
str(mean_and_standard_deviation_measurement) - int [1:66] 1 2 3 4 5 6 41 42 43 44 ...
str(SubjectData) - 'data.frame':	10299 obs. of  1 variable:
str(SubjectTest) - 'data.frame':	2947 obs. of  1 variable:
 $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
str(SubjectTrain) - 'data.frame':	7352 obs. of  1 variable:
 $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
str(XData) - 'data.frame':	10299 obs. of  66 variables:
 $ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...etc.
str(XTest) - 'data.frame':  2947 obs. of  561 variables:
str(YTest) - 'data.frame':  2947 obs. of  1 variable:
````