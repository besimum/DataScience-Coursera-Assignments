best <- function(state, outcome){
  
  # Write a function called best that take two arguments: the 2-character abbreviated name of a state and an
  # outcome name. The function reads the outcome-of-care-measures.csv file and returns a character vector
  # with the name of the hospital that has the best (i.e. lowest) 30-day mortality for the specified outcome
  # in that state. The hospital name is the name provided in the Hospital.Name variable. The outcomes can
  # be one of \heart attack", \heart failure", or \pneumonia". Hospitals that do not have data on a particular
  # outcome should be excluded from the set of hospitals when deciding the rankings.
  
  
  # Read outcome data
  data <- read.csv("C:/Users/BenjaminM/DataScience-Coursera-Assignments/ProgrammingAssignment3HospitalQuality/rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", 
                   colClasses = "character", na.strings="Not Available")
  
  ## Check that state and outcome are valid
  ValidOutcome = c("heart attack", "heart failure", "pneumonia")
  if(!outcome %in% ValidOutcome){
    stop("invalid outcome")
  }
  
  ValidState = unique(data[,7])
  if (!state %in% ValidState){
    stop("invalid state")
  }
  
  CompleteColNames <- c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                        "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                        "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
  Columns <- CompleteColNames[match(outcome,ValidOutcome)]
  
  ## Return hospital name in that state with the lowest 30-day death rate
  #MinMortality <- lapply(data[,2])
  data.state <- data[data$State==state,]
  MinMortality <- which.min(as.double(data.state[,Columns]))
  data.state[MinMortality,"Hospital.Name"]
  
}