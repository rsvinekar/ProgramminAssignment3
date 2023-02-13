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

* CodeBook.md to be provided. Please look at (CodeBook.md) for more details

The code has been written on Rstudio using the CodeBook.Rmd file. 
This file is converted to CodeBook.md and the R script run_analysis.R using purl()
The datasets are text files with extension (.tab)
- The composite dataset of point 1 above is called composite_dataset.tab
- The dataset with means and standard deviations is mean_std_dataset.tab
- The dataset with average values for each activity and subject is activity_subject_dataset.tab
- For datasets with Subject alone by_subject_dataset.tab
- For dataset with Activity alone by_activity_dataset.tab

The run_analysis.R file is used to run the analysis. There are three functions
get_feature_labels(filename)
get_activity_labels(filename)
get_folder_data(dataset)  ## dataset = "test" or "train"

These functions are called to read required data from the files and tidy the data as required
The get_folder_data function knits the data together to provide a comprehensive "test" or "train" dataset, which is then combined outside
Steps are taken to tidy the dataset after reading the data
Details are provided in CodeBook.md

The best way to run the code is in RStudio, using the CodeBook.Rmd file. However since this is not asked, the Codebook.md and run_analysis.R files are generated from this file.
Other R files were temporary (read_data.R and functions.R ). They are left as is, and are mostly functional (read_data.R works partly like run_analysis.R, but has functions in functions.R)

