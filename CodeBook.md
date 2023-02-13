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

### Get Feature labels

The labels (where \# is any number)

-   fBodyAcc-bandsEnergy()-#,#

-   fBodyAccJerk-bandsEnergy()-#,#

-   fBodyGyro-bandsEnergy()-#,#

are each essentially repeated 3 times. This corresponds to X,Y and Z
directions They are therefore manually renamed with X, Y, Z in
features.txt

-   fBodyAcc-bandsEnergy**X**()-#,#

-   fBodyAccJerk-bandsEnergy**X**()-#,#

-   fBodyGyro-bandsEnergy**X**()-#,#

This has been done manually, though it could be done programmatically.
This removes duplicates in a proper scientifically correct manner. To
detect duplicates, use the distinct command (dplyr) on the ‘composite’
data obtained at the end of this script, after disabling any merge
command

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

The features_info.txt file and the fact that the duplicates are repeated
exactly 3 times each gives the clue - X, Y, Z as seen in most other
values.

This is the first step to tidy data - remove duplicate variables
