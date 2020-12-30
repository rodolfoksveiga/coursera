# setup environment
library(reshape2)
library(stringr)
setwd('./getting_and_cleaning_data/')

# variables
file_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
zip_file = 'final_project_data.zip'
data_dir = 'UCI HAR Dataset/'
train_files = paste0(data_dir, 'train/', c('X_train', 'y_train', 'subject_train'), '.txt')
feat_file = paste0(data_dir, 'features.txt')
act_file = paste0(data_dir, 'activity_labels.txt')
test_files = str_replace_all(train_files, 'train', 'test')
# download data
download.file(file_url, zip_file, method = 'curl')
# unzip downloaded data
unzip(zip_file)

# read data
train = lapply(train_files, read.table)
test = lapply(test_files, read.table)
feat = read.table(feat_file, stringsAsFactors = FALSE)
act = read.table(act_file, stringsAsFactors = FALSE)

# merge data
data = mapply(rbind, train, test)
names(data) = c('x', 'y', 'subject')

# extract measurements ('mean' and 'std')
index = str_which(feat[, 2], 'mean|std')
feat = feat[index, 2]

# sort out data according to the subjects
data$x = data$x[index]
data = cbind(data$y, data$subject, data$x)

# name activities and label dataset
colnames(data) = c('activity', 'subject', feat)
data$activity = factor(data$activity, levels = act[, 1], labels = act[, 2])
data$subject = as.factor(data$subject)

# tidy data set
data = melt(data, id = c('subject', 'activity'))
data = dcast(data, subject + activity ~ variable, mean)

# write data
write.table(data, 'tidy_dataset.txt', row.names = FALSE, quote = FALSE)
