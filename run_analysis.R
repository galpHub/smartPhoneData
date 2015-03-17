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

## Subsetting the data and merging
tags <- c("-mean()","-std()")
indices_mean <- grepl(tags[1],namesOfVars,fixed=TRUE)
indices_std <- grepl(tags[1],namesOfVars,fixed=TRUE)
indices <- indices_mean+indices_std>0

data <- merge(trainData[indices,],testData[indices,])




