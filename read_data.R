library(tidyverse)
## Get Feature labels
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
names(activity_labels)=c("ActID","Activity")
feature_labels <- paste(features[,1],features[,2]) 
## get it as a character vector, and clean labels
feature_labels <- gsub("\\(\\)",".func.",feature_labels)
feature_labels <- gsub("\\(",".bet.",feature_labels)
feature_labels <- gsub("\\)",".ok.",feature_labels)
feature_labels <- gsub("-","_",feature_labels)
feature_labels <- gsub(",",".and.",feature_labels)
######Test########
get_folder_data <- function(name="test") {
  ## construct file names
  X_file = paste(name,"/X_",name,".txt")
  Y_file = paste(name,"/Y_",name,".txt")
  subject_file = paste(name,"/subject_",name,".txt")
  
  ## Open and read the files
  X <- read.table("test/X_test.txt",sep="", header=FALSE)
  Y <- read.table("test/Y_test.txt",sep="", header=FALSE)
  subj <- read.table("test/subject_test.txt",sep="", header=FALSE)
  
  ## Label them properly
  names(X) <- feature_labels
  names(subj)=c("Subject")
  names(Y)=c("ActID")
  ## the activities like SITTING etc. are entered as numbers, so we merge them 
  Y <- merge(Y,activity_labels)
  
  ## so we know which data are from test or training set
  X <- mutate(X,Dataset=name) 
  
  ## Merge Y and the subject to make comprehensive dataset
  
  X <- cbind(X,Activity=Y[,2],stringsAsFactors = TRUE)
  X <- cbind(X,Subject=subj)
  ## return X
  X
}

test <- get_folder_data("test")
train <- get_folder_data("train")
composite <- rbind(test,train)
