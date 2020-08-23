# notes ####
# to work with some data set you must have:
# 1. the raw data
# 2. a tidy data set
  # each variable measure should be in one column
  # each different observation should be in one row
  # each 'kind' of variable should be in one table
  # if there are many tables, each table should connect to
    # the other one through a link variable (like in sql)
# 3. a code book
# 4. a step by step (markdown) explaining the steps 1 and 2


# course directory ####
course_directory = '~/git/coursera/getting_and_cleaning_data/'


# 7th class ####
# set environmnet
setwd(course_directory)
# download files from web sites
file_url = 'https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD'
file_name = 'camera.csv'
download.file(file_url, file_name, method = 'curl')
# sometimes it is nice to record the date and time
download_date = date()


# 10th class ####
# set environmnet
library(XML)
setwd(course_directory)

file_url = 'http://www.w3schools.com/xml/simple.xml'
# since the source is a http and not https, it's better
# to download the file first and afterwards open it and
# DO NOT USE method = 'curl'
file_name = 'simple.xml'
download.file(file_url, file_name)
doc = xmlTreeParse(file_name, useInternalNodes = TRUE)
# the xmlRoot() gets the entire xml document, from the
# root node to the bottom
root = xmlRoot(doc)
# xmlName() retrieves the name of the root node
print(xmlName(root))
# the xmlRoot class of object can be treated in some
# ways as a list, as follows
names(root)
print(root[[1]])
print(root[['food']])
print(root[[1]][[1]])
# simple way to get values from a node
print(xmlSApply(root, xmlValue))
# a more complex way to get values from nodes is possible
# through a research, where:
  # /node = top level node
  # //node = node at any level
  # node[@attribute] = node with an attribute name
  # node[@attribute='name'] = node with an specific attribute name
# the following two lines of code retrieves the value of any node
# that corresponds to an element with title name and price,
# respectively, in the entire (root node)
print(xpathSApply(root, '//name', xmlValue))
print(xpathSApply(root, '//price', xmlValue))

file_url = 'http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens'
file_name = 'baltimore_ravens.xml'
download.file(file_url, file_name)
doc = htmlTreeParse(file_name, useInternalNodes = TRUE)
root = xmlRoot(doc)
scores = xpathSApply(root, "//li[@class='sub']", xmlValue)


# 11th class ####
# set environmnet
library(jsonlite)
setwd(course_directory)

# read_json() takes url or file name as main argument and
# import the file as a data frame
# fromJSON() is similar to fromJSON(), but the file is imported as a list
# read_json() or fromJSON should be chosen according to the demand
doc1 = read_json('https://api.github.com/users/jtleek/repos')
doc2 = fromJSON('https://api.github.com/users/jtleek/repos')
print(names(doc))
# toJSON() transforms the a json object into a json 'text file'
doc3 = toJSON(doc2, pretty = TRUE)
cat(doc3)


# 12th class ####
library(data.table)
setwd(course_directory)

# data table in more efficient than base r packages in terms
# of ram memory usage, because it doesn't make table copies
dt = data.table(x = rnorm(9), y = rep(c('a', 'b', 'c'), each = 3), z = rnorm(9))
print(head(dt, 3))
# tables() shows information about all the tables loaded
# in an specific environment
print(tables())
# wile subsetting in data frames with just one coordinate
# subsets the columns, in data table it subsets the rows
print(dt[2, ])
print(dt[2])
print(dt[dt$y == 'a'])
# expressions can be called when subsetting columns
# multiple expressions can be called whithin lists
print(dt[, list(mean(x), sum(z))])
print(dt[, table(y)])
# new columns are added with ':=' sequence of signs
dt[, w := z^2]
dt[, m := {tmp = (x + z); log2(tmp + 5)}]
print(dt)
# careful when assigning other variables to existing tables,
# as well as in python, it changes the original table
dt2 = dt
dt[, y := 2]
print(dt2)
print(dt)
rm(dt2)
# plyr like operations
dt[, a := x > 0]
dt[, b := mean(x + 2), by = a]
print(dt)
# each table can have a key
dt = data.table(x = rep(c('a', 'b', 'c'), each = 100), y = rnorm(300))
setkey(dt, x)
print(tables())
# subsetting with just one coordinate first looks
# at the key variable is equal to the value
print(dt['a'])
# keys also facilitate joining tables, because the merge
# function recognized that the joins will use the key
dt1 = data.table(x = c('a', 'a', 'b', 'dt1'), y = 1:4)
dt2 = data.table(x = c('a', 'b', 'dt2'), z = 5:7)
setkey(dt1, x); setkey(dt2, x)
print(dt1)
print(dt2)
dt = merge(dt1, dt2)
print(dt)
