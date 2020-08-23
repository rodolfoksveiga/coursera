# course directory ####
course_directory = '~/git/coursera/getting_and_cleaning_data/'


# 1st class ####
# set environment
library(RMySQL)
setwd(course_directory)

db = dbConnect(MySQL(), user = 'genome',
               host = 'genome-mysql.cse.ucsc.edu')
cmd = 'SHOW DATABASES'
query = dbGetQuery(db, cmd)
print(query)
dbDisconnect(db)

db = dbConnect(MySQL(), user = 'genome', db = 'hg19',
               host = 'genome-mysql.cse.ucsc.edu')
tbl_names = dbListTables(db)
# fields corresponds to data frame columns
dbListFields(db, 'affyU133Plus2')
cmd = 'SELECT COUNT(*) AS NumberOfRecords FROM affyU133Plus2'
query = dbGetQuery(db, cmd)
print(query)
# dbReadTable() reads the full table
# often times it will be impossible to stock all the data frame
# into r global environment, due to limited ram
df = dbReadTable(db, 'affyU133Plus2')
# dbgetQuery() can read parts of the data frame
cmd = 'SELECT * FROM affyU133Plus2 WHERE misMatches BETWEEN 1 AND 3'
df = dbGetQuery(db, cmd)
# an alternative to dbGetQuery() is dbSendQuery() combined
# with fetch() this way it's possible to send multiple
# commands before fetching the query
query = dbSendQuery(db, cmd)
df = fetch(query, n = 20)
# fetch() doesn't conclude the query, just pull in the results
# dbClearResult() finishes the query
dbClearResult(query)
dbDisconnect(db)


# 2nd class ####
# set environment
library(rhdf5)
setwd(course_directory)

db = h5createFile('example.h5')
db = h5createGroup('example.h5', 'foo')
db = h5createGroup('example.h5', 'baa')
db = h5createGroup('example.h5', 'foo/baa')
# list groups into h5 file
h5ls('example.h5')
mtx = matrix(1:10, nrow = 5, ncol = 2)
h5write(mtx, 'example.h5', 'foo/mtx1')
ary = array(seq(0.1, 2, by = 0.1), dim = c(5, 2, 2))
attr(ary, 'scale') = 'liter'
h5write(ary, 'example.h5', 'foo/baa/ary1')
h5ls('example.h5')
df = data.frame(1:5, seq(0, 1, length.out = 5),
                c('ab', 'cde', 'fghi', 'a', 's'),
                stringsAsFactors = FALSE)
h5write(df, 'example.h5', 'df1')
h5ls('example.h5')
mtx1 = h5read('example.h5', 'foo/mtx1')
ary1 = h5read('example.h5', 'foo/baa/ary1')
df1 = h5read('example.h5', 'df1')
# h5write() can overwrite values in specific cells
h5write(c(12, 13, 14), 'example.h5', 'foo/mtx1',
        index = list(1:3, 1))
h5read('example.h5', 'foo/mtx1')


# 3rd class ####
# set environment
library(XML)
library(httr)
setwd(course_directory)

file_url = 'http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en'
file_name = 'leek_citations.xml'
download.file(file_url, file_name)
doc = htmlTreeParse(file_name, useInternalNodes = TRUE)
xpathSApply(doc, '//title', xmlValue)
# it's also possible to download directly to r environment
# download html page
page = GET(file_url)
# extract the content from html page
page = content(page, as = 'text')
# parse out the text
doc = htmlParse(page, asText = TRUE)
xpathSApply(doc, '//title', xmlValue)
# it's possible to access pages with password thorugh httr package
# httr allows GET, POST, PUT, DELETE requests if you authorized
# most apis use something like oauth to authenticate
page = GET('http://httpbin.org/basic-auth/user/passwd',
          authenticate('user', 'passwd'))
# it's also possible to access the web site and navigate through
file_handle = GET('http://google.com')
page1 = GET(handle = file_handle, path = '/')
page2 = GET(handle = file_handle, path = 'search')


# extra class ####
app = oauth_app('github',
                key = '6b96d99f854e600e9231',
                secret = '8f23b991b83947d89210aa798f34fbdaf56f3af6')
token = oauth2.0_token(oauth_endpoints('github'), app)
token = config(token = token)
page = GET('https://api.github.com/users/jtleek/repos', token)
stop_for_status(page)
json = content(page, type = 'json')