# load libraries ####
library(microbenchmark)
library(benchmarkme)
library(profvis)
library(parallel)
library(ggplot2)

####################
# 1. INTRODUCTION

# vignette() displays guides of packages
vignette()
# 1st argument is the package and 2nd is the guide related to the package
vignette(package = 'dplyr', 'dplyr')

# microbenchmark() compare the performance of functions
# the outputs are:
# expr - the expression/function
# min, lq, mean, median, uq, max - the descriptive statistics
# neval - number of evaluations (tests)
df = data.frame(v = 1:4, name = letters[1:4])
microbenchmark(df[3, 2], df[3, "name"], df$name[3], unit = 'us', times = 100)
cs_for = function(x) {
  for (i in x) {
    if (i == 1) {
      xc = x[i]
    } else {
      xc = c(xc, sum(x[1:i]))
    }
  }
  return(xc)
}
cs_apply = function(x) {
  return(sapply(x, function(x) sum(1:x)))
}
microbenchmark(cs_for(1:50000), cs_apply(1:50000), unit = 's', times = 1)

# profvis() compare the performance of large code chuncks
profvis(expr = {
  library(rnoaa)
  library(ggplot2)
  out = readRDS("/home/rodox/Desktop/out-ice.Rds")
  df = dplyr::rbind_all(out, id = "Year")
  ggplot(df, aes(long, lat, group = paste(group, Year))) +
    geom_path(aes(colour = Year)) 
  ggsave("/home/rodox/Desktop/icesheet-test.png")
}, interval = 0.01, prof_output = "ice-prof")

# system.time() also evaluate how long a function takes to be applied
system.time(
  for(i in 1:50000){
    df[3, 2]
  }
)

####################
# 2. EFFICIENT SET-UP
# Sys.info() outputs informations operational system
Sys.info()
R.Version()

# mclapply() e mcmapply() is a parallelized version of lapply() and mapply(), respectively
x = as.data.frame(matrix(rnorm(1e8), nrow = 1e7))
r1 = lapply(x, median)
r2 = parallel::mclapply(x, median) 

# update.packages() updates r packages
# if the argument 'ask' is set as 'F', it'll update all packages whithout asking anything
update.packages(ask = FALSE)

# this snipet checks if there is an Rprofile.site (the main Rprofile file)
site_path = R.home(component = "home")
fname = file.path(site_path, "etc", "Rprofile.site")
file.exists(fname)
# checks if there is a home Rprofile
file.exists("~/.Rprofile")
file.edit("~/.Rprofile")

# adding this function at Rprofile is quite cool
if(interactive()) 
  try(fortunes::fortune(), silent = TRUE)

# ls() has the same function as linux shell ls()