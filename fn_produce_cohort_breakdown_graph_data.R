# Function: produce_cohort_breakdown_graph_data

produce_cohort_breakdown_graph_data <- function(user_set,
                                   ucg = user_cohort_groups){
  set_name <- deparse(substitute(user_set)) %>% {
    gsub("_", " ", .)
  } %>% {
    gsub("users", "", .)
  }
  
  ucg %>%
    filter(user_id %in% user_set) %>%
    group_by(cohort_group_name) %>%
    summarise(number_of_users = length(unique(user_id))) %>%
    arrange(desc(number_of_users))
}