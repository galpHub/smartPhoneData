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
unzip(destFile)


######## Read the file into R
nameData <- "./UCI HAR Dataset/features.txt"
trainDataDir <- "./UCI HAR Dataset/train"
testDataDir <- "./UCI HAR Dataset/test"

## Read names of variables.
name_list <- read.table(nameData,header=FALSE,colClasses=c("numeric","character"),
				stringsAsFactors=FALSE)
names(name_list)<- c("VarNumber","VarName")
namesOfVars <- name_list$VarName