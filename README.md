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

