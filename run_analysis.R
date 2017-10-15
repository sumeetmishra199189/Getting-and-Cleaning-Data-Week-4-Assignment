library(dplyr) 
# 1. reading train data and test data and merging them to to create one data set 
X_train <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/train/subject_train.txt") 

X_test <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/test/subject_test.txt") 

X_final <- rbind(X_train, X_test)
y_final <- rbind(y_train, y_test)
subject_final <- rbind(subject_train, subject_test)

#reading features and activity labels
features <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/features.txt") 
activity_labels <- read.table("/Users/sumeetmishra/Desktop/R_Programing/UCI HAR Dataset/activity_labels.txt") 

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
features_final <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_final <- X_final[,features_final[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(y_final) <- "activity"
y_final$activitylabel <- factor(y_final$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_final[,-1]

# 4. Appropriately labels the data set with descriptive variable names
colnames(X_final) <- features[features_final[,1],2] 

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
colnames(subject_final) <- "subject"
final <- cbind(X_final, activitylabel, subject_final)
final_mean <- final %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(final_mean, file = "~/Desktop/R_Programing/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

 