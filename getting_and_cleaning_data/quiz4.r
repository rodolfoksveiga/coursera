# set environment ####
pkgs = c('dplyr', 'lubridate', 'quantmod', 'stringr')
lapply(pkgs, library, character.only = TRUE)
setwd('~/git/courses/getting_and_cleaning_data/')

# question 1 ####
df1 = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')
splitted = str_split(colnames(df1), 'wgtp')[[123]]

# question 2 and 3 ####
df2 = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv')
avg_gdp = df2 %>%
  slice(5:219) %>%
  pull(X.3) %>%
  str_remove_all('\\D') %>%
  as.numeric() %>%
  mean(na.rm = TRUE)
uniteds = df2 %>%
  pull(X.2) %>%
  str_detect('^United') %>%
  sum()

# question 4 ####
gdp = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv')
educ = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv')
df4 = merge(gdp, educ, by.x = 'X', by.y = 'CountryCode', all = FALSE)
df4 = df4[5:219, ]
end_june = df4 %>%
  pull(Special.Notes) %>%
  str_detect('^Fiscal year end: June') %>%
  sum()

# question 5 ####
amzn = getSymbols("AMZN",auto.assign=FALSE)
sample_times = index(amzn)
sum_2012 = sum(year(sample_times) == 2012)
sum_mondays = sum(year(sample_times) == 2012 & wday(sample_times) == 2)
