 ##STEPS
 
 #1.Merges the training and the test sets to create one data set.

 #2.Extracts only the measurements on the mean and standard deviation for each measurement. 

 #3.Uses descriptive activity names to name the activities in the data set

 #4.Appropriately labels the data set with descriptive variable names. 

 #5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load Packages unzip and get the Data
install.packages("data.table")
install.packages("reshape2")
library(data.table)
library(reshape2)
mywd <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,file.path(mywd, "MessyData.zip"))
unzip(zipfile="MessyData.zip")


#tidy the data and give name col names
activitylabels <- fread(file.path(mywd, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classlabels", "activities"))
features <- fread(file.path(mywd, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))
featuresIwant <- grep("(mean|std)\\(\\)", features[, featureNames]) #returns  the indices for strings given a regular expession
measurements <- features[features, featureNames]
measurements <- gsub('[()]', '', measurements)  #i am removing the "()" with gsub()


# Load the train datasets
train <- fread(file.path(mywd, "UCI HAR Dataset/train/X_train.txt"))[, featuresIwant, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(file.path(mywd, "UCI HAR Dataset/train/Y_train.txt")
                       , col.names = c("Activity"))
trainSubjects <- fread(file.path(mywd, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("NumberofSubject"))
train <- cbind(trainSubjects, trainActivities, train)

# Load the test datasets (same as train datasets)
test <- fread(file.path(wd, "UCI HAR Dataset/test/X_test.txt"))[, featuresIwant, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(file.path(mywd, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("NumberofSubject"))
test <- cbind(testSubjects, testActivities, test)

# merge the datasets
mergeddatasets <- rbind(train, test)

# Convert classlabels to activities 
mergeddatasets[["Activity"]] <- factor(mergeddatasets[, Activity]
                              , levels = activitylabels[["classlabels"]]
                              , labels = activitylabels[["activities"]])

mergeddatasets[["NumberofSubject"]] <- as.factor(mergeddatasets[, NumberofSubject])
mergeddatasets <- reshape2::melt(data = mergeddatasets, id = c("NumberofSubject", "Activity"))
mergeddatasets <- reshape2::dcast(data = mergeddatasets, NumberofSubject + Activity ~ variable, fun.aggregate = mean)


            





