# Function: filter_user_ids

# Given a data frame with a column consisting of user_ids,
# 1. Detect which column that is
# 2. Filter out all rows who contain a user_id belonging to a given vector

filter_user_ids <- function(df, user.id.vec){
  user_colname <- df %>%
    colnames %>%
    {grep("user", ., value=T)}
  
  if(length(user_colname) == 1){
    df[!(df[[user_colname]] %in% user.id.vec),] %>%
      return
  } else {data.frame(error = "Multiple column names containing the string 'user'")}
}