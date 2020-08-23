# set environment ####
pkgs = c('data.table', 'microbenchmark', 'xlsx', 'XML')
lapply(pkgs, library, character.only = TRUE)
setwd('~/git/coursera/getting_and_cleaning_data/')

# questions 1 and 2 ####
file_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
file_name = 'housing_idaho.csv'
download.file(file_url, destfile = file_path, method = 'curl')
df = read.csv(file_name, stringsAsFactors = FALSE)
colnames(df)
sum(df$VAL == 24, na.rm = TRUE)

# questions 2 and 3 ####
# download file
file_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
file_name = 'ngap.csv'
download.file(file_url, file_name, method = 'curl')
df = read.xlsx(file_name, sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
sum(df$Zip*df$Ext, na.rm = TRUE)

# question 4 ####
file_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
file_name = 'baltimore_restaurants.xml'
download.file(file_url, file_name, method = 'curl')
doc = xmlTreeParse(file_name, useInternalNodes = TRUE)
root = xmlRoot(doc)
sum(grepl('21231', xpathSApply(root, '//zipcode', xmlValue)))

# question 5 ####
file_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
file_name = 'us_comunnities'
download.file(file_url, file_name)
dt = fread(file_name)
microbenchmark('1' = sapply(split(dt$pwgtp15, dt$SEX), mean),
               '2' = tapply(dt$pwgtp15, dt$SEX, mean),
               '3' = dt[, mean(pwgtp15), by = SEX],
               '4' = mean(dt$pwgtp15, by = dt$SEX),
               '5' = {dt[dt$SEX == 1, ]$pwgtp15; dt[dt$SEX == 2, ]$pwgtp15})