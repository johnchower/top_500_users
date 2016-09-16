# Analysis for September 26

# Cohort breakdowns of top tiers:
graph_user_cohort_breakdown(top_10_users, n = 5, save_plots = F)
graph_user_cohort_breakdown(top_50_users,  n = 5, save_plots = F)
graph_user_cohort_breakdown(top_100_users, n = 5, save_plots = F)
graph_user_cohort_breakdown(top_250_users, n = 5, save_plots = F)
graph_user_cohort_breakdown(top_500_users, n = 5, save_plots = F)

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
top_500_intersect_active_cohort_group_triangle_plots <- 
  top_500_intersect_active_cohort_group_list %>%
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
 
# Plot platform action distributions for the active cohort groups (intersect
# top 500)

# First, set up the data
source('fn_produce_bar_chart_with_n.r')
source('fn_tufte_bar_chart.r')
source('fn_extract_group_name.r')
padist_data_list <- 
  top_500_intersect_active_cohort_group_list %>%
  lapply(prep_user_platform_action_data_for_chisquare_analysis) %>%
  lapply(prep_platform_action_data_for_distribution_plot) %>%
  lapply(FUN = function(df)select(ungroup(df), -in_set)) %>%
  lapply(FUN = function(df){
            df %>%
              mutate(total_actions = sum(number_of_actions),
                     percent_of_actions = number_of_actions/total_actions) %>%
              select(-number_of_actions) %>%
              rename(group = new_group,
                     total = total_actions,
                     percent = percent_of_actions) %>%
              arrange(desc(percent)) %>%
              slice(1:3)
          }) %>%
  lapply(FUN=produce_bar_chart_with_n) 

padist_data_list %>%
  names %>%
  as.list %>%
  lapply(FUN=function(name){
    graph <- padist_data_list[[name]]$graph
    n <- padist_data_list[[name]]$n
    group_name <-extract_group_name(name)
    graph_label <- paste0("Platform actions taken by the top\n",
                   group_name,
                   " users\n(n = ",
                   n,
                   " actions total)")
    graph +
      annotate("text",
               x = 5, y = .8, adj = 1,
               label =graph_label)
  })

