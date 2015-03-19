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
trainData$subjectId <- trainSubjectId

testData <- read.table(testDataDir,header=FALSE,colClasses = c("numeric"),
				stringsAsFactor = FALSE)
names(testData)<- namesOfVars
testData$subjectId <- testSubjectId



## Cleaning up the data
unlink("UCI HAR Dataset",recursive=TRUE)

## Subsetting the data, merging and adding the Activity variable.
tags <- c("-mean()","-std()")
indices_mean <- grepl(tags[1],namesOfVars,fixed=TRUE)
indices_std <- grepl(tags[2],namesOfVars,fixed=TRUE)
indices <- indices_mean+indices_std>0

data <- rbind(trainData[,indices],testData[,indices])
data$Activity <- dataLabels



## Tidying the data
## Renaming activities from numeric lables to descriptive strings
 labelVector <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
	"SITTING", "STANDING", "LAYING")
data$Activity <- sapply(dataLabels, function(x) labelVector[x])


## In renaming the variable names, it is worth noting that there are
## some variable names in this data set that do not seem to correspond
## to the prescribed names in the markdown that accompanies the dataset.
## In particular some variables have accidentally used the substring
## "Body" twice in a row. This happens for the variables whose name,
## according to the markdown, should be one of the following:
## 	1)"fBodyAccJerkMag"
##	2)"fBodyGyroMag"
##	3)"fBodyGyroJerkMag"
## In the provided data set, some variables have these names and others
## have the suspiciously similar names where the substring body appears
## twice and consecutively, e.g. 1)"fBodyBodyAccJerkMag". No such variable
## is described in the markdown, leading me to suspect that it is a typo.

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

## The oldnames could be extracted algorithmically more cleanly perhaps,
## although the newnames would be just as ugly. Also, there is a typo in
## some of the variables were the substring 'Body' is repeated twice,
## unlike any of the variable names in the accompanying markdown file.
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
"fBodyAccJerkMag",  ## Typo in actual variable names. Uses body twice. 15
"fBodyGyroMag",	  ## Typo in actual variable names. Uses body twice. 16
"fBodyGyroJerkMag") ## Typo in actual variable names. Uses body twice. 17

oldnameTypos <- sapply(15:17, function(x) gsub("fBody","fBodyBody",oldnames[x]))

oldnames <- c(oldnames,oldnameTypos)


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


