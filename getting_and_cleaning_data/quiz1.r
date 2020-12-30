# set environment ####
pkgs = c('data.table', 'microbenchmark', 'xlsx', 'XML')
lapply(pkgs, library, character.only = TRUE)
setwd('~/git/coursera/getting_and_cleaning_data/')

# questions 1 and 2 ####
file_url1 = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
file_name1 = 'housing_idaho.csv'
download.file(file_url1, file_path1, method = 'curl')
df1 = read.csv(file_name1, stringsAsFactors = FALSE)
colnames(df1)
sum(df1$VAL == 24, na.rm = TRUE)

# questions 2 and 3 ####
# download file
file_url2 = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
file_name2 = 'ngap.csv'
download.file(file_url2, file_name2, method = 'curl')
df2 = read.xlsx(file_name2, sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
sum(df2$Zip*df2$Ext, na.rm = TRUE)

# question 4 ####
file_url3 = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
file_name3 = 'baltimore_restaurants.xml'
download.file(file_url3, file_name3, method = 'curl')
doc3 = xmlTreeParse(file_name3, useInternalNodes = TRUE)
root3 = xmlRoot(doc3)
sum(grepl('21231', xpathSApply(root3, '//zipcode', xmlValue)))

# question 5 ####
file_url4 = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
file_name4 = 'us_comunnities'
download.file(file_url4, file_name4)
dt4 = fread(file_name4)
microbenchmark('1' = sapply(split(dt4$pwgtp15, dt4$SEX), mean),
               '2' = tapply(dt4$pwgtp15, dt$SEX, mean),
               '3' = dt4[, mean(pwgtp15), by = SEX],
               '4' = mean(dt4$pwgtp15, by = dt4$SEX),
               '5' = {dt4[dt4$SEX == 1, ]$pwgtp15; dt4[dt4$SEX == 2, ]$pwgtp15})