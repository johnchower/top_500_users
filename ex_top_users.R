# Exploration: 

# Functions and libraries
source('fn_create_underscore_version_of_name.R')
source('fn_chiplot.R')

library(htmlwidgets)

# Parameters
outloc <- "/Users/johnhower/Google Drive/Analytics_graphs/top_500_active_users_aug_31"

# Plot the cohort groupings for the top n users:

graph_user_cohort_breakdown(top_10_users, save_plots = F)
graph_user_cohort_breakdown(top_50_users, save_plots = F)
graph_user_cohort_breakdown(top_100_users, save_plots = F)
graph_user_cohort_breakdown(top_250_users, save_plots = F)
graph_user_cohort_breakdown(top_500_users, save_plots = F)

# Determine who the top 5 cohorts are among the most active user tiers
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

# Find out who belongs to the most active cohorts.

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

# Make user sets of the cohort groups intersect the top 500:

top_500_intersect_active_cohort_group_list <- active_cohort_group_list %>%
  llply(
   .fun = function(user_set){
     intersect(user_set, top_500_users)
   }
  ) %>%
  setNames(., paste("top_500_intersect", names(.), sep = "_"))

# Plot triangle diagrams for the active cohort groups (intersect top 500.)
top_500_intersect_active_cohort_group_triangle_plots <- top_500_intersect_active_cohort_group_list %>%
  lapply(
    FUN = function(uset){plot_triangle_diagram(user_set = uset)}
  ) 

top_500_intersect_active_cohort_group_triangle_plots %>% {
    names <- names(.) %>% as.list
    
    lapply(names, 
           FUN = function(name){
             current_graph <- .[[name]] +
               ggtitle(name)
             
             ggsave(filename = paste("triangle", name, ".pdf", sep = "_"),
                    plot = current_graph,
                    path = outloc,
                    width = 12, height = 9)
           })
  }
  
# Plot chisquare diagrams for the active cohort groups (intersect top 500)

chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_Cohort_Family_Bridges_users,
        user_set_name = "Family Bridges Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .005), 
        bottommargin = 200
        )

chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_Cohort_Christian_Character_Formation_Project_users,
        user_set_name = "Christian CFP Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .3), bottommargin = 200)


chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_Cohort_TYRO_users,
        user_set_name = "Tyro Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .25), bottommargin = 200)


chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_Cohort_Cru_MPD_users,
        user_set_name = "Cru MPD Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .3), bottommargin = 200)


chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_Cohort_Civic_Character_Formation_Project_users,
        user_set_name = "Civic CFP Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .01), bottommargin = 200)


chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_No_Cohort_FamilyLife_users,
        user_set_name = "FamilyLife Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .15), bottommargin = 200)


chiplot(top_500_intersect_active_cohort_group_list$top_500_intersect_Cohort_Relational_Values_users,
        user_set_name = "Relational Values Intersect Top 500",
        yaxisformat = "%", yaxisrange = c(0, .15), bottommargin = 200)

# Merge activity level into user_email_name and then sort

user_email_name_activitylevel <- user_platform_action_facts %>%
  filter(date_id > one_month_ago) %>% 
  group_by(user_id) %>% 
  summarise(number_of_actions_past_28 = n()) %>% {
    left_join(user_email_name, select(., user_id, number_of_actions_past_28))
  } %>%
  arrange(desc(number_of_actions_past_28))

user_email_name_activitylevel %>%
  slice(1:500) %>%
  {.$number_of_actions_past_28} %>% 
  hist

