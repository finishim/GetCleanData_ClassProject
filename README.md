# GetCleanData_ClassProject
## Class Project for Getting and Cleaning Data Course from Coursera

This is the class project for Getting and Cleaning Data course from Coursera.

The data files are loaded in the repository for reference.
The resulting tidy data is also loaded into the repository.
run_analysis.R function is the main function that needs run for generating the result.

## Project Requirements
You should create one R script called run_analysis.R that does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Implementation
1. Look for dataset files. If they do not exist, create a folder, download and unzip them.
2. Merge the training and test sets to create one data set.
    + Read each file.
    + Add column names
    + Merge X (data), y (activity id) and subject (subject id) tables together to form 3 combined tables.
3. Filter the measurements on mean and std for each measurement.
    + Look for "-mean()" or "-std()" in the column names
    + Subset those chosen measurements
    + Finally merge the filtered X table with y and subject tables
4. Grab activity names and replace activity id's with their names.
5. Replace column names with longer more descriptive column names.
6. Create a second tidy data set with the average of each variable for each activity and each subject.
    + Melt the data set and make it a narrow tidy data set.
    + Apply the mean function to this melted data set. It makes it a wider tidy data set.
    + Write the resulting table into a .csv file.

## Tidy Data Description
Here are the assumptions for tidy data:
*The tidy data has no duplicate columns. 
*Each variable is in a single column. 
*Each activity-subject pair has a different row. 
*Column names are easy to read and descriptive.

## Required packages
library(reshape2)
