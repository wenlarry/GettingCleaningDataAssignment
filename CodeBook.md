---
title: "CodeBook.md"
author: "xlarry01x"
date: "August 12, 2016"
output: html_document
---

###** PROJECT DESCRIPTION** 

Human Activity Recognition Using Smartphones Dataset Version 1.0

The experiments involve a group of 30 people aged 19-48 years.Each person performed 6 activities (WALKING,WALKING_UPSTAIRS,WALKING-DOWNSTAIRS,STANDING,
LAYING) while wearing a Samsung Galaxy S II handphone. Using the embedded accelerometer and gyroscope,3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured.

The experiments were documented in 2 datasets (training data and test data).

Acknowledgement
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz

###**RAW DATA**
    
< https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip >.  

####Features of the Raw Data

The features of the Raw Data come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear accelern Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

*Mean value

*Standard deviation

*Others

The complete list of variables of each feature vector is available in 'features.txt' that has 561 observations of 2 variables 

```{r features.txt}```

*Note: Our focus is only on the mean and standard   deviation*


#### Files in the dataset required for processing

* 'features.txt': List of all features.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'train/X_train.txt': Training set.

* 'train/y_train.txt': Training labels.

* 'test/X_test.txt': Test set.

* 'test/y_test.txt': Test labels

* 'subject_train.txt': Training labels

* 'subject_test.txt': Test labels

*Note: These 8 files would be processed into a tidy dataset* 


###**TIDY DATA**

####Creation

* Save Url to working directory

< https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip >.  

* (Saved as an unzipped folder (UCI HAR Dataset)

* From UCI HAR Dataset, extract the 8 raw data files into   the working directory

* Read the raw data files

* Reaname the 8 raw data files from the Import Dataset      function in Rstudio

* Rename as:  (SubjectTrain, SubjectTest, xTrain, xTest,
  ActivityTrain, ActivityTest, labels, features)
  
* Load the following R packages in Rstudio's library
  (dplyr, plyr, WriteXLS)


####Cleaning


#####From the 'features' dataframe extract only the related mean value and standard deviation. Bind them  into one data frame 'featuresbind' for joining at a later stage
  
  eg:
  
  features1 <- slice (features,1:6) 

  ```{r features}```

  
#####Subset 'featuresbind' data frame in eliminating column 2

  eg:
  
  featuresbind2<-featuresbind


#####Concatenate into a test data set as follows:

  * Get files (xTest, SubjectTest, ActivityTest)
  * Provide column names to 'xTest' from 'featuresbind2'
  * Column bind the files into 'testdata'
  * Rename the first 2 columns of 'testdata' as 
    'subjectnr' and 'activitylabel'
    
  eg:
  
  testdata<-cbind(SubjectTest,ActivityTest,xTest
 
 ```{r testdata}```
 
 
#####Concatenate into a train data set as follows:

  * Get files (xTrain, SubjectTrain, ActivityTrain)
  * Provide column names to 'xTrain from 'featuresbind2'
  * Column bind the files into 'traindata'
  * Rename the first 2 columns of 'traindata' as
    'subjectnr' and 'activitylabel'
    
  eg:
  
   traindata,-cbind(SubjectTrain,ActivityTrain,xTrain)

  ```{r traindata}```
 
  
#####Merge the 'traindata' and 'testdata' as they are both 
  now in the same format. Merge into 'consol'.

  eg:
  
  consol<-rbind(traindata,testdata) 
  
  ```{r consol}```
  
  
#####Concatenate 'activitylabel' which is a column in   'consol' with the variables listed in the 'labels' data   set. Convert first 'activitylabel' into a factor then   replace with the new variables.
  
  eg:
 
  consol$activitylabel<-revalue(consol$activitylabel,       c( "1"= "WALKING", "2"="WALKING_UPSTAIRS",
      "3"="WALKING_DOWNSTAIRS","4"="SITTING",
      "5"="STANDING","6"="LAYING") )            
 
  ```{r consol}```
 
 
#####Subset 'consol' with only the mean and std columns

  eg:
 
  consol2<-consol[, 1:68]
 
  ```{r consol2}```

  
#####Provide more descriptive column names for 'consol2'

  eg:
 
  names (consol2<-gsub ("^t","Time",names(consol2)) 
  
  ```{r consol2}```


#####Convert the dataframe (consol2) into a table and rename 'consol2' to 'tidy'
  
  eg:
  
  tidy<-tbl_df(consol2)
  
  ```{r tidy}```
 
  
####Tidy Data - Description


* Dimension: A 'wide' data set of 68 variables (columns)

* Class: 'tbl df', 'tbl' and 'data frame'

* Variables:  read from R 'tidy' data set where the
        variables are more descriptive
        
        eg:
        
        TimeBodyAccMean-X
          (A time measure for body acceleration in 
           direction X) 
         
        summary (tidy) 
 
        ```{r tidy}```
        
  The details of the the various measures for the
  variables are provided above in the RAW DATA 
  section

        
####Tidy Data - Criteria

The 'tidy' data set that can be read from R meet the criteria of a) each variable is in its own column and b) each observation is in its own row


####Tidy Data - Notes

Both the wide and long forms are acceptable as tidy formats. This is advised by 'thoughtful bloke aka as David Hood in the "Getting and Cleaning the Assignment' article.

Reshaping the data from the wide to the long form or vice versa can easily be done through 'tidyr' as follows:

* tidyr:gather()-gather columns into rows

* tidyr-spread()-spread rows into columns



        


