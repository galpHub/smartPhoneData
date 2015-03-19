## Creating a tidy directory
library(downloader)

newDirectory <- "./CleanData/Week3/smartPhoneData"
if(!dir.exists(newDirectory)){
	dir.create(newDirectory,recursive=TRUE)
}
setwd(newDirectory)

## Downloading the data file.
destFile <- "smartphone.zip"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(destFile)){
	download(dataUrl,destfile= destFile)
}

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

feature_infoText <-readLines("./UCI HAR Dataset/features_info.txt")
oldnames <- gsub("-XYZ","",feature_infoText[13:29],fixed=TRUE)

trainLabelsDir <- "./UCI HAR Dataset/train/y_train.txt"
testLabelsDir <- "./UCI HAR Dataset/test/y_test.txt"

trainLabels <- read.table(trainLabelsDir,header=FALSE,colClasses=c("numeric"))$V1
testLabels <- read.table(testLabelsDir,header=FALSE,colClasses=c("numeric"))$V1
dataLabels <- c(trainLabels, testLabels)

## Read the numeric identifiers of the subjects
trainSubjectDir<-"./UCI HAR Dataset/train/subject_train.txt"
testSubjectDir <- "./UCI HAR Dataset/test/subject_test.txt"
trainSubjectId <-read.table(trainSubjectDir,colClasses="integer")
testSubjectId <- read.table(testSubjectDir,colClasses="integer")


## Read variables names inro R.
name_list <- read.table(nameData,header=FALSE,colClasses=c("numeric","character"),
				stringsAsFactors=FALSE)
names(name_list)<- c("VarNumber","VarName")
namesOfVars <- name_list$VarName

## Reading the data, adding names and adding subject ids
trainData <- read.table(trainDataDir,header=FALSE,colClasses = c("numeric"),
				stringsAsFactor = FALSE)
names(trainData)<- namesOfVars
trainData$subjectId <- trainSubjectId$V1

testData <- read.table(testDataDir,header=FALSE,colClasses = c("numeric"),
				stringsAsFactor = FALSE)
names(testData)<- namesOfVars
testData$subjectId <- testSubjectId$V1



## Cleaning up the data
unlink("UCI HAR Dataset",recursive=TRUE)

## Subsetting the data, merging and adding the Activity variable.
tags <- c("-mean()","-std()")
indices_mean <- grepl(tags[1],namesOfVars,fixed=TRUE)
indices_std <- grepl(tags[2],namesOfVars,fixed=TRUE)
indices <- indices_mean+indices_std>0

tidydata <- rbind(trainData[,indices],testData[,indices])
tidydata$Activity <- dataLabels



## Tidying the data
## Renaming activities from numeric lables to descriptive strings
 labelVector <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
	"SITTING", "STANDING", "LAYING")
tidydata$Activity <- sapply(dataLabels, function(x) labelVector[x])


## In renaming the variable names, it is worth noting that there are
## some variable names in this data set that do not seem to correspond
## to the prescribed names in the markdown that accompanies the dataset.
## In particular some variables have accidentally used the substring
## "Body" twice in a row. This happens for the variables whose name,
## according to the markdown "features_info.txt", should be one of the following:
## 	1)"fBodyAccJerkMag"
##	2)"fBodyGyroMag"
##	3)"fBodyGyroJerkMag"
## Thse are the last 3 variables listed in the oldnames variable. 
## In the provided data set, some variables have these names and others
## have the suspiciously similar names where the substring body appears
## twice and consecutively, e.g. 1)"fBodyBodyAccJerkMag". No such variable
## is described in the markdown "features_info.txt", leading me to suspect 
## that it is a typo even though it does appear listed in "features.txt".

oldnameTypos <- sapply(15:17, function(x) gsub("fBody","fBodyBody",oldnames[x]))

oldnames <- c(oldnames,oldnameTypos)

## The newnames vector is going to contain the new variable names that
## will be more descriptive of the measurements. The names are listed in
## the same order as the entries of oldnames that will be replaced.
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

newnameFixTypo <- newnames[15:17]

newnames <- c(newnames,newnameFixTypo)


## Note that we need to order them by decreasing length so that variable 
## names which are substrings of other names dont get overwritten 
## the wrong way.
reorderNames <- order(nchar(oldnames),oldnames,decreasing=TRUE)
oldnames<-oldnames[reorderNames]
newnames<-newnames[reorderNames]

## Rename the variables in nameOfVars 
for(j in 1:length(oldnames)){
	namesOfVars <- gsub(oldnames[j],newnames[j],namesOfVars,fixed= TRUE)
}


## Check that the renaming of the relevant variables was successful

wrong_nameIndex <- namesOfVars[indices]==name_list[indices,]$VarName
number_ofErrors <- sum(wrong_nameIndex)
if(number_ofErrors>0){
	print("Names were not all correctly changed")
}else{
	print("All names were correctly changed!")
}

names(tidydata)[1:66]<-namesOfVars[indices]



## New tidy table. This table contains the mean for each variable in the tidy
## data set, within each combination of subject-by-activity. Consequently,
## the columns of the matrix resulting from the following code
tidySplit <- split(tidydata[,1:66],list(tidydata$subjectId,tidydata$Activity))
tidytable <- sapply(tidySplit,colMeans)
## have column names in the format of subjectId.Activity where subjectId is an
## integer and Activity is a character string indicating the activity (e.g. "WALKING")

