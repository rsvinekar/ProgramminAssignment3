# Initial setup

This part involves sourcing the libraries, and writing essential
functions

## Sourcing the libraries needed

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0      ✔ purrr   1.0.1 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.3.0      ✔ stringr 1.5.0 
    ## ✔ readr   2.1.3      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

This loads the `tidyverse` packages which include `dplyr, readr` etc.

## Essential Functions

### Feature labels

The labels (where \# is any number) are found in features.txt. The
features in features.txt require some cleaning, as a step towards tidy
data

#### Removing Duplicates

Running our program for the first time, using steps described later,
causes the `mutate` command to fail due to duplicate variable entries.
We need to find these duplicate entries. The `distinct` command does
just that. The code was running disabling any `mutate` call and the
`distinct` command was run on the resultant `composite` dataframe which
combines test and train data:

``` r
> distinct(composite, .keep_all = TRUE)
Error:
   ! Column names `fBodyAccJerk_bandsEnergy_1.and.8`, `fBodyAccJerk_bandsEnergy_9.and.16`, `fBodyAccJerk_bandsEnergy_17.and.24`, `fBodyAccJerk_bandsEnergy_25.and.32`, `fBodyAccJerk_bandsEnergy_33.and.40`, and 50 more must not be duplicated.
 Use .name_repair to specify repair.
 Caused by error in `repaired_names()`:
   ! Names must be unique.
 ✖ These names are duplicated:
 * "fBodyAccJerk_bandsEnergy_1.and.8" at locations 382, 396, and 410.
 * "fBodyAccJerk_bandsEnergy_9.and.16" at locations 383, 397, and 411.
 * "fBodyAccJerk_bandsEnergy_17.and.24" at locations 384, 398, and 412.
 * "fBodyAccJerk_bandsEnergy_25.and.32" at locations 385, 399, and 413.
 * "fBodyAccJerk_bandsEnergy_33.and.40" at locations 386, 400, and 414.
 * ...
```

As we can see, the problem is with these variables:-

    fBodyAcc-bandsEnergy()-#,# 
    fBodyAccJerk-bandsEnergy()-#,# 
    fBodyGyro-bandsEnergy()-#,# 

They are each essentially repeated 3 times. The readme in
`features_info.txt` says:

> The features selected for this database come from the accelerometer
> and gyroscope 3-axial raw signals `tAcc-XYZ` and `tGyro-XYZ`. These
> time domain signals (prefix ‘t’ to denote time) were captured at a
> constant rate of 50 Hz. Then they were filtered using a median filter
> and a 3rd order low pass Butterworth filter with a corner frequency of
> 20 Hz to remove noise. Similarly, the acceleration signal was then
> separated into body and gravity acceleration signals (`tBodyAcc-XYZ`
> and `tGravityAcc-XYZ`) using another low pass Butterworth filter with
> a corner frequency of 0.3 Hz.
>
> Subsequently, the body linear acceleration and angular velocity were
> derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and
> tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional
> signals were calculated using the Euclidean norm
> (`tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag`).
>
> Finally a Fast Fourier Transform (FFT) was applied to some of these
> signals producing
> `fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag`.
> (Note the ‘f’ to indicate frequency domain signals).
>
> These signals were used to estimate variables of the feature vector
> for each pattern:
>
> ‘-XYZ’ is used to denote 3-axial signals in the X, Y and Z directions.

It is a reasonable assumption that these three values in order are X, Y
and Z values. Thus the features.txt has been edited to make the
following changes manually: - An X has been added. For second and third
value, Y and Z are added.

    fBodyAcc-bandsEnergyX()-#,# 
    fBodyAccJerk-bandsEnergyX()-#,# 
    fBodyGyro-bandsEnergyX()-#,# 

This has been done manually, though it could be done programmatically.
This removes duplicates in a proper scientifically correct manner
(assumption - of course). This gets rid of any errors with the `mutate`
program

The features_info.txt file and the fact that the duplicates are repeated
exactly 3 times each gives the clue - X, Y, Z as seen in most other
values.

The edited file is saved as `features_edited.txt`

#### Clean variables

Remove symbols and spaces in variable names and make them meaningful.
Some characters in variable names are allowed, but not recommended as
they may interfere with and cause trouble in later code. They need to be
replaced. There is very little scope of making the variables smaller
than they are. However, problem characters can be replaced in a
meaningful manner. This can be done in code.

-   remove ‘-’ replace with underscore ‘\_’ (‘-’ is not recommended)
    brackets are replaced in meaningful manner.

-   ‘()’ is removed,

-   ‘(’ is used for angle “between” two quantities, so .between.

-   ‘)’ is removed.

-   ‘,’ is used for “and”, thus .and.

This makes the variable names readable. This can be put info a function
to read the feature labels

### feature labels function - get_feature_labels(filename)

``` r
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
```

### Activity labels

The activities status like SITTING etc. are entered as numbers in a
file. The raw data has these numbers (1 to 6) which map to description
of the activity in the activity_labels.txt file.

    1 WALKING
    2 WALKING_UPSTAIRS
    3 WALKING_DOWNSTAIRS
    4 SITTING
    5 STANDING
    6 LAYING

These are needed as we need a description of the activity in our final
dataset, not numbers. We will write a simple function to read the same

#### Activity labels function get_activity_labels(filename)

``` r
## Read the activity file for activity descriptions
get_activity_labels <- function(filename="activity_labels.txt"){
  activity_labels <- read.table(filename)
  names(activity_labels)=c("ActID","Activity")
  activity_labels
}
```

Here, an `ActID` variable name is given which will later be used to map
the numbers in this variable with the description of activity in
`Activity`

### Reading test and train data

The test and train data are present in the test and train directories.
The format of these directories is consistent, and filenames merely have
test replaced by train in these directories. A single function can thus
be used to read the datasets. The `Inertial Signals` subdirectory is of
no concern to us currently. There are three main files which need to be
read:

-   X values: these have 561 variables readings which correspond to the
    variable names obtained from the features_labels. The values are all
    numeric

-   Y values: these are values corresponding to activities. They are
    integers between 1 to 6 corresponding to activity_labels

-   subject values: this is a number corresponding to the person who
    submitted the data. There are around 24 individuals. The names of
    these persons are unknown and of no concern currently.

The function to be written must

1.  Read in X values to a dataframe

2.  Read in Y values to a dataframe

3.  merge Y values with activity_labels to get descriptions

4.  Combine X data with the descriptions obtained for Y values, and
    store them as factors rather than strings

5.  Combine subject data with the X dataframe

6.  Add a column to indicate the source of the data - test or train.
    This column is not requested and may be dropped if not needed.

``` r
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
```

### Reading Feature variables

A simple call to above function can read the feature labels.

``` r
feature_labels <- get_feature_labels(filename = "features_edited.txt")
```

``` r
activity_labels <- get_activity_labels(filename="activity_labels.txt")
```

Now we have invoked the `get_activity_labels()` function to read the
text file to an R dataframe `activity_labels`.

Now read the test and train data into dataframes

``` r
test <- get_folder_data("test")
train <- get_folder_data("train")
```

Finally combine the data into one dataset.

``` r
composite <- rbind(test,train)
```

This thus satisfies 3 out of 5 aims requested. The rest can be done on
the `composite` dataset. At the end, the data needs to be written out as
a `.csv` file for point 1, 4 and 5.

1.  Merges the training and the test sets to create one data set. -
    **Done**

    ``` r
    #names(composite)
    write.table(composite,"composite_dataset.tab",sep="\t", row.names=FALSE)
    ```

2.  Extracts only the measurements on the mean and standard deviation
    for each measurement.

    ``` r
    Var_std <- str_detect(names(composite),'_std') #all standard deviations
    Var_mean <- str_detect(names(composite),'_mean') #mean and meanFreq
    mean_std <- Var_mean | Var_std
    mean_std[562:564] <- TRUE # We need Activity, Subject, Dataset, our extra cols
    mean_std_only <- composite[,mean_std]
    #names(mean_std_only)
    write.table(mean_std_only,"mean_std_dataset.tab",sep="\t", row.names=FALSE)
    ```

3.  Uses descriptive activity names to name the activities in the data
    set - **Done**

4.  Appropriately labels the data set with descriptive variable names. -
    **Done**

5.  From the data set in step 4, creates a second, independent tidy data
    set with the average of each variable for each activity and each
    subject.

    ``` r
    activity_subject <- mean_std_only %>% 
      group_by(Subject,Activity) %>%
      summarise(across(where(is.numeric), mean))
    ```

        ## `summarise()` has grouped output by 'Subject'. You can override using the
        ## `.groups` argument.

    ``` r
    #activity_subject
    write.table(activity_subject,"activity_subject_dataset.tab",sep="\t", row.names=FALSE)
    ```

``` r
by_subject <- mean_std_only %>% 
  group_by(Subject) %>%
  summarise(across(where(is.numeric), mean))
#activity_subject
write.table(by_subject,"by_subject_dataset.tab",sep="\t", row.names=FALSE)
```

``` r
by_activity <- mean_std_only %>% 
  group_by(Activity) %>%
  summarise(across(where(is.numeric), mean))
#activity_subject
write.table(by_activity,"by_activity_dataset.tab",sep="\t", row.names=FALSE)
```
