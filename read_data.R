library(tidyverse)
## has dplyr, readr and others
source("functions.R")

## Get Feature labels
# The labels (where # is any number)
# fBodyAcc-bandsEnergy()-#,#
# fBodyAccJerk-bandsEnergy()-#,#
# fBodyGyro-bandsEnergy()-#,#
# are each essentially repeated 3 times. This corresponds to X,Y and Z directions
# They are therefore manually renamed with X, Y, Z in features.txt
# fBodyAcc-bandsEnergyX()-#,#
# fBodyAccJerk-bandsEnergyX()-#,#
# fBodyGyro-bandsEnergyX()-#,#
# This has been done manually, though it could be done programmatically.
# This removes duplicates in a proper scientifically correct manner.
# To detect duplicates, use the distinct command (dplyr) on the 'composite' data 
# obtained at the end of this script, after disabling any merge command

## > distinct(composite, .keep_all = TRUE)
## Error:
##   ! Column names `fBodyAccJerk_bandsEnergy_1.and.8`, `fBodyAccJerk_bandsEnergy_9.and.16`, `fBodyAccJerk_bandsEnergy_17.and.24`, `fBodyAccJerk_bandsEnergy_25.and.32`, `fBodyAccJerk_bandsEnergy_33.and.40`, and 50 more must not be duplicated.
## Use .name_repair to specify repair.
## Caused by error in `repaired_names()`:
##   ! Names must be unique.
## ✖ These names are duplicated:
## * "fBodyAccJerk_bandsEnergy_1.and.8" at locations 382, 396, and 410.
## * "fBodyAccJerk_bandsEnergy_9.and.16" at locations 383, 397, and 411.
## * "fBodyAccJerk_bandsEnergy_17.and.24" at locations 384, 398, and 412.
## * "fBodyAccJerk_bandsEnergy_25.and.32" at locations 385, 399, and 413.
## * "fBodyAccJerk_bandsEnergy_33.and.40" at locations 386, 400, and 414.
## * ...
# The features_info.txt file and the fact that the duplicates are repeated 
# exactly 3 times each gives the clue - X, Y, Z as seen in most other values.

## This is the first step to tidy data - remove duplicate variables

## get it as a character vector, and clean labels
feature_labels <- get_feature_labels(filename = "features_edited.txt")

## Second step to tidy data : remove symbols and spaces in variable names and 
## make them meaningful - This is done in the function
## * remove '-' replace with underscore '_' ('-' is not recommended) 
## brackets are replaced in meaningful manner. 
## * '()' is removed, 
## * '(' is used for angle "between" two quantities, so .between. 
## * ')' is removed.
## * ',' is used for "and", thus .and.
## This makes the variable names readable


## the activities like SITTING etc. are entered as numbers in a file
activity_labels <- get_activity_labels(filename="activity_labels.txt")

## Read data from folders test and train. The task is repeated and follows a
## pattern, so it has been put in a function get_folder_data :-
## The function reads X, Y and subject data from these folders
## It also reads features, activity names and returns a dataframe with
## Descriptive activities as factors, subjects and a column to show 
## source of data as test/train, which may help in combined data
## this source Dataset column may be dropped if unnecessary.

test <- get_folder_data("test")
train <- get_folder_data("train")
# Combine test and training sets to give a composite

composite <- rbind(test,train)
groupings <- composite %>% 
             group_by(Subject, Activity) %>% 
             summarise(across(where(is.numeric), mean))
