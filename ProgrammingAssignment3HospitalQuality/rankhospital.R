rankhospital<- function(state, outcome,num) {
  
  # Write a function called rankhospital that takes three arguments: the 2-character abbreviated name of a
  # state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
  # The function reads the outcome-of-care-measures.csv file and returns a character vector with the name
  # of the hospital that has the ranking specified by the num argument. For example, the call
  # rankhospital("MD", "heart failure", 5)
  # would return a character vector containing the name of the hospital with the 5th lowest 30-day death rate
  # for heart failure. The num argument can take values \best", \worst", or an integer indicating the ranking
  # (smaller numbers are better). If the number given by num is larger than the number of hospitals in that
  # state, then the function should return NA. Hospitals that do not have data on a particular outcome should
  # be excluded from the set of hospitals when deciding the rankings.
  
  ## Read outcome data
  outcome_data <- read.csv2("./rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv",sep = ",",colClasses = "character")
  
  ## Check that state and outcome are valid
  ValidState = unique(outcome_data[,7])
  if (!state %in% ValidState){
    stop("invalid state")
  }
  
  Disease = c("heart attack", "heart failure", "pneumonia")
  if(!outcome %in% Disease){
    stop("invalid outcome")
  }
  
  if(num == "best"){
    num = 1
    desc = FALSE    
  }
    else if(num == "worst"){
      num = 1
      desc = TRUE
    }
      else if(is.numeric(num))
        desc = FALSE
      else
      stop("invalid num")
  
  outcome_data <- outcome_data[outcome_data$State==state,]
  
  # vector to hold the mortality rates
  rates <- c('Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack','Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure','Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
  
  if(num>nrow(outcome_data))
    return(NA)
  suppressWarnings(outcome_data[,rates]<-sapply(outcome_data[,rates],as.numeric))
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  if(outcome == 'heart attack'){
    as.character(tail(head(outcome_data[order(outcome_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack,outcome_data$Hospital.Name,decreasing=desc),"Hospital.Name"],n = num),n = 1))
    }else if(outcome == 'heart failure')
      as.character(tail(head(outcome_data[order(outcome_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure,outcome_data$Hospital.Name,decreasing=desc),"Hospital.Name"],n = num),n = 1))
        else if(outcome == 'pneumonia')
        as.character(tail(head(outcome_data[order(outcome_data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia,outcome_data$Hospital.Name,decreasing=desc),"Hospital.Name"],n = num),n = 1))
}