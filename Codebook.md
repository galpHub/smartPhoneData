Codebook
===========
The dataset contains a data.frame with average window means and average window standard deviation of various smartphone accelerometer measurements separated by subjectId and Activity type. There were 30 subjects and 6 activity types. The latter are given by WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING and LAYING.

The raw measurments were obtained from the url: 
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

Remark: The dataset presented here was obtained by performing a specific set of reproducible computations as per the "run_analysis.R" script on this raw data. It can be summarized as collecting the variables measuring the window means and window standard deviation of the various signals and computing the mean values of these within each combination of subject and activity type.

The variable names were changed from the names in the raw data set in order to provide a more descriptive meaning of the measurements. Note that the FT prefix indicates a fourier transformed signal. The names are given in a prefix-suffix format. The prefixes are

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
"FT_AngularVelocity_JerkMagnitude"

and suffixes are a combination using one of -mean() or -std() and one of -X,-Y, or -Z. The prefix indicates the measured quantity and the suffix indicates two things: 
1. wether we're recording the average window means or the average window stardard deviations
2. The X,Y, or Z component (when the variable is a vector quantity).

For refference, the original variable names are listed bellow in the same order as the corresponding prefixes above.

tBodyAcc-XYZ,
tGravityAcc-XYZ,
tBodyAccJerk-XYZ,
tBodyGyro-XYZ,
tBodyGyroJerk-XYZ,
tBodyAccMag,
tGravityAccMag,
tBodyAccJerkMag,
tBodyGyroMag,
tBodyGyroJerkMag,
fBodyAcc-XYZ,
fBodyAccJerk-XYZ,
fBodyGyro-XYZ,
fBodyAccMag,
fBodyAccJerkMag,
fBodyGyroMag,
fBodyGyroJerkMag

That is to say that where before we would see a variable named tBodyAcc-mean()-X (which records for each window the mean linear acceleration) we would now see the name LinearAcceleration-mean()-X that computes the averages of the tBodyAcc-mean()-X entries. The choice of names comes from "features_info.txt" document accompanying the data set where it is suggested that 'Acc' stands for acceleration 'Gyro' for gyroscopic or 'turning' (thus the choice of the word angular) and 'Mag' for magnitude. The use of the word 'Linear' is used to distinguish this component of the acceleration from the angular component. The prefix FT is short for fourier-transformed.
