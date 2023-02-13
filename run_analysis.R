## ----setup, include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -------------------------------------------------------------------------------
library(tidyverse)


## -------------------------------------------------------------------------------
## the activities like SITTING etc. are entered as numbers in a file
## For more details look at the CodeBook.md or Codebook.Rmd file
get_feature_labels <- function(filename = "features.txt"){
  features <- read.table(filename)
  feature_labels <- features[,2]
  feature_labels <- gsub("\\(\\)","",feature_labels)
  feature_labels <- gsub("\\(",".between.",feature_labels)
  feature_labels <- gsub("\\)","",feature_labels)
  feature_labels <- gsub("-","_",feature_labels)
  feature_labels <- gsub(",",".and.",feature_labels)
  feature_labels
}


## -------------------------------------------------------------------------------
## Read the activity file for activity descriptions
get_activity_labels <- function(filename="activity_labels.txt"){
  activity_labels <- read.table(filename)
  names(activity_labels)=c("ActID","Activity")
  activity_labels
}


## -------------------------------------------------------------------------------
## Read data from folders test and train. The task is repeated and follows a
## pattern, so it has been put in a function get_folder_data :-
## The function reads X, Y and subject data from these folders
## It also reads features, activity names and returns a dataframe with
## Descriptive activities as factors, subjects and a column to show 
## source of data as test/train, which may help in combined data
## this source Dataset column may be dropped if unnecessary.
get_folder_data <- function(
    name,
    features=feature_labels,
    activities=activity_labels
  ) {
  #Optional - spout warning if name is not test or train
  if ( name !="test" & name != "train"){
    stop(paste("name should be \"test\" or \"train\", not \"",name,"\"", sep=""))
  }
  
  # construct file names - it (i.e. name) is either test or train
  X_file = paste(name,"/X_",name,".txt")
  Y_file = paste(name,"/Y_",name,".txt")
  subject_file = paste(name,"/subject_",name,".txt")
  
  ## Open and read the files
  X <- read.table("test/X_test.txt",sep="", header=FALSE)
  Y <- read.table("test/Y_test.txt",sep="", header=FALSE)
  subject <- read.table("test/subject_test.txt",sep="", header=FALSE)
  
  ## Label them properly
  names(X) <- features
  names(subject)=c("Subject")
  names(Y)=c("ActID")
  ## the activities like SITTING etc. are entered as numbers, so we merge them
  ## "ActId" common variable allows for merging
  
  Y <- merge(Y,activities) # indicates source from test or training set

  X <- mutate(X,Dataset=name) # Duplicate entries cause this command to fail
  
  X <- cbind(X,Activity=Y[,2],stringsAsFactors = TRUE)
  ## Uses descriptive activity names 
  
  X <- cbind(X,Subject=subject) # Merge Y and the subject comprehensive dataset
  ## return X
  X
}


## -------------------------------------------------------------------------------
feature_labels <- get_feature_labels(filename = "features_edited.txt")


## -------------------------------------------------------------------------------
activity_labels <- get_activity_labels(filename="activity_labels.txt")


## -------------------------------------------------------------------------------
test <- get_folder_data("test")
train <- get_folder_data("train")


## -------------------------------------------------------------------------------
composite <- rbind(test,train)


## -------------------------------------------------------------------------------
#names(composite)
write.table(composite,"composite_dataset.tab",sep="\t", row.names=FALSE)


## -------------------------------------------------------------------------------
Var_std <- str_detect(names(composite),'_std') #all standard deviations
Var_mean <- str_detect(names(composite),'_mean') #mean and meanFreq
mean_std <- Var_mean | Var_std
mean_std[562:564] <- TRUE # We need Activity, Subject, Dataset, our extra cols
mean_std_only <- composite[,mean_std]
#names(mean_std_only)
write.table(mean_std_only,"mean_std_dataset.tab",sep="\t", row.names=FALSE)


## -------------------------------------------------------------------------------
activity_subject <- mean_std_only %>% 
  group_by(Subject,Activity) %>%
  summarise(across(where(is.numeric), mean))
#activity_subject
write.table(activity_subject,"activity_subject_dataset.tab",sep="\t", row.names=FALSE)

