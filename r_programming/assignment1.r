pollutantmean = function(directory, pollutant, id = 1:332) {
  file_paths = dir(directory, full.names = TRUE)[id]
  dfs = lapply(file_paths, read.csv)
  vec = do.call(rbind, dfs)[[pollutant]]
  return(mean(vec, na.rm = TRUE))
}

complete = function(directory, id = 1:332) {
  file_paths = dir(directory, full.names = TRUE)[id]
  dfs = lapply(file_paths, read.csv)
  nobs = sapply(dfs, function(x) sum(!is.na(x$sulfate)))
  nobs = data.frame(id = id, nobs = nobs)
  return(nobs)
}

corr = function(directory, threshold = 0) {
  file_paths = dir(directory, full.names = TRUE)
  dfs = lapply(file_paths, read.csv)
  cases = sapply(dfs, function(x) sum(!is.na(x$sulfate)) > threshold)
  dfs = dfs[cases]
  cr = sapply(dfs, function(x) cor(x$sulfate, x$nitrate, use = 'na.or.complete'))
  cr = as.numeric(cr[!is.na(cr)])
  return(cr)
}