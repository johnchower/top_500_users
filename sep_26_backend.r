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

# Triangle diagrams for active cohort groups

triangle_diagram_data_list <- most_active_cohort_groups %>%
  as.list %>% {
  names(.) <- .
  return(.) } %>%
  llply(.fun = function(cohort_group){
    user_set <- cohortdata_char_user_belongs_to_cohort %>%
      filter(variable == "cohort_group_name",
            value == cohort_group) %>%
      {.$user_id} %>%
      unique
    
    triangle_diagram_data %>%
      filter(user_id %in% user_set)
  })

# Triangle diagrams for specific cohorts.

  # First extract specific cohorts:
  active_cohort_id_data <- user_cohort_groups %>%
    filter(cohort_group_name %in% most_active_cohort_groups,
           belongs_to_cohort) %>% {
    inner_join(cohort_to_champion_bridges, .) } %>%
    select(cohort_id, cohort_group_name) %>%
    unique %>%
    ddply(.variables = "cohort_group_name",
          .fun = function(df){
            top_500 <- num_tidy_user_table %>%
              filter(variable == "pa_rank", value <= 500) %>%
              {.$user_id} %>%
              unique

            user_to_cohort_bridges %>%
              filter(cohort_id %in% df$cohort_id,
                     user_id %in% top_500) %>%
              group_by(cohort_id) %>%
              summarise(number_of_users = length(unique(user_id))) %>%
              arrange(desc(number_of_users))
    })
  
  # Get triangle diagram data for user_ids belonging to each cohort:
#   active_cohort_id_data %>%
#     dlply(.variables = c("'cohort_group_name", "cohort_id"),
#           .fun = function(df){
#             group <- df$cohort_group_name[1]
#             current_cohort_id <- df$cohort_id[1]
#             active_users <- df$user_id
#             users_belonging_to_current_cohort <- 
# 
# 
#             triangle_diagram_data %>%
#               filter(
# 
#           })
# Number of champion connectiosn vs number of actions

champ_connections_vs_activity <- num_tidy_user_table %>%
  filter(variable %in% c("number_of_champion_connections", "pa_count")) %>%
  dcast(user_id ~ variable, value.var = "value") %>% {
  .[is.na(.)] <- 0 }

# Percent of 'champion_only' actions vs number of actions

# pct_champ_only_vs_activity <- num_tidy_user_table %>%
#   filter(variable %in% c("
