# Programming Assignment 3 Coursera 

This repository contains the data from [getdata projectfiles UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
On top of this raw data, there is the requirements



>You should create one R script called run_analysis.R that does the following. 
>
>1. Merges the training and the test sets to create one data set.
>1. Extracts only the measurements on the mean and standard deviation for each measurement. 
>1. Uses descriptive activity names to name the activities in the data set
>1. Appropriately labels the data set with descriptive variable names. 
>1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

* CodeBook.md to be provided 

The code has been written on Rstudio using the CodeBook.Rmd file. 
This file is converted to CodeBook.md and the R script run_analysis.R using purl()
The datasets are text files with extension (.tab)
- The composite dataset of point 1 above is called composite_dataset.tab
- The dataset with means and standard deviations is mean_std_dataset.tab
- The dataset with average values for each activity and subject is activity_subject_dataset.tab
- For datasets with Subject alone by_subject_dataset.tab
- For dataset with Activity alone by_activity_dataset.tab


