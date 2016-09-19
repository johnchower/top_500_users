# This script creates the tidy user data frame.
# This data frame is essential for having a flexible analysis that can be
# modified easily and quickly.

# Run it after you run 

user_pacount <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  group_by(user_id) %>%
  summarise(pa_count = n()) %>%
  arrange(desc(pa_count)) %>%
  {cbind(., data.frame(pa_rank = 1:nrow(.)))} %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

user_acctype_createddate_primarychamp <- user_createddate_champid %>%
  select(-Account_Type) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame


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
  select(-new_group) %>%
  as.data.frame


user_triangle_data <- triangle_diagram_data %>%
  select(user_id, xval, yval, mode) %>%
  rename(triangle_coord_x = xval, triangle_coord_y = yval,
         triangle_mode = mode) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame


user_response_rate <- dbGetQuery(con,"
  select user_id,
    status,
    count(*)
  from notification_events
  group by user_id, status
  order by user_id, status
  ;") %>%
  filter(user_id %in% all_users) %>%
  group_by(user_id) %>%
  mutate(total_notifications = sum(count),
         percent = count/total_notifications,
         status = ifelse(status > 0, status/status, 0)) %>%
  group_by(user_id) %>%
  summarise(variable = "response_rate", value  = sum(status*percent)) %>% 
  {left_join(select(user_createddate_champid, user_id), .)} %>%
  as.data.frame


user_belongs_to_cohort <- user_cohort_groups %>%
  select(user_id, cohort_group_name, belongs_to_cohort) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame


user_pct_champ_only <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  left_join(select(platform_action_facts, platform_action, end_user_allowed)) %>%
#   mutate(end_user_allowed = ifelse(is.na(end_user_allowed),
#                                          TRUE, FALSE)) %>%
  group_by(user_id) %>%
  summarise(variable = "pct_champ_only", value = 1-mean(end_user_allowed)) %>%
  as.data.frame


user_connected_to_champion <- 
  run_inline_query(model = "gloo",
                  view = "user_platform_action_facts",
                 fields = c("user_dimensions.id",
                          "user_connected_to_champion_dimensions.id"),
                 filters = list(c("user_dimensions.id", "24"))) %>%
  rename(user_id = user_dimensions.id,
         connected_to_champion = user_connected_to_champion_dimensions.id) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame


tidy_user_table <- rbind(user_pacount,
                         user_acctype_createddate_primarychamp,
                         user_cornerstone_pct,
                         user_triangle_data,
                         user_response_rate,
                         user_belongs_to_cohort,
                         user_pct_champ_only,
                         user_connected_to_champion) %>%
  filter(user_id %in% all_users) %>%
  mutate(variable = as.character(variable))

rm(user_pacount,
   user_acctype_createddate_primarychamp,
   user_cornerstone_pct,
   user_triangle_data,
   user_response_rate,
   user_belongs_to_cohort,
   user_pct_champ_only,
   user_connected_to_champion)

