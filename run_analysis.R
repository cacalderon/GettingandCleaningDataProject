library(RCurl)

#Get Data from Website and unzip file in your current working directory

data <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(data, 'UCI-HAR-dataset.zip')
unzip('./UCI-HAR-dataset.zip')

#Merges the data together (tests and training)
xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
xdata <- rbind(xtrain, xtest)

subjecttrain <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subjecttest <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subjectdata <- rbind(subjecttrain, subjecttest)

ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
ydata <- rbind(ytrain, ytest)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresdata <- read.table('./UCI HAR Dataset/features.txt')
mean_std <- grep("-mean\\(\\)|-std\\(\\)", featuresdata[, 2])
xdatamean_std <- xdata[, mean_std]

# Uses descriptive activity names to name the activities in the data set
names(xdatamean_std) <- featuresdata[mean_std, 2]
names(xdatamean_std) <- tolower(names(xdatamean_sd)) 
names(xdatamean_std) <- gsub("\\(|\\)", "", names(xdatamean_std))

activitiesdata <- read.table('./UCI HAR Dataset/activity_labels.txt')
activitiesdata[, 2] <- tolower(as.character(activitiesdata[, 2]))
activitiesdata[, 2] <- gsub("_", "", activitiesdata[, 2])

ydata[, 1] = activitiesdata[y[, 1], 2]
colnames(ydata) <- 'activity'
colnames(subjectdata) <- 'subject'

# Appropriately labels the data set with descriptive activity names. I create the table but something is wrong with my labels
newdata <- cbind(subjectdata, xdatamean_std, ydata)
str(newdata)
write.table(newdata, './datamerged.txt')

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
average_df <- aggregate(x=newdata, by=list(activitiesdata=newdata$activity, subject=newdata$subject), FUN=mean)
average_df <- average_df[, !(colnames(average_df) %in% c("subjectdata", "activitydata"))]
str(average_df)
write.table(newdata, './dataaverage.txt')