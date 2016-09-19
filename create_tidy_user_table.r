# This script creates the tidy user data frame.
# This data frame is essential for having a flexible analysis that can be
# modified easily and quickly.

# Run it after you run 

user_pacount <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  group_by(user_id) %>%
  summarise(variable = "pa_count", value=n())

user_acctype_createddate_primarychamp <- user_createddate_champid %>%
  select(-Account_Type) %>%
  melt(id.vars = "user_id")

user_cornerstone_pct <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  group_by(user_id) %>%
  mutate(total_actions = n()) %>%
  ungroup %>%
  group_by(user_id, new_group) %>%
  summarise(variable=paste0("cornerstone_pct_", new_group[1])
            ,
            value=n()/total_actions[1]) %>%
  select(-new_group)

user_triangle_data <- triangle_diagram_data %>%
  select(user_id, xval, yval, mode) %>%
  rename(triangle_coord_x = xval, triangle_coord_y = yval,
         triangle_mode = mode) %>%
  melt(id.vars = "user_id")

user_response_rate <- dbGetQuery(con,"
  select user_id,
    status,
    count(*)
  from notification_events
  group by user_id, status
  order by user_id, status
  ;") %>%
  group_by(user_id) %>%
  mutate(total_notifications = sum(count),
         percent = count/total_notifications,
         status = ifelse(status > 0, status/status, 0)) %>%
  group_by(user_id) %>%
  summarise(variable = "response_rate", value  = sum(status*percent)) %>% 
  {left_join(select(user_createddate_champid, user_id), .)}

user_belongs_to_cohort <- user_cohort_groups %>%
  select(user_id, cohort_group_name, belongs_to_cohort) %>%
  melt(id.vars = "user_id")

user_pct_champ_only <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  left_join(select(platform_action_facts, platform_action, end_user_allowed)) %>%
#   mutate(end_user_allowed = ifelse(is.na(end_user_allowed),
#                                          TRUE, FALSE)) %>%
  group_by(user_id) %>%
  summarise(variable = "pct_champ_only", value = 1-mean(end_user_allowed))

  


