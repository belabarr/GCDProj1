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
Here is start of the run_analysis script
Download file and manually unzip

```r
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl1,destfile="./data/getdata-projectfiles-UCI HAR Dataset.zip",method="curl")
# Manually unzip file for now, will include in the script if time permits

```

Get data into R data frames
```r
setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset")
actLabels <- read.table("activity_labels.txt", header=F)
head(actLabels,2)

featuresdf <- read.table("features.txt", header=FALSE)
head(featuresdf,2)

```
> head(actLabels,2)
  V1               V2
1  1          WALKING
2  2 WALKING_UPSTAIRS

> head(featuresdf,2)
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
> setwd("D:/$Study/Data
```

```r
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
Merge required data for test dataset (adding a "test" data factor and activity type from Y_test)

```r
length(X_test)
X_test[,"subject"] = "1"
length(X_test)
X_test <- cbind(X_test, Y_test)

length(X_train)
X_train[,"subject"] = "2"
length(X_train)
X_train <- cbind(X_train, Y_train)
```

Merge Test and Train datasets into 1
```r
Merge_data = rbind(X_test, X_train)
head(Merge_data,2)

```

> head(Merge_data,2)
         V1          V2          V3         V4         V5         V6         V7         V8         V9
1 0.2571778 -0.02328523 -0.01465376 -0.9384040 -0.9200908 -0.6676833 -0.9525011 -0.9252487 -0.6743022
2 0.2860267 -0.01316336 -0.11908252 -0.9754147 -0.9674579 -0.9449582 -0.9867988 -0.9684013 -0.9458234
         V10        V11        V12       V13       V14       V15        V16        V17        V18
1 -0.8940875 -0.5545772 -0.4662230 0.7172085 0.6355024 0.7894967 -0.8777642 -0.9977661 -0.9984138
2 -0.8940875 -0.5545772 -0.8060133 0.7680313 0.6836980 0.7967058 -0.9690965 -0.9995795 -0.9996456
 ...
         V552       V553       V554         V555       V556       V557      V558       V559      V560
1  0.07164545 -0.3303704 -0.7059739  0.006462403 0.16291982 -0.8258856 0.2711515 -0.7200093 0.2768010
2 -0.40118872 -0.1218451 -0.5949439 -0.083494968 0.01749957 -0.4343746 0.9205932 -0.6980908 0.2813429
         V561 subject ActNum
1 -0.05797830       1      5
2 -0.08389801       1      5

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

```
> grep("mean()",featuresdf$V2)
 [1]   1   2   3  41  42  43  81  82  83 121 122 123 161 162 163 201 214 227 240 253 266 267 268 294 295 296
[27] 345 346 347 373 374 375 424 425 426 452 453 454 503 513 516 526 529 539 542 552
> grep("std()",featuresdf$V2)
 [1]   4   5   6  44  45  46  84  85  86 124 125 126 164 165 166 202 215 228 241 254 269 270 271 348 349 350
[27] 427 428 429 504 517 530 543
```

```r
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

remove parentheses and reword mean and std and rename data frame column names
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
head(Extract_df,2)

```

```
> head(Extract_df,2)
  tBodyAcc-Mean-X tBodyAcc-Mean-Y tBodyAcc-Mean-Z tBodyAcc-StDev-X tBodyAcc-StDev-Y tBodyAcc-StDev-Z
1       0.2571778     -0.02328523     -0.01465376       -0.9384040       -0.9200908       -0.6676833
2       0.2860267     -0.01316336     -0.11908252       -0.9754147       -0.9674579       -0.9449582
  tGravityAcc-Mean-X tGravityAcc-Mean-Y tGravityAcc-Mean-Z tGravityAcc-StDev-X tGravityAcc-StDev-Y
1          0.9364893         -0.2827192          0.1152882          -0.9254273          -0.9370141
2          0.9274036         -0.2892151          0.1525683          -0.9890571          -0.9838872
    ...     
  fBodyBodyGyroMag-Mean fBodyBodyGyroMag-StDev fBodyBodyGyroJerkMag-Mean fBodyBodyGyroJerkMag-StDev Subject
1            -0.7706100             -0.7971128                -0.8901655                 -0.9073076       1
2            -0.9244608             -0.9167741                -0.9519774                 -0.9382124       1
  ActivityType
1     STANDING
2     STANDING

```

remove activity number column
```r
Extract_df$ActivityNumber <- NULL
```

## create tidy dataset
```r
require(plyr) 
TidyExt <- ddply(Extract_df, .(Subject,ActivityType), numcolwise(mean))
head(TidyExt,2)

setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset")
write.table(TidyExt, file="GCDProjectTidy.txt", row.name=FALSE)

```
> head(TidyExt,2)
  Subject     ActivityType tBodyAcc-Mean-X tBodyAcc-Mean-Y tBodyAcc-Mean-Z tBodyAcc-StDev-X tBodyAcc-StDev-Y
1       1          WALKING       0.2765264     -0.01825071      -0.1088758       -0.3195959      -0.03176763
2       1 WALKING_UPSTAIRS       0.2631264     -0.02427446      -0.1207985       -0.2765296      -0.05176382
  tBodyAcc-StDev-Z tGravityAcc-Mean-X tGravityAcc-Mean-Y tGravityAcc-Mean-Z tGravityAcc-StDev-X
1       -0.3422446          0.9391306         -0.1897810        -0.02643848          -0.9778665
2       -0.2553801          0.8809839         -0.2687596        -0.12366969          -0.9523994
```