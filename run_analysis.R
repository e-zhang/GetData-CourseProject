library(dplyr)

# set dataset folder location
dataset_folder_path = "./UCI HAR Dataset"

# read in features list
features <- read.table(paste(dataset_folder_path, "features.txt", sep="/"))
activity_labels <- read.table(paste(dataset_folder_path, "activity_labels.txt", sep="/"))

# read in training data
train <- read.table(paste(dataset_folder_path, "train", "X_train.txt", sep="/"))
# match feature to column in table
names(train) <- features[,2] 

# read in training labels
train_activity <- read.table(paste(dataset_folder_path, "train", "y_train.txt", sep="/"))
# map label id to descriptive name and assign to column
train$activity <- sapply(train_activity[,1], function(x) activity_labels[x,2])
# read in subjects and add a column to dataset
train_subject <- read.table(paste(dataset_folder_path, "train", "subject_train.txt", sep="/"))
train$subjectID <- train_subject[,1]


# create a tbl_df and remove duplicate columns from the data
train_data <- tbl_df(train[!duplicated(names(train))])

# mean and std of data
mean_std_data <- select(train_data, matches("((mean|std)\\()|(activity)|(subjectID)"))

grouped <- group_by(mean_std_data, activity,subjectID)

summary <- summarise_each(grouped, c("mean"), -(activity:subjectID))

write.table(summary, file="tidy_data.txt", row.name=FALSE)


