run_analysis <- function() {
    
	
    # Start by downloading the dataset if not already downloaded and unzip it
    
    
    ## create data folder if it does not already exist
    dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if(!file.exists("data")) {
        dir.create("data") 
    }
    
    ## unzip the file
    if(!file.exists(".\\data\\projectfiles\\UCI HAR Dataset")) {
        download.file(dataset_url, destfile = ".\\data\\projectfiles.zip", mode = "wb") 
        unzip(".\\data\\projectfiles.zip", exdir = ".\\data") 
    }
    
    
    # Merge the training and the test sets to create one data set.
    
    
    ## read general files
    features <- read.table(".\\data\\UCI HAR Dataset\\features.txt",header = FALSE)
    activityLabels <- read.table(".\\data\\UCI HAR Dataset\\activity_labels.txt",header = FALSE)
    
    ## read the Test Data
    subjectTest <- read.table(".\\data\\UCI HAR Dataset\\test\\subject_test.txt",header = FALSE)
    xTest <- read.table(".\\data\\UCI HAR Dataset\\test\\X_test.txt",header = FALSE)
    yTest <- read.table(".\\data\\UCI HAR Dataset\\test\\y_test.txt",header = FALSE)
    
    ## add column names
    colnames(subjectTest) <- "subjectId"
    colnames(xTest) <- features[,2] 
    colnames(yTest) <- "activityId"
    
    ## read the Train Data
    subjectTrain <- read.table(".\\data\\UCI HAR Dataset\\train\\subject_train.txt",header = FALSE)
    xTrain <- read.table(".\\data\\UCI HAR Dataset\\train\\X_train.txt",header = FALSE)
    yTrain <- read.table(".\\data\\UCI HAR Dataset\\train\\y_train.txt",header = FALSE)
    
    ## add column names
    colnames(subjectTrain) <- "subjectId"
    colnames(xTrain) <- features[,2] 
    colnames(yTrain) <- "activityId"
    
    ## merge all y tables together
    mergedyData <- rbind(yTest,yTrain)
    
    ## merge all subject tables together
    mergedsubjectData <- rbind(subjectTest,subjectTrain)
    
    ## merge all X tables together
    mergedxData <- rbind(xTest,xTrain)
    
    
    # Extract only the measurements on the mean and standard deviation for each measurement. 
   
    
    ## look for -mean() or -std()
    selectMeasurements <- grep("-(mean|std)\\(\\)", features[, 2])
    
    ## grab the labels
    selectLabels <- features[selectMeasurements,2]
    
    ## subset the chosen measurements
    selectedData <- mergedxData[,selectMeasurements]
    
    ## add the y and subject data columns to the table
    finalData <- cbind(mergedsubjectData, mergedyData, selectedData)
    
    
    # Use descriptive activity names to name the activities in the data set
    
    
    ## replace finalData table's activity id column with activity name
    finalData[,2] <- activityLabels[finalData[,2], 2]
    
    
    # Appropriately label the data set with descriptive variable names. 
    
    
    names(finalData)<-gsub("-", ".", names(finalData))
    names(finalData)<-gsub("subjectId", "SubjectId", names(finalData))
    names(finalData)<-gsub("activityId", "Activity", names(finalData))
    names(finalData)<-gsub("^t", "Time", names(finalData))
    names(finalData)<-gsub("^f", "Frequency", names(finalData))
    names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
    names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
    names(finalData)<-gsub("Mag", "Magnitude", names(finalData))
    names(finalData)<-gsub("BodyBody", "Body", names(finalData))
    names(finalData)<-gsub("std", "StandardDeviation", names(finalData))
    names(finalData)<-gsub("mean", "Mean", names(finalData))
    names(finalData)<-gsub("\\(|\\)", "", names(finalData))
    
    
    # From the data set in step 4, create a second, independent tidy data set
    # with the average of each variable for each activity and each subject.
    
    
    ## melt the data set and make it narrow and tidy
	library(reshape2)
    finalData.melted <- melt(finalData, id = c("SubjectId", "Activity"))
    
    ## cast/summarize the data with the mean function, wide and tidy
    finalData.mean <- dcast(finalData.melted, SubjectId + Activity ~ variable, mean)
    
    ## write the wide tidy table to a txt file
    write.table(finalData.mean, file = ".\\tidydata.txt", row.names = FALSE)

    
}