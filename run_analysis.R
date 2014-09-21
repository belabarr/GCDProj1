# Script     : run_analysis.R
# Application: GCD Project
# author      : Bel Abarrientos 
# Date written: 21 September 2014
# Changes (Date, Author, Description, )
#

## Get Data 
setwd("D:/$Study/DataScience/GCD")
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl1,destfile="./data/getdata-projectfiles-UCI HAR Dataset.zip")
# Manually unzip file for now, will include in the script if time permits

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

## Merge data
# Merge required data for test dataset (adding a "test" data factor and activity type from Y_test)
length(X_test)
X_test[,"subject"] = "1"
length(X_test)
X_test <- cbind(X_test, Y_test)

# Merge required data for training dataset (adding a "test" data factor and activity type from Y_test)
length(X_train)
X_train[,"subject"] = "2"
length(X_train)
X_train <- cbind(X_train, Y_train)

# Merge Test and Train datasets into 1
Merge_data = rbind(X_test, X_train)
head(Merge_data,2)


## Provide variables names 
featuresdf$colnm <- as.character(featuresdf$V2)
featuresdf[562,3] <- c("Subject")
featuresdf[563,3] <- c("ActivityNumber")
colnames(Merge_data) <- c(featuresdf[,3])

## Extract required data mean and standard deviation only
grep("mean()",featuresdf$V2)
grep("std()",featuresdf$V2)

Extract_df <- cbind(Merge_data[,1:6],     Merge_data[,41:46],   Merge_data[,81:86], 
                    Merge_data[,121:126], Merge_data[,161:166], Merge_data[,201:202], 
                    Merge_data[,214:215], Merge_data[,227:228], Merge_data[,240:241], 
                    Merge_data[,253:254], Merge_data[,266:271], Merge_data[,345:350], 
                    Merge_data[,424:429], Merge_data[,503:504], Merge_data[,516:517], 
                    Merge_data[,529:530], Merge_data[,542:543], Merge_data[,562:563])

## Use descriptive Names for activities
Extract_df$ActivityType <- factor(Extract_df$ActivityNumber) 
actLabels$colnm <- as.character(actLabels$V2)
levels(Extract_df$ActivityType) <- c(actLabels[1,3], actLabels[2,3],
                                  actLabels[3,3], actLabels[4,3], 
                                  actLabels[5,3], actLabels[6,3])

# remove parentheses and reword mean and std
colnamestx <- colnames(Extract_df)
ncolnames <- length(Extract_df)
for (i in 1:ncolnames) {
    colnamestx[i] <- gsub("\\(", "", colnamestx[i])
    colnamestx[i] <- gsub("\\)", "", colnamestx[i])
    colnamestx[i] <- gsub("mean", "Mean", colnamestx[i])
    colnamestx[i] <- gsub("std", "StDev", colnamestx[i])
}
colnames(Extract_df) <- c(colnamestx[1:ncolnames])
# remove activity number column
Extract_df$ActivityNumber <- NULL

## create tidy dataset
require(plyr) 
TidyExt <- ddply(Extract_df, .(Subject,ActivityType), numcolwise(mean))
setwd("D:/$Study/DataScience/GCD/UCI HAR Dataset")
write.table(TidyExt, file="GCDProjectTidy.txt", row.name=FALSE)
