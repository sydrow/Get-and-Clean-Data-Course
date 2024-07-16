Below the project assignment is code with each step and objective of the code below. it is easier to view by clicking "code" above instead of preview.

The assignment for this project is:
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article 

. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

 

Here are the data for the project:

 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

  

You should create one R script called run_analysis.R that does the following. 

    Merges the training and the test sets to create one data set.

    Extracts only the measurements on the mean and standard deviation for each measurement. 

    Uses descriptive activity names to name the activities in the data set

    Appropriately labels the data set with descriptive variable names. 

    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Below is code with each step and objective of the code below. it is easier to view by clicking "code" above instead of preview.
# Get-and-Clean-Data-Course
CourseEra Module 4
#loading libraries#
library(dplyr)
library(data.table)
library(utils)
#loading file, unzipping#
zip_file <- "/Users/sba6003/Downloads/getdata_projectfiles_UCI HAR Dataset.zip"
unzip(zip_file, exdir = "/Users/sba6003/Downloads")
#Merge prep#
##each of the file from the zip is assigned and read as a table here in preparation for merging##
###test sheets###
x_test <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/test/X_test.txt"), header = FALSE)
y_test <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/test/y_test.txt"), header = FALSE)
subject_test <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/test/subject_test.txt"), header = FALSE)
###train sheets###
x_train <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/train/X_train.txt"), header = FALSE)
y_train <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/train/y_train.txt"), header = FALSE)
subject_train <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/train/subject_train.txt"), header = FALSE)
###features###
features <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/features.txt"), header = FALSE)
###activities###
activity_labels <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/activity_labels.txt"), header = FALSE)
#adding the column names to the datatables I just made ahead of merging#
colnames(x_train) <- features [,2]
colnames(y_train) <- "activityid"
colnames(subject_train) <- "subjectid"
colnames(x_test) <- features [,2]
colnames(y_test) <- "activityid"
colnames(subject_test) <- "subjectid"
colnames(activity_labels) <- c("activityid", "activitytype")
#MERGING#
merge_train <- cbind(y_train, x_train, subject_train)
merge_test <- cbind(y_test, x_test, subject_test)
merge <- rbind(merge_train, merge_test)
colNames = colnames(merge)
#Getting only the means and SDs for each measurment#
mean_and_std = (grepl("activityid", colNames)| grepl("subjectid", colNames)| grepl("mean..", colNames) | grepl("std.." , colNames))
##subset with just these measurements##
mean_and_std_set <- merge [ , mean_and_std == TRUE]
#labeling the dataset#
actnamesset = merge(mean_and_std_set, activity_labels, by = "activityid", all.x = TRUE)
#creating and writing final data set#
finaldata <- aggregate(actnamesset, list(actnamesset$subjectid, actnamesset$activityid), mean)
write.table(finaldata, "finaldata.txt", row.names = FALSE)

