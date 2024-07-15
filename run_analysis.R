library(dplyr)
library(data.table)
library(utils)
#loading file, unzipping#
zip_file <- "/Users/sba6003/Downloads/getdata_projectfiles_UCI HAR Dataset.zip"
unzip(zip_file, exdir = "/Users/sba6003/Downloads")
#Merges the training and the test sets to create one data set#
##assigning##
x_test <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/test/X_test.txt"), header = FALSE)
y_test <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/test/y_test.txt"), header = FALSE)
subject_test <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/test/subject_test.txt"), header = FALSE)
x_train <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/train/X_train.txt"), header = FALSE)
y_train <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/train/y_train.txt"), header = FALSE)
subject_train <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/train/subject_train.txt"), header = FALSE)
features <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/features.txt"), header = FALSE)
activity_labels <- read.table(("/Users/sba6003/Downloads/UCI HAR Dataset/activity_labels.txt"), header = FALSE)
#column names#
colnames(x_train) <- features [,2]
colnames(y_train) <- "activityid"
colnames(subject_train) <- "subjectid"
colnames(x_test) <- features [,2]
colnames(y_test) <- "activityid"
colnames(subject_test) <- "subjectid"
colnames(activity_labels) <- c("activityid", "activitytype")
#merging#
merge_train <- cbind(y_train, x_train, subject_train)
merge_test <- cbind(y_test, x_test, subject_test)
merge <- rbind(merge_train, merge_test)
colNames = colnames(merge)
mean_and_std = (grepl("activityid", colNames)| grepl("subjectid", colNames)| grepl("mean..", colNames) | grepl("std.." , colNames))
mean_and_std_set <- merge [ , mean_and_std == TRUE]
actnamesset = merge(mean_and_std_set, activity_labels, by = "activityid", all.x = TRUE)


meanSD <- grep("-mean\\(\\)|-std\\(\\)", features [, 2])
meanSDtidy <- merge [, meanSD]
colnames(meanSDtidy) <- features[meanSD, 2]
colnames(meanSDtidy) <- gsub("\\(|\\)", "", colnames((meanSDtidy)))
colnames(meanSDtidy) <- gsub("-", ".", colnames((meanSDtidy)))
colnames(meanSDtidy) <- tolower(colnames(meanSDtidy))
actnamesset = merge(mean_and_std_set, activity_labels, by = "activityid", all.x = TRUE)
df <- actnamesset [, 3:dim(actnamesset)[2]]
finaldata <- aggregate(df, list(actnamesset$subjectid, actnamesset$activityid), mean)
names(finaldata)[1] <- "subject"
names(finaldata)[2] <- "activity"
write.table(finaldata, "finaldata.txt", row.names = FALSE)

