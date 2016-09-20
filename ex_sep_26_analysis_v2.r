# (Cohort, account_type) breakdown by tier

user_cohort_breakdown_data_list <- user_tier_cutoffs %>%
  as.list %>% {
  names(.)  <- paste("top", ., sep = "_")
  return(.) } %>%
  llply(.fun = function(cutoff){
    y <- char_tidy_user_table %>%
      filter(variable %in% "Account_Type") %>%
      dcast(user_id ~ variable, value.var = "value")

    x <- num_tidy_user_table %>%
      filter(variable %in% c("pa_rank")) %>%
      dcast(user_id ~ variable, value.var = "value") %>%
      filter(pa_rank <= cutoff) %>%
      select(-pa_rank) %>% {
      left_join(., y) } 

    cohortdata_char_user_belongs_to_cohort %>%
      filter(variable=="cohort_group_name") %>% 
      select(user_id, belongs_to_cohort = value) %>% {
      inner_join(., x) } %>% 
      group_by(belongs_to_cohort, Account_Type) %>%
      summarise(number_of_users = length(unique(user_id))) %>%
      mutate(Account_Type = gsub(pattern = " ", replacement = "_", Account_Type)) %>%
      group_by(belongs_to_cohort) %>%
      mutate(total_users = sum(number_of_users),
             percent_users = total_users/cutoff) %>% 
      dcast(belongs_to_cohort + total_users + percent_users ~ Account_Type, 
            value.var = "number_of_users")  %>% 
      arrange(desc(total_users)) %>% {
      .[is.na(.)] <- 0
      return(.) }

  }) 
    
# Most active cohort groups

most_active_cohort_groups <- user_cohort_breakdown_data_list %>%
  lapply(FUN = function(df){
    df %>%
      filter(percent_users >= .05) %>%
      {.$belongs_to_cohort} %>%
      unique
  }) %>%
  unlist %>%
  unique


# Dominant Platform Action breakdown by tier, cohort_group, account_type

dominant_pa_breakdown_list <- user_tier_cutoffs %>%
  as.list %>% {
  names(.)  <- paste("top", ., sep = "_")
  return(.) } %>%
  llply(.fun = function(cutoff){
    y <- char_tidy_user_table %>%
      filter(variable %in% "Account_Type") %>%
      dcast(user_id ~ variable, value.var = "value")

    x <- num_tidy_user_table %>%
      filter(variable %in% c("pa_rank", "pa_count")|
             grepl(pattern = "cornerstone_count_", x = variable)) %>%
      dcast(user_id ~ variable, value.var = "value") %>%
      filter(pa_rank <= cutoff) %>%
      select(-pa_rank) %>% {
      left_join(., y) } %>% {
      .[is.na(.)] <- 0
      return(.) } 

    cohortdata_char_user_belongs_to_cohort %>%
      filter(variable == "cohort_group_name") %>%
      select(user_id, belongs_to_cohort = value) %>% {
      inner_join(., x) } %>%
      select(-user_id) %>%
      melt(id.vars = c("belongs_to_cohort", "Account_Type")) %>% 
      group_by(belongs_to_cohort, Account_Type, variable) %>%
      summarise(total_actions = sum(value)) %>% head

  })
  
# Response rate by (tier, account_type)

response_rate_list <- user_tier_cutoffs %>%
  as.list %>% {
  names(.) <- paste("top", ., sep = "_")
  return(.) } %>%
  llply(.fun = function(cutoff){
          
          
    y <- char_tidy_user_table %>%
      filter(variable %in% "Account_Type") %>%
      dcast(user_id ~ variable, value.var = "value")

    x <- num_tidy_user_table %>%
      filter(variable %in% c("pa_rank", "response_rate")) %>%
      dcast(user_id ~ variable, value.var = "value") %>%
      filter(pa_rank <= cutoff) %>%
      select(-pa_rank) %>% {
      left_join(., y) } %>% {
      .[is.na(.)] <- 0
      return(.) }

    cohortdata_char_user_belongs_to_cohort %>%
      filter(variable == "cohort_group_name") %>%
      select(user_id, belongs_to_cohort = value) %>% {
      inner_join(., x) } %>%
      select(-user_id) %>%
      melt(id.vars = c("belongs_to_cohort", "Account_Type")) %>% 
      group_by(belongs_to_cohort, Account_Type, variable) %>% 
      summarise(avg_response_rate = mean(value)) 

  })

# Number of champion connections vs # of platform actions.


