# Cohort breakdown graph

user_cohort_breakdown_graph_list <- user_cohort_breakdown_data_list %>%
  names %>%
  llply(.fun = function(name){
#     name <- "top_500"
    x <- user_cohort_breakdown_data_list[[name]]
    
    max_user_number <- max(x$total_users)
    
    x %>%
      filter(percent_users >= .05) %>%
      mutate(
        belongs_to_cohort = 
          gsub(
            pattern = "Character Formation Project",
            replacement = "CFP",
            x = belongs_to_cohort
          )
      ) %>%
      transform(
        belongs_to_cohort = 
          reorder(
            belongs_to_cohort,
            order(percent_users, decreasing = T)
          )
      ) %>% 
      tufte_bar_chart(
        x_var = "belongs_to_cohort",
        y_var = "total_users",
        ybreaks = 
          seq(0,
              max_user_number,
              signif(max_user_number/5, 1)
          )
      ) %>% return
  })

