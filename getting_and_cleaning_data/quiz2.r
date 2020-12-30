# set environment ####
pkgs = c('httpuv', 'httr', 'jsonlite', 'XML')
lapply(pkgs, library, character.only = TRUE)
setwd('~/git/coursera/getting_and_cleaning_data/')

# question 1 ####
doc1 = read_json('https://api.github.com/users/jtleek/repos')
index = sapply(doc1, function(x) x$name == 'datasharing')
doc1 = doc1[[which(index == TRUE)]]
index = grep('create', names(doc1))
print(doc1[[index]])

# question 4 ####
file_url4 = 'http://biostat.jhsph.edu/~jleek/contact.html'
file_name4 = 'contact.html'
download.file(file_url4, file_name4)
doc4 = readLines(file_name4)
print(sapply(doc4[c(10, 20, 30, 100)], nchar))

# question 5 ####
file_url5 = 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
file_name5 = 'wksst8119.for'
download.file(file_url5, file_name5)
doc5 = readLines(file_name5)
df5 = read.fwf('https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for',
               widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4), skip = 4)
print(sum(df5$V4))
