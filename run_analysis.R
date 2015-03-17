library(downloader)

newDirectory <- "./CleanData/Week3/smartPhoneData"
if(!dir.exists(newDirectory)){
	dir.create(newDirectory,recursive=TRUE)
}
setwd(newDirectory)


destFile <- "smartphone.zip"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download(dataUrl,destfile= destFile)
dateDownloaded <- Sys.time()


## Part1: Reading and merging

## Read the file into R
unzip(destFile)
nameData <- "./UCI HAR Dataset/features.txt"
trainDataDir <- "./UCI HAR Dataset/train/X_train.txt"
testDataDir <- "./UCI HAR Dataset/test/X_test.txt"

## Read the "labels" of the data.
# Remark: The labels only indicate the kind of activity under
# which the measurement was taken, e.g. walking or running, and
# is recorded as the integers 1 through 6 according to the markdown
# accompanying the data file.
trainLabelsDir <- "./UCI HAR Dataset/train/y_train.txt"
testLabelsDir <- "./UCI HAR Dataset/test/y_test.txt"

trainLabels <- read.table(trainLabelsDir,header=FALSE,colClasses=c("numeric"))$V1
testLabels <- read.table(testLabelsDir,header=FALSE,colClasses=c("numeric"))$V1
dataLabels <- rbind(trainLabels, testLabels)


## Read names of variables.
name_list <- read.table(nameData,header=FALSE,colClasses=c("numeric","character"),
				stringsAsFactors=FALSE)
names(name_list)<- c("VarNumber","VarName")
namesOfVars <- name_list$VarName

## Reading the data
trainData <- read.table(trainDataDir,header=FALSE,colClasses = c("numeric"),
				stringsAsFactor = FALSE)
names(trainData)<- namesOfVars

testData <- read.table(testDataDir,header=FALSE,colClasses = c("numeric"),
				stringsAsFactor = FALSE)
names(testData)<- namesOfVars

## Cleaning up the data
unlink("UCI HAR Dataset",recursive=TRUE)

## Subsetting the data, merging and adding the Activity variable.
tags <- c("-mean()","-std()")
indices_mean <- grepl(tags[1],namesOfVars,fixed=TRUE)
indices_std <- grepl(tags[2],namesOfVars,fixed=TRUE)
indices <- indices_mean+indices_std>0

data <- rbind(trainData[,indices],testData[,indices])
data$Activity <- dataLabels

## Showing data who's boss! (i.e. Tidying)

 labelVector <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
	"SITTING", "STANDING", "LAYING")
## labelVector is to be used as follows (to improve readability):
#data$label <- sapply(dataLabels, function(x) labelVector[x])

newnames<-c(
"LinearAcceleration",
"GravityAcceleration",
"LinearJerk",
"AngularVelocity",
"AngularJerk",
"LinearAcceleration_Magnitude",
"Gravity_AccelerationMagnitude",
"Linear_JerkMagnitude",
"AngularVelocity_Magnitude",
"AngularVelocity_JerkMagnitude",
"FT_LinearAcceleration",
"FT_LinearJerk",
"FT_AngularVelocity",
"FT_LinearAcceleration_Magnitude",
"FT_Linear_JerkMagnitude",
"FT_AngularVelocity_Magnitude",
"FT_AngularVelocity_JerkMagnitude")



## The oldnames could be extracted algorithmically more cleanly perhaps,
## although the newnames would be just as ugly.
oldnames<-c(
"tBodyAcc",
"tGravityAcc",
"tBodyAccJerk",
"tBodyGyro",
"tBodyGyroJerk",
"tBodyAccMag",
"tGravityAccMag",
"tBodyAccJerkMag",
"tBodyGyroMag",
"tBodyGyroJerkMag",
"fBodyAcc",
"fBodyAccJerk",
"fBodyGyro",
"fBodyAccMag",
"fBodyAccJerkMag",
"fBodyGyroMag",
"fBodyGyroJerkMag")



## Note that we need to order them by length so that variable 
## names which are substrings dont get overwritten the wrong way.
## Also there is a typo in some of the variable names - the word
## body is repeated twice.
reorderNames <- order(nchar(oldnames),oldnames,decreasing=TRUE)
oldnames<-oldnames[reorderNames]
newnames<-newnames[reorderNames]


for(j in 1:length(oldnames)){
	namesOfVars <- gsub(oldnames[j],newnames[j],namesOfVars,fixed= TRUE)
}



