# Function: extract group name
extract_group_name <- function(x){
    x <- strsplit(x, "_")[[1]]
    cohort_position <- which(x=="Cohort")
    new_x <- x[cohort_position:length(x)]
    user_position <- which(new_x=="users")
    new_x[2:(user_position-1)] %>%
      paste(collapse=" ")
    
  }
