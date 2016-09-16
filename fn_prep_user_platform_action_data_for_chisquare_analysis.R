# Function: prep_user_platform_action_data_for_chisquare_analysis 
prep_user_platform_action_data_for_chisquare_analysis <- 
  function(user_set,
    mindate = one_month_ago,
    maxdate = max_date,
    upg = user_platform_action_date_group){

  set_name <- deparse(substitute(user_set)) %>% {
      gsub("_", " ", .)
    } %>% {
      gsub("users", "", .)
    }
  
  upg %>%
    filter(date_id > mindate, date_id <= maxdate) %>%
    mutate(in_set = ifelse(user_id %in% user_set, set_name, "other")) %>%
    group_by(in_set, new_group) %>%
    summarise(number_of_actions = n())
}
