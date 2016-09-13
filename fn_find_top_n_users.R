# Function: find_top_n_users

find_top_n_users <- function(n, 
                             up = user_platform_action_facts, 
                             mindate = one_month_ago,
                             results_by = ranking_metric){
  up %>%
    filter(date_id > mindate) %>% 
    group_by(user_id) %>% 
    summarise(number_of_active_days_past28 = length(unique(date_id)),
              number_of_actions_past_28 = n()) %>% {
                if(results_by == "actions"){
                  return(arrange(., desc(number_of_actions_past_28)))
                } else {return(arrange(., desc(number_of_active_days_past_28)))}           
  } %>%
    slice(1:n) %>%
    {.$user_id} %>%
    unique
}
