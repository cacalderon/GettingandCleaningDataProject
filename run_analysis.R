## Coursera Getting and Cleaning Data Course Project

library(RCurl)

#Get Data from Website and unzip file in your current working directory

data <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(data, 'UCI-HAR-dataset.zip')
unzip('./UCI-HAR-dataset.zip')

# Read the data from the UCI HAR Dataset folder
features     = read.table('./UCI HAR Dataset/features.txt',header=FALSE);
activityType = read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE);
subjectTrain = read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE);
xTrain       = read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE);
yTrain       = read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE);

# Get column names to the imported data
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# Create the training data set by merging yTrain, subjectTrain, and xTrain
MergedTrainingData = cbind(yTrain,subjectTrain,xTrain);

# Read the test data from the UCI HAR Dataset folder
subjectTest = read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE);
xTest       = read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE); 
yTest       = read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE);

# Assign column names to the test data imported above
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";

# Create the test data set by merging the xTest, yTest and subjectTest data
MergedTestingData = cbind(yTest,subjectTest,xTest);

# Merge training and test data for final data set
FinalData = rbind(MergedTrainingData,MergedTestingData);

# Create a vector for the column names from the FinalData, which will be used for mean and stddev info
columnNames  = colnames(FinalData); 

# Calculate mean and standard deviation for each measurement. 
# Create a Vector that contains TRUE values for the ID, mean() & stddev() columns
Vector = (grepl("activity..",columnNames) | grepl("subject..",columnNames) | grepl("-mean..",columnNames) & !grepl("-meanFreq..",columnNames) & !grepl("mean..-",columnNames) | grepl("-std..",columnNames) & !grepl("-std()..-",columnNames));

# Subset FinalData table based on the Vector to keep only desired columns
FinalData = FinalData[Vector==TRUE];

# Use descriptive activity names to name the activities in the data set

# Merge the FinalData set with the acitivityType table to include descriptive activity names
FinalData = merge(FinalData,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
columnNames  = colnames(FinalData); 

# Label the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(columnNames)) 
{
        columnNames[i] = gsub("\\()","",columnNames[i])
        columnNames[i] = gsub("-std$","StdDev",columnNames[i])
        columnNames[i] = gsub("-mean","Mean",columnNames[i])
        columnNames[i] = gsub("^(t)","time",columnNames[i])
        columnNames[i] = gsub("^(f)","freq",columnNames[i])
        columnNames[i] = gsub("([Gg]ravity)","Gravity",columnNames[i])
        columnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columnNames[i])
        columnNames[i] = gsub("[Gg]yro","Gyro",columnNames[i])
        columnNames[i] = gsub("AccMag","AccMagnitude",columnNames[i])
        columnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columnNames[i])
        columnNames[i] = gsub("JerkMag","JerkMagnitude",columnNames[i])
        columnNames[i] = gsub("GyroMag","GyroMagnitude",columnNames[i])
};

# Reassigning the new column names to the FinalData set
colnames(FinalData) = columnNames;

# A new table, finalDataNoActivityType without the activityType column
FinalDataNoActivityType  = FinalData[,names(FinalData) != 'activityType'];

# The finalDataNoActivityType table to include just the mean of each variable for each activity
CleanFinalData    = aggregate(FinalDataNoActivityType[,names(FinalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=FinalDataNoActivityType$activityId,subjectId = FinalDataNoActivityType$subjectId),mean);

# Merging the tidyData with activityType to include descriptive acitvity names
CleanFinalData    = merge(CleanFinalData,activityType,by='activityId',all.x=TRUE);

# Export the tidyData set 
write.table(CleanFinalData, './CleanFinalData.txt',row.names=TRUE,sep='\t')
