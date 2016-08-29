# Function: assign_by_colnames

# Read the column names of a data frame.
# If they match a target, then assign that data frame to the corresponding variable name.

assign_by_colnames <- function(df, col.names, assigned_name){
  diff1 <- setdiff(col.names, colnames(df)) %>% length
  diff2 <- setdiff(colnames(df), col.names) %>% length
  
  if(diff1 == 0 & diff2 == 0){
    assign(assigned_name, df, envir = globalenv())
  }
}

# List version: pass it a list of names and colname matches, and it'll detect the 
# right one

# Sample name.list to pass:

# name_list <- list(
#   list(col.names = c("cohort_id", "champion_id"), assigned_name = "cohort_to_champion_bridges"),
#   list(col.names = c("user_id", "cohort_id", "created_date_id"), assigned_name = "user_to_cohort_bridges"),
#   list(col.names = c("user_id", "champion_id"), assigned_name = "user_to_champion_bridges"),
#   list(col.names = c("user_id", "date_id", "platform_action"), assigned_name = "user_platform_action_facts")
# )

assign_by_colnames_listversion <- function(df, name.list){
  name.list %>%
    lapply(
      FUN = function(x)assign_by_colnames(df, x$col.names, x$assigned_name)
    )
}