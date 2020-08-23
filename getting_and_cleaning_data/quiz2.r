# set environment ####
pkgs = c('httpuv', 'httr', 'jsonlite', 'XML')
lapply(pkgs, library, character.only = TRUE)
setwd('~/git/coursera/getting_and_cleaning_data/')

# question 1 ####
doc = read_json('https://api.github.com/users/jtleek/repos')
index = sapply(doc, function(x) x$name == 'datasharing')
doc = doc[[which(index == TRUE)]]
index = grep('create', names(doc))
print(doc[[index]])

# question 4 ####
file_url = 'http://biostat.jhsph.edu/~jleek/contact.html'
file_name = 'contact.html'
download.file(file_url, file_name)
doc = readLines(file_name)
print(sapply(doc[c(10, 20, 30, 100)], nchar))

# question 5 ####
file_url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
file_name = 'wksst8119.for'
download.file(file_url, file_name)
doc = readLines(file_name)
df = read.fwf('https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for',
              widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4), skip = 4)
print(sum(df$V4))
