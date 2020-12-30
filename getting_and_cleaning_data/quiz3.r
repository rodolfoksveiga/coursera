# set environment ####
pkgs = c('dplyr', 'jpeg')
lapply(pkgs, library, character.only = TRUE)
setwd('~/git/courses/getting_and_cleaning_data/')

# question 1 ####
df1 = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')
index = which(df1$ACR == 3 & df1$AGS == 6)

# question 2 ####
file_url2 = 'https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg'
file_name2 = 'jeff.jpg'
download.file(file_url2, file_name2)
image2 = readJPEG(file_name2, native = TRUE)
quants = quantile(image2, probs = c(0.3, 0.8))

# question 3, 4 and 5 ####
gdp = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv')
educ = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv')
df3 = merge(gdp, educ, by.x = 'X', by.y = 'CountryCode', all = FALSE)
df3$Gross.domestic.product.2012 = as.numeric(df3$Gross.domestic.product.2012)
df3 = arrange(df3, desc(Gross.domestic.product.2012))
df3 = df3[!is.na(df$Gross.domestic.product.2012), ]
country_13th = df[13, 'Long.Name']
df3$Income.Group = factor(df3$Income.Group)
avgs = tapply(df3$Gross.domestic.product.2012, df3$Income.Group, mean)
df3$Cut = cut(df3$Gross.domestic.product.2012, 5)
lmi = table(df3$Cut, df3$Income.Group)[1, 'Lower middle income']
