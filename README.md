---
Application : GCD Project
Script      : run_analysis.R
author      : Bel Abarrientos 
job         : Johns Hopkins Bloomberg School of Public Health
Date        : 21 September 2014
Version     : 1.0
---

## Getting and Cleaning Data Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 


[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]([http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]) 

Here is  the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

---

## run_analysis script objectives 

An accompanying R Script "run_analysis.R"" was created to accomplish the following:
- Get Data and transform some of the data
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---

## Get Data 
# Here is start of the run_analysis script
# Download file and manually unzip

```r
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl1,destfile="./data/getdata-projectfiles-UCI HAR Dataset.zip",method="curl")
# Manually unzip file for now, will include in the script if time permits

```

# Get data into R data frames
```r
setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset")
actLabels <- read.table("activity_labels.txt", header=F)
head(actLabels,2)

featuresdf <- read.table("features.txt", header=FALSE)
head(featuresdf,2)

setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset/test")
X_test <- read.table("X_test.txt", header=F)
Y_test <- read.table("y_test.txt", header=F)
colnames(Y_test) <- c("ActNum")

setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset/train")
X_train <- read.table("X_train.txt", header=F)
Y_train <- read.table("y_train.txt", header=F)
colnames(Y_train) <- c("ActNum")
```

## Merge data
# Merge required data for test dataset (adding a "test" data factor and activity type from Y_test)

```r
length(X_test)
X_test[,"subject"] = "1"
length(X_test)
X_test <- cbind(X_test, Y_test)

# Merge required data for training dataset (adding a "test" data factor and activity type from Y_test)
length(X_train)
X_train[,"subject"] = "2"
length(X_train)
X_train <- cbind(X_train, Y_train)
```

# Merge Test and Train datasets into 1
```r
Merge_data = rbind(X_test, X_train)
head(Merge_data,2)
```

## Provide variables names 
```r
featuresdf$colnm <- as.character(featuresdf$V2)
featuresdf[562,3] <- c("Subject")
featuresdf[563,3] <- c("ActivityNumber")
colnames(Merge_data) <- c(featuresdf[,3])
```

## Extract required data mean and standard deviation only
```r
grep("mean()",featuresdf$V2)
grep("std()",featuresdf$V2)

Extract_df <- cbind(Merge_data[,1:6],     Merge_data[,41:46],   Merge_data[,81:86], 
                    Merge_data[,121:126], Merge_data[,161:166], Merge_data[,201:202], 
                    Merge_data[,214:215], Merge_data[,227:228], Merge_data[,240:241], 
                    Merge_data[,253:254], Merge_data[,266:271], Merge_data[,345:350], 
                    Merge_data[,424:429], Merge_data[,503:504], Merge_data[,516:517], 
                    Merge_data[,529:530], Merge_data[,542:543], Merge_data[,562:563])
```

## Use descriptive Names for activities
```r
Extract_df$ActivityType <- factor(Extract_df$ActivityNumber) 
actLabels$colnm <- as.character(actLabels$V2)
levels(Extract_df$ActivityType) <- c(actLabels[1,3], actLabels[2,3],
                                  actLabels[3,3], actLabels[4,3], 
                                  actLabels[5,3], actLabels[6,3])
```
# remove parentheses and reword mean and std and rename data frame column names
```r
colnamestx <- colnames(Extract_df)
ncolnames <- length(Extract_df)
for (i in 1:ncolnames) {
    colnamestx[i] <- gsub("\\(", "", colnamestx[i])
    colnamestx[i] <- gsub("\\)", "", colnamestx[i])
    colnamestx[i] <- gsub("mean", "Mean", colnamestx[i])
    colnamestx[i] <- gsub("std", "StDev", colnamestx[i])
}
colnames(Extract_df) <- c(colnamestx[1:ncolnames])
```
# remove activity number column
```r
Extract_df$ActivityNumber <- NULL
```

## create tidy dataset
```r
require(plyr) 
TidyExt <- ddply(Extract_df, .(Subject,ActivityType), numcolwise(mean))
setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset")
write.table(TidyExt, file="GCDProjectTidy.txt", row.name=FALSE)
```