
## Load Packages 
#
## Open Url
#
#(https://d396qusza40orc.cloudfront.net/getdata%2Fprojectf#iles%2FUCI%20HAR%20Dataset.zip)
# 
##Save Url to working directory 
# (Saved as an unzipped folder (UCI HAR Dataset)
#
# From UCI HAR Dataset, Extract the following into the
# working directory
# subject_train.txt, subject_test.txt,
# X_train.txt, X-test.txt, Y_train.txt, Y_test.txt,
# activity_labels.txt and features.txt 
# 
# 
## Read the files
#
# From Rstudio, import the 8 datasets/files
# (Use function "Import Dataset From Local File")  
#
## Rename the 8datasets from the Import Dataset
## function in RStudio
#
# Rename as: SubjectTrain, SubjectTest,  xTrain, xTest,
#       ActivityTrain,  ActivityTest, labels, and features
#       
#
# Success - the 8 datasets are in Rstudio
#       'Global Environment'
#
## Load R Packages in library of RStudio
#
#  dplyr, plyr, WriteXLS
# (This script shall use functions from these R packages)
#
#
##Work on features dataframe
#
# extract only the related mean
# value and standard deviation
# bind into one dataframe 'featuresbind' to
# join at a later stage

features1<-slice(features,1:6) 

features2<-slice(features, 41:46) 

features3<-slice(features,81:86) 

features4<-slice( features,121:126) 

features5<-slice(features, 161:166) 

features6<-slice(features, 201:202)

features7<-slice(features, 214:215)

features8<-slice(features, 227:228)

features9<-slice(features,240:241)

features10<-slice(features, 253:254)

features11<-slice(features, 266:271) 

features12<-slice(features, 345:350)

features13<-slice(features, 424:429) 

features14<-slice(features,503:504) 

features15<-slice(features, 516:517) 

features16<-slice(features, 529:530) 

features17<-slice(features, 542:543) 


featuresbind<-bind_rows(features1,features2,features3,
                        features4,features5,features6,
                        features7,features8,features9,
                        features10,features11,features12,
                        features13,features14,features15,
                        features16,features17) 

## subset featuresbind  dataframe

featuresbind2<-featuresbind  [,2] 

## subset labels dataframe
labels<-labels[,2] 

## Concatenate into a test data set
#
# Get files (xTest, SubjectTest, ActivityTest)
# Provide column names to xTest from
# featuresbind2
# Column bind the files into 'testdata'
# Rename the first 2 columns of 'testdata'
# as 'subjectnr' and 'activitylabel'

colnames(xTest     ) <- featuresbind2

testdata<-cbind(SubjectTest      , ActivityTest,xTest) 

colnames(testdata)[1]<-'subjectnr'

colnames(testdata)[2]<- 'activitylabel'


## Concatenate into a train data set
# Get files (xTrain, SubjectTrain, ActivityTrain)
# Provide column names to xTrain from
# featuresbind2
# Column bind the files into 'traindata'
# Rename the first 2 columns of 'traindata'
# as 'subjectnr' and 'activitylabel'

colnames(xTrain   ) <-featuresbind2

traindata<-cbind(SubjectTrain      ,ActivityTrain ,xTrain ) 

colnames(traindata)[1]<- 'subjectnr'

colnames(traindata)[2]<-'activitylabel' 

## Merge traindata and testdata
# Both are now in the same format

consol<- rbind(traindata, testdata)

## Concatenate 'activitylabel'which is a column
## in 'consol' with the variables listed in
## the 'labels' data set
#
# Convert first 'activitylabel into a factor
# then replace with the new variables

consol$activitylabel<-as.factor(consol$activitylabel) 

consol$activitylabel <- revalue  (
        consol$activitylabel,
        c(
                "1" = "WALKING",
                "2" = "WALKING_UPSTAIRS",
                "3" = "WALKING_DOWNSTAIRS",
                "4" = "SITTING",
                "5" = "STANDING",
                "6" = "LAYING"
        )
)

## Subset 'consol' with only the mean and
#  std columns. 563 variables reduced to 68
#  variables

consol2<-consol[,1:68]

## Provide more descriptive variables 

names(consol2) <-gsub("-mean\\(\\)","Mean",names(consol2) )
names(consol2) <-gsub("-std\\(\\)","Standard_Deviation", 
                      names(consol2)) 
names(consol2)<-gsub("^t","Time",names(consol2)) 
names(consol2)<-gsub("^f","Frequency",names(consol2))

## Create a tidy data set
# 
#  Convert 'consol2' which is a data frame to a table
#  Change 'consol2' to 'tidy' 

tidy<-tbl_df(consol2) 

write.table(tidy,"tidy.txt",sep="\t",row.names=FALSE) 

## Alternative Method to create a tidy data set 
#  directly into an Excel Worksheet

WriteXLS ("consol2","tidy.xls")


