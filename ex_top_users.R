# Exploration: 

source('fn_create_underscore_version_of_name.R')

active_cohort_groups <-user_tier_cutoffs %>% 
  as.list %>%
  lapply(
    FUN = function(n){
      get(paste("top", n, "users", sep = "_")) %>%
        produce_cohort_breakdown_graph_data %>%
        slice(1:5) %>%
        filter(number_of_users > 1) %>%
        {.$cohort_group_name}
    }
  ) %>%
  unlist %>%
  unique 


  

# Define user sets which belong to the active cohort groups

active_cohort_group_list <- active_cohort_groups %>%
  {setNames(object = ., create_underscore_version_of_name(.))} %>%
  as.list %>%
  llply(
    .fun = function(cohort_group){
      
      underscore_name_version <- cohort_group %>% 
        {gsub(" - ", "_", .)} %>%
        {gsub(" ", "_", .)} %>%
        {paste(., "users", sep = "_")}
      
      user_cohort_groups %>%
        filter(cohort_group_name == cohort_group) %>%
        {.$user_id} %>%
        unique # %>%
        # assign(underscore_name_version, ., envir = globalenv())
    }
  )