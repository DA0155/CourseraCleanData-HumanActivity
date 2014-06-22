##
## R Script
##     run_analysis.R 
##
## DESCRIPTION
##		Programming Assignment for Coursera "Getting and Cleaning Data"
## 		1. Merges the training and the test sets to create one data set.
## 		2. Extracts only the measurements on the mean and standard deviation for each measurement.
##		3. Uses descriptive activity names to name the activities in the data set
##		4. Appropriately labels the data set with descriptive activity names.
##		5. Creates a second, independent tidy data set with the average of each variable for each 
##			activity and each subject.
##
## PROGRAMMING NOTES
##		Requires R packages "data.table" and "reshape2"
##
## References
##		http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
##		https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##    http://vita.had.co.nz/papers/tidy-data.pdf
##

# Load packages
require("data.table")
require("reshape2")

#--------------------------------------------------------------------------------
# Prepare features and labels
#--------------------------------------------------------------------------------

# Import activity label names
activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Import data feature (column) names
features = read.table("./UCI HAR Dataset/features.txt")[,2]

# Prepare logical vector indicating occurrence of
# measurements for mean and standard deviation.
# Simply assume that measurement names containing "mean" or "std"
# are the relevant ones.
fltr_features = grepl("mean|std", features)

#--------------------------------------------------------------------------------
# Import Test data
#--------------------------------------------------------------------------------

# Import all test data
X_test = read.table("./UCI HAR Dataset/test/X_test.txt")
y_test = read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt")

# Assign column names to test measurements
names(X_test) = features

# Filter the measurements keeping mean and standard deviation.
X_test = X_test[,fltr_features]

# Add activity labels and column names to each test data set
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Combine test data set by columns into consolidated dataframe
test_data = cbind(as.data.table(subject_test), y_test, X_test)


#--------------------------------------------------------------------------------
# Import Training Data
#--------------------------------------------------------------------------------

# Extract all training data
X_train = read.table("./UCI HAR Dataset/train/X_train.txt")
y_train = read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")

# Assign column names to training measurements
names(X_train) = features

# Filter the measurements keeping mean and standard deviation.
X_train = X_train[,fltr_features]

# Add activity labels and column names to each training data set
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Combine training data set by columns into consolidated dataframe
train_data = cbind(as.data.table(subject_train), y_train, X_train)


#--------------------------------------------------------------------------------
# Merge and reshape test and train data sets
#--------------------------------------------------------------------------------

# Combine test and training data set by rows into consolidated dataframe
tt_data = rbind(test_data, train_data)


# Pivot data to allow subsequent row aggregations over groups 
# see video lecture 
group_cols = c("subject", "Activity_ID", "Activity_Label")
measure_cols = setdiff(colnames(tt_data), group_cols)
pivot_data  = melt(tt_data, id = group_cols, measure.vars = measure_cols)


#--------------------------------------------------------------------------------
# Perform calculations 
#--------------------------------------------------------------------------------

# Apply mean function to dataset using dcast function, grouping 
# over subject and activity
tidy_data = dcast.data.table(pivot_data, subject + Activity_Label ~ variable, mean)


#-----------------------------------------------------------------------------------------
# Export tidy data to file called tidy_data.txt
#
# Data is in Tidy format since:
#   1. Each variable forms a column (i.e. subject, activity, measurements).
#   2. Each observation forms a row (i.e row describes given subject and activity).
#   3. Each type of observational unit forms a table (i.e data contains Human activity measures).
#   4. All columns contain full row names
#-----------------------------------------------------------------------------------------

# Create a tab delimited test file without the row numbering
# To read the file into R, use the following code:
#   read.table("./tidy_data.txt", header=TRUE, sep="\t")
write.table(tidy_data, file = "./tidy_data.txt", sep="\t", row.names = FALSE)