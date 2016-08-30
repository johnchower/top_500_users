# Function: graph_user_cohort_breakdown

graph_user_cohort_breakdown <- function(user_set,
                                        n = 5,
                                        ucg = user_cohort_groups,
                                        ...){
  set_name <- deparse(substitute(user_set)) %>% {
    gsub("_", " ", .)
  } %>% {
    gsub("users", "", .)
  }
  
  ucg %>%
    filter(user_id %in% user_set) %>% {
    produce_cohort_breakdown_graph_data(user_set, .)
    } %>%
    slice(1:5) %>%
    plot_ly(x = cohort_group_name, y = number_of_users, type = "bar") %>%
    bar_chart_layout(
      charttitle = paste("Cohort Breakdown for", set_name, "Users", sep = " ")
      , bottommargin = 250
      , yaxistitle = "Number of Users"
    ) %>%
    save_or_print(plot_name = paste("cohort_breakdown_", set_name, sep = ""),
                  ...)
}