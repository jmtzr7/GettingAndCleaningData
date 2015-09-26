
## Check if File exists, Download if not
if(!file.exists("./getdata_projectfiles_UCI HAR Dataset.zip")){
        fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile="./")
}

## Check if data is unzipped, else Unzip the data
if(!file.exists("./UCI HAR Dataset")){
        unzip("./getdata_projectfiles_UCI HAR Dataset.zip", exdir = "./UCI HAR Dataset")
}

## Load Activity Labels
actLabels = read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

## Load feature file
features = read.table("./UCI HAR Dataset/features.txt")[,2]

## Load the training datasets
trainX = read.csv("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
trainY = read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "", col.names = "activity_label")
SubjectTrain = read.csv("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")

## set trainX columns names from features
names(trainX) = features

## extract mean and std deviation
trainX = trainX[,grepl("mean|std", features)]

## add labels
trainY[,2] = actLabels[trainY[,1]]
names(trainY) = c("Activity_ID", "Activity_Label")
names(SubjectTrain) = "subject"

## combine X_train and y_train and subjectTrain
train = cbind(as.data.table(SubjectTrain), trainY, trainX)

## Load the test datasets
testX = read.csv("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
testY = read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
SubjectTest = read.csv("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")

## set trainX columns names from features
names(testX) = features

## extract mean and std deviation
testX = testX[,grepl("mean|std", features)]

## add labels
testY[,2] = actLabels[testY[,1]]
names(testY) = c("Activity_ID", "Activity_Label")
names(SubjectTest) = "subject"

## combine X_test and y_test and subjectTrain
test = cbind(as.data.table(SubjectTest), testY, testX)

## combine training and test data
data = rbind(train,test)

ID = c("subject", "Activity_ID", "Activity_Label")
dataLabels = setdiff(colnames(data), ID)
melt_data = melt(data, id = ID, measure.vars = dataLabels)

## create tidy_data with mean values for each activty and subject
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

## write tidy_data table to txt file
write.table(tidy_data, file = "./tidy_data.txt")