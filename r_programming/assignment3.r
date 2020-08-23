best = function(state, outcome) {
  df = read.csv('outcome-of-care-measures.csv', stringsAsFactors = FALSE)
  outcome = strsplit(outcome, ' ')
  capitalize = function(string) {
    substr(string, 1, 1) = toupper(substr(string, 1, 1))
    return(string)
  }
  outcome = sapply(outcome, capitalize)
  outcome = paste(outcome, collapse = '.')
  prefix = 'Hospital.30.Day.Death..Mortality..Rates.from.'
  outcome = paste0(prefix, outcome)
  if (!state %in% df$State) {
    stop('invalid state')
  } else if (!outcome %in% colnames(df)) {
    stop('invalid outcome')
  } else {
    index = df$State == state & !grepl('[a-zA-Z]|\\s', df[[outcome]])
    df = df[index, ]
    df[[outcome]] = as.numeric(df[[outcome]])
    lowest = min(df[[outcome]], na.rm = TRUE)
    best = df$Hospital.Name[df[[outcome]] == lowest]
    best = sort(best)
    return(best)
  }
}

rankhospital = function(state, outcome, num) {
  df = read.csv('outcome-of-care-measures.csv', stringsAsFactors = FALSE)
  outcome = strsplit(outcome, ' ')
  capitalize = function(string) {
    substr(string, 1, 1) = toupper(substr(string, 1, 1))
    return(string)
  }
  outcome = sapply(outcome, capitalize)
  outcome = paste(outcome, collapse = '.')
  prefix = 'Hospital.30.Day.Death..Mortality..Rates.from.'
  outcome = paste0(prefix, outcome)
  if (!state %in% df$State) {
    stop('invalid state')
  } else if (!outcome %in% colnames(df)) {
    stop('invalid outcome')
  } else {
    index = df$State == state & !grepl('[a-zA-Z]|\\s', df[[outcome]])
    if (is.character(num)) {
      if (num == 'best') {
        num = 1
      } else if (num == 'worst') {
        num = sum(index)
      } else {
        stop('invalid num')
      }
    }
    df = df[index, c('Hospital.Name', outcome)]
    df[[outcome]] = as.numeric(df[[outcome]])
    df = df[order(df$Hospital.Name), ]
    df$Rank = rank(df[[outcome]], ties.method = 'first')
    df = df[order(df$Rank), ]
    ranked = ifelse(num > nrow(df), NA, df$Hospital.Name[num])
    return(ranked)
  }
}


rankall = function(outcome, num = 'best') {
  df = read.csv('outcome-of-care-measures.csv', stringsAsFactors = FALSE)
  outcome = strsplit(outcome, ' ')
  capitalize = function(string) {
    substr(string, 1, 1) = toupper(substr(string, 1, 1))
    return(string)
  }
  outcome = sapply(outcome, capitalize)
  outcome = paste(outcome, collapse = '.')
  prefix = 'Hospital.30.Day.Death..Mortality..Rates.from.'
  outcome = paste0(prefix, outcome)
  if (!outcome %in% colnames(df)) {
    stop('invalid outcome')
  } else {
    index = !grepl('[a-zA-Z]|\\s', df[[outcome]])
    df = df[index, c('Hospital.Name', 'State', outcome)]
    df[[outcome]] = as.numeric(df[[outcome]])
    df = df[order(df$Hospital.Name), ]
    rankState = function(df, num) {
      df$Rank = rank(df[[outcome]], ties.method = 'first')
      df = df[order(df$Rank), ]
      if (is.character(num)) {
        if (num %in% 'best') {
          num = 1
        } else if (num == 'worst') {
          num = nrow(df)
        } else {
          stop('invalid num')
        }
      }
      ranked = ifelse(num > nrow(df), NA, df$Hospital.Name[num])
      ranked = c(hospital = ranked, state = unique(df$State))
      return(ranked)
    }
    rankeds = sapply(split(df, as.factor(df$State)), rankState, num)
    rankeds = as.data.frame(t(rankeds))
    return(rankeds)
  }
}