==================================================================
run_analysis.R

Peer Assessment Project: Coursera, Getting and Cleaning Data

David Antelmi
==================================================================

The run_analysis.R script was created as part of the peer assessment project for Coursera  - Getting and Cleaning Data. It uses
raw data recorded on smartphones for study of Human Activity Recognition.


======================================
Purpose of Script
======================================
The script will produce a tidy-data set from the raw data through the following tasks:
 		1. Merges the training and the test sets to create one data set.
 		2. Extracts only the measurements on the mean and standard deviation for each measurement.
		3. Uses descriptive activity names to name the activities in the data set
		4. Appropriately labels the data set with descriptive activity names.
		5. Creates a second, independent tidy data set with the average of each variable for each 
			activity and each subject.
			
			
==================================================================
Running the Script
==================================================================
To run the script, perform the following steps:
	1. Copy the run_analysis.R script to a working directory
	2. Download the project data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
	2. Unzip the contents into the working directory
	3. From RStudio or an R Console, execute the script using : source(run_analysis.R)

Note that the following packages are required to execute the script
	- data.table
	- reshape2
	


======================================
Implementation
======================================
The script implements the data using the following steps

1. Prepare features and labels
The activity labels and feature namesare extracted from the raw files so that
observations and columns names can be fully assigned in the tidy data set.  
A logical vector is prepared marking all features representing mean and standard 
deviation measurements.  This is subsequently used to filter the raw test and training
data.

2. Import Test data
Each test data set is imported into a data frame.  All features are then assigned names and 
activity ids are labelled with the activity name.  The logical feature vector prepared previously
is used to keep only measurements relating to mean and standard deviation.
Finally all test data is combined into a consolidated test data frame.

3. Import Training Data
Each training data set is imported into a data frame.  All features are then assigned names and 
activity ids are labelled with the activity name.  The logical feature vector prepared previously
is used to keep only measurements relating to mean and standard deviation.
Finally all test data is combined into a consolidated training data frame.

4. Merge and reshape test and train data sets
As a result of the previous steps, both Test and Training data frames have a consistent format
and are now combined into a new data frame that contains all rows from each set.  
A reshape (melt) is then applied to produce a data frame with a single value column for each 
group of subject, activity, and measurement type.  

5. Perform calculations 
The dcast function is used to reshape the data back to "wide" format and apply the mean aggregation to
each measurement type (for each subject and activity).

6. Export tidy data
Finally the tidy data is exported to a tab delimited file called tidy_data.txt

 Data is in Tidy format since:
   1. Each variable forms a column (i.e. subject, activity, measurements).
   2. Each observation forms a row (i.e row describes given subject and activity).
   3. Each type of observational unit forms a table (i.e data contains Human activity measures).
   4. All columns contain full row names.


======================================
References
======================================
	- http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
	- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
    - http://vita.had.co.nz/papers/tidy-data.pdf
	- Lecture notes: Coursera  - Getting and Cleaning Data (Data Scientists Toolbox)