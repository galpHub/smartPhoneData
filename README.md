## Using the run_analysis.R script to reproduce the results.

The script is written with the intention that the code contained in the script
should be executed as is line by line in order to obtain the same results. This
can be accomplished by copying the script and pasting it in the command prompt.

## To read the table produced by this result.

Simply excecute the commands:

setwd("Dir_containing_TidyTable")

testTable<-read.table("tidyTable.txt",header=TRUE,colClasses=c("numeric"))

Reading it in this way will "rename" the columns as paste("X",VarName, sep="") but avoids
any other unnecessary hassle.