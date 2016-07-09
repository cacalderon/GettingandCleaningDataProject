Getting and Cleaning Data Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
You will be graded by your peers on a series of yes/no questions related to the project. 
You will be required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. 

This script will perform the following steps on the UCI HAR Dataset downloaded from 
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement. 
- Get activity names to name the activities in the data set
- Create a final tidy data set with the average of each variable for each activity and each subject. 

Steps to reproduce this project

Open the R script run_analysis.r using R and run the script. 

A file will be created at the end called CleanFinalData.txt

