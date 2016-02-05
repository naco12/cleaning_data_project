#Once the file has been loaded in your current directory, read each of the following files using read.table

xtest <-  read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
ytest <-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
subjecttest <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
subjecttrain <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
activitylabels <-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
  
#For question 1 merging the test and train data 
	#Merging test data
df1 <- data.frame(id=c(1:2947),xtest)
df2 <- data.frame(id=c(1:2947),ytest)
df3 <- data.frame(id=c(1:2947),subjecttest)
names(df2) <- c("id","actx")
names(df3) <- c("id","subx")

library(plyr)
dfx <- join(df1,df2)
dfxt <- join(dfx,df3)

	#Merging train data
df1train <- data.frame(id=c(1:7352),xtrain)
df2train <- data.frame(id=c(1:7352),ytrain)
df3train <- data.frame(id=c(1:7352),subjecttrain)
names(df2train) <- c("id","acty")
names(df3train) <- c("id","suby")
dfy <-join(df1train,df2train)
dfyt <- join(dfy,df3train)

 #making sure the data frames have the same name and mergin test and train data
names(dfyt) <- names(dfxt)

data <- rbind.data.frame(dfxt,dfyt)
#looking for mean in features:
la <- grep("mean\\(\\)", features$V2)

#looking for std in features:
lb <- grep("std\\(\\)", features$V2)

#removing the first column from data
data1 <- data[,2:564]

#Subtracting the mean and std variables from the data set:
  
datameanstd <- data1[,c(la,lb,562,563)]

#using descriptive activity name to name the activities in the data set
#replacing activity code by descriptive names:

library(plyr)
library(dplyr)

#replacing the activities code column by the activities descriptive name in the data set:
column <-mapvalues(datameanstd$actx, from=c(1,2,3,4,5,6), to=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING") )
datameanstd$actx <- column

#Labels the dataset with descriptive variable names:
#Subsetting V2(names to allocated) from the feature data:
sub_feature <- features$V2


#transforming featmeanstd to a one row multiple column vector:
tfeatmeanstd <- t(sub_feature)

#substracting the relevant name to be allocated:
namesdata <- tfeatmeanstd[,c(la,lb)]

#use lapply to convert the class of tfeatmeanstd from factor class to a character class:
charac <-lapply(namesdata,as.character)
charac <-rapply(charac,as.character)

#assigning name to the data frame datameanstd:
namesvect <-names(datameanstd) <- c(charac,"actx","subx")

#changing variable:
datastidy <- datameanstd


#loading the dplyr package:
library(dplyr)

#Using the piping command %>% to group datastidy4 by subject and activities, summarize the result and calculate the mean of the summarize column.
datastidy4 <- datastidy %>% group_by(subx,actx) %>% summarize_each(funs(mean))

#renaming datastidy4 variable:
b <- gsub("\\(\\)-","",names(datastydy4))
names(datastidy4) <- b

#changing the data name denomination:
stydidata <- datastidy4



