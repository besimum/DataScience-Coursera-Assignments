pollutantmean <- function(directory, pollutant, id = 1:332) {
  
  # combine objects to be concatenated from the dir for all csv files
  data_files = lapply(id, function(i) read.csv(paste(directory, "/", formatC(i,width = 3, flag = "0"), ".csv", sep = ""))[[pollutant]])
  
  # Given a list structure x, unlist simplifies it to produce a vector which contains all the atomic components which occur in x.
  # Remove NA or missing values thereafter
  
  sulfate <- round(mean(unlist(data_files), na.rm = TRUE), digits = 3)
  return (sulfate)    
  
  nitrate <- round(mean(unlist(data_files), na.rm = TRUE), digits = 3)
  return (nitrate)    
}