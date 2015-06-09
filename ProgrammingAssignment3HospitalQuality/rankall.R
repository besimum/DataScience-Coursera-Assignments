rankall <- function(outcome, num = "best") {
  
  # Write a function called rankall that takes two arguments: an outcome name (outcome) and a hospital rank-
  #   ing (num). The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame
  # containing the hospital in each state that has the ranking specified in num. For example the function call
  # rankall("heart attack", "best") would return a data frame containing the names of the hospitals that
  # are the best in their respective states for 30-day heart attack death rates. The function should return a value
  # for every state (some may be NA). The first column in the data frame is named hospital, which contains
  # the hospital name, and the second column is named state, which contains the 2-character abbreviation for
  # the state name. Hospitals that do not have data on a particular outcome should be excluded from the set of
  # hospitals when deciding the rankings.
  
  # Read outcome data
  outcome_data <- read.csv("./rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", 
                           colClasses = "character", na.strings="Not Available")
  
  # Validate outcomes
  validate_outcomes <- if (outcome == "heart attack") {
    11
  } else if (outcome == "heart failure") {
    17
  } else if (outcome == "pneumonia") {
    23
  } else {
    stop("invalid outcome")
  }
  
  #ValidState = unique(outcome_data[,7])
  #if (!state %in% ValidState){
  #  stop("invalid state")
  #}
  
  ## For each state, find the hospital of the given rank
  ## Return hospital name in that state with the given rank 30-day death rate
  outcome_data <- outcome_data[, c(7, 2, validate_outcomes)]
  outcome_data[, 3] <- suppressWarnings(as.numeric(outcome_data[, 3]))
  outcome_data <- outcome_data[order(outcome_data[1], outcome_data[3], outcome_data[2]), ]
  outcome_data <- outcome_data[complete.cases(outcome_data[3]), ]
  use_case <- split(outcome_data, outcome_data[1])
  
  if (num == "best") {
    x <- lapply(use_case, function(i) { i[1,] })
  } else if (num == "worst") {
    x <- lapply(use_case, function(i) { i[nrow(i),] })
  } else {
    x <- lapply(use_case, function(i) { i[num,] })
  }
  
  ## Return a data frame with the hospital names and the (abbreviated) state name
  data_frame <- as.data.frame(do.call(rbind, x))
  data_frame[,1] <- row.names(data_frame)
  data_frame <- data_frame[, 2:1]
  colnames(data_frame) <- c("hospital", "state")
  data_frame
}
