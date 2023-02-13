## Read the activity file for activity descriptions
get_activity_labels <- function(filename="activity_labels.txt"){
  activity_labels <- read.table(filename)
  names(activity_labels)=c("ActID","Activity")
  activity_labels
}

## Read the features file for variable names and clean the variables
get_feature_labels <- function(filename = "features.txt"){
  features <- read.table("features.txt")
  feature_labels <- features[,2]
  ## get it as a character vector, and clean labels
  ## Second step to tidy data : remove symbols and spaces in variable names and 
  ## make them meaningful
  ## * remove '-' replace with underscore '_' ('-' is not recommended) 
  ## brackets are replaced in meaningful manner. 
  ## * '()' is removed, 
  ## * '(' is used for angle "between" two quantities, so .between. 
  ## * ')' is removed.
  ## * ',' is used for "and", thus .and.
  ## This makes the variable names readable
  
  feature_labels <- gsub("\\(\\)","",feature_labels)
  feature_labels <- gsub("\\(",".between.",feature_labels)
  feature_labels <- gsub("\\)","",feature_labels)
  feature_labels <- gsub("-","_",feature_labels)
  feature_labels <- gsub(",",".and.",feature_labels)
  feature_labels
}
## Read files from the required test or train folder
get_folder_data <- function(
    name,
    features=feature_labels,
    activities=activity_labels
  ) {
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
  ## Uses descriptive activity names to name the activities in the data set
  ## The descriptions are in activity_labels, and are stored as factors 
  ## rather than strings
  
  X <- cbind(X,Subject=subject) # Merge Y and the subject comprehensive dataset

  ## return X
  X
}