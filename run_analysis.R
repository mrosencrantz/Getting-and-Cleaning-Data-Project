library(plyr)

#1. Merge the training and the test sets to create one data set.

#test set
test_data <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_labels <- read.table('./UCI HAR Dataset/test/y_test.txt')
test_subjects <- read.table('./UCI HAR Dataset/test/subject_test.txt')

#training set
train_data <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_labels <- read.table('./UCI HAR Dataset/train/y_train.txt')
train_subjects <- read.table('./UCI HAR Dataset/train/subject_train.txt')


#merged sets
all_data <- rbind(test_data, train_data)
all_labels <- rbind(test_labels, train_labels)
all_subjects <- rbind(test_subjects, train_subjects)


#2. Extracts only the measurements on the mean and standard deviation for each measurement. 

#load the features file so we can see search for the columns we want.
features <- read.table('./UCI HAR Dataset/features.txt')
colidx <- grep("std\\(\\)|mean\\(\\)", features[, 2])
all_data <- all_data[, colidx]
names(all_data) <- features[colidx, 2]

#3. Uses descriptive activity names to name the activities in the data set

activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- activity_names[all_labels[, 1], 2]
all_labels[, 1] <- activity_labels
names(all_labels) <- "activity"
names(all_subjects) <- "subject"

#4. Appropriately labels the data set with descriptive variable names. 
final_data <- cbind(all_subjects, all_labels, all_data)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
indy_tidy_data <- ddply(final_data, .(subject, activity), function(x) colMeans(x[, 3:68]))
write.table(indy_tidy_data, "indy_tidy_data.txt", row.name=FALSE)
