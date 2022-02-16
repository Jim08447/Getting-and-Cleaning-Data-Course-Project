# Setting working Directory for the analysis and loading relevant packages
setwd("G:/Data Science with R-Coursera/Getting and Cleaning Data")
library(dplyr)
library(tidyr)
library(data.table)

# Downloading and loading the required data in R
dataurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(dataurl, "alldata.zip", mode = "wb")
unzip(zipfile = "alldata.zip")

# Viewing the files
files <- list.files("UCI HAR Dataset", recursive = TRUE)
files
# the files we're interested in are

# test/subject_test.txt
# test/X_test.txt
# test/y_test.txt
# train/subject_train.txt
# train/X_train.txt
# train/y_train.txt
# activity_labels.txt
# features.txt

# Let's read in the Activity and Feature labels
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")
features_label <- read.table("UCI HAR Dataset/features.txt")

# Let's read in the test data set
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x.test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y.test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)


# Let's read in the train data set
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x.train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y.train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)


# Let's combine the individual data sets
datsubject <- rbind(subject.train, subject.test)
datactivity <- rbind(y.train, y.test)
datfeatures <- rbind(x.train, x.test)

# Let's name the columns fo the data set
names(datsubject) <- c("subject")
names(datsubject) <- c("activity")
names(datfeatures)<- features_label$V2

# Now we combine all data set to get full data set
combdata <- cbind(datfeatures, datsubject, datactivity)


# Now we extract the columns with Mean and Std values
subfeatures <- features_label$V2[grep("mean\\(\\)|std\\(\\)", features_label$V2)]
datanames <- c(as.character(subfeatures), "subject", "activity")
finaldata <- subset(combdata, select = subfeatures)
str(finaldata)

# Using the activity labels, we'll give descriptive labels the activities variable
# The variables we'll be labeling are
# prefix tBody is replaced by TimeBody
# Acc is replaced by Accelerometer
# Gyro is replaced by Gyroscope
# prefix fBody is replaced by FrequencyBody
# Mag is replaced by Magnitude
# BodyBody is replaced by Body
# -mean is replaced by Mean
# -std is replaced by Std

names(finaldata) <- gsub("-mean", "Mean", names(finaldata), ignore.case = TRUE)
names(finaldata) <- gsub("-std", "Std", names(finaldata), ignore.case = TRUE)
names(finaldata) <- gsub("tBody", "TimeBody", names(finaldata))
names(finaldata) <- gsub("tGravity", "TimeGrgavity", names(finaldata))
names(finaldata) <- gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata) <- gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata) <- gsub("fBody", "FrequencyBody", names(finaldata))
names(finaldata) <- gsub("Mag", "Magnitude", names(finaldata))
names(finaldata) <- gsub("BodyBody", "Body", names(finaldata))

# We view the final data output
str(finaldata)

# Let's export the file to a tidy new data set
write.table(finaldata, file = "FinalData.txt",row.name=FALSE)


View(finaldata)
