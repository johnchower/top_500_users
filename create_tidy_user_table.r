# This script creates the tidy user data frame.
# This data frame is essential for having a flexible analysis that can be
# modified easily and quickly.

num_user_pacount <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date,
         user_id %in% all_users) %>%
  group_by(user_id) %>%
  summarise(pa_count = n()) %>%
  arrange(desc(pa_count)) %>%
  {cbind(., data.frame(pa_rank = 1:nrow(.)))} %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

char_user_account_type <- user_createddate_champid %>%
  select(user_id, Account_Type, account_type) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

num_user_createddate_primarychamp <- user_createddate_champid %>%
  select(user_id, account_created_date_id, primary_champion=champion_id) %>%
  melt(id.vars = "user_id") %>%
  mutate(value = as.numeric(value)) %>%
  as.data.frame

num_user_cornerstone_count <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  group_by(user_id) %>%
  mutate(total_actions = n()) %>%
  ungroup %>%
  group_by(user_id, new_group) %>%
  summarise(variable=paste0("cornerstone_count_", new_group[1])
            ,
            value=n()) %>%
  select(-new_group) %>%
  as.data.frame

num_user_triangle_coords <- triangle_diagram_data %>%
  select(user_id, xval, yval) %>%
  rename(triangle_coord_x = xval,
         triangle_coord_y = yval) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

char_user_triangle_data <- triangle_diagram_data %>%
  select(user_id, mode) %>%
  rename(triangle_mode = mode) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

num_user_response_rate <- dbGetQuery(con,"
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
  {join(select(user_createddate_champid, user_id), .)} %>%
  as.data.frame %>%
  ungroup %>%
  filter(!is.na(variable), !is.na(value))

cohortdata_char_user_belongs_to_cohort <- user_cohort_groups %>%
  select(user_id, cohort_group_name, belongs_to_cohort) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

num_user_pct_champ_only <- user_platform_action_date_group %>%
  filter(date_id > one_month_ago,
         date_id <= max_date) %>%
  left_join(select(platform_action_facts, platform_action, end_user_allowed)) %>%
#   mutate(end_user_allowed = ifelse(is.na(end_user_allowed),
#                                          TRUE, FALSE)) %>%
  group_by(user_id) %>%
  summarise(variable = "pct_champ_only", value = 1-mean(end_user_allowed)) %>%
  as.data.frame


champdata_num_user_connected_to_champion <- 
  run_inline_query(model = "gloo",
                  view = "user_platform_action_facts",
                 fields = c("user_dimensions.id",
                          "user_connected_to_champion_dimensions.id"),
                 filters = list(c("user_dimensions.id", "24"))) %>%
  rename(user_id = user_dimensions.id,
         connected_to_champion = user_connected_to_champion_dimensions.id) %>%
  melt(id.vars = "user_id") %>%
  as.data.frame

num_tidy_user_table <- rbind(num_user_cornerstone_count,
                             num_user_createddate_primarychamp,
                             num_user_pacount,
                             num_user_pct_champ_only,
                             num_user_response_rate,
                             num_user_triangle_coords) %>%
  filter(user_id %in% all_users)

char_tidy_user_table <- rbind(char_user_account_type,
                              char_user_triangle_data) %>%
  filter(user_id %in% all_users)


rm(num_user_cornerstone_count,
   num_user_createddate_primarychamp,
   num_user_pacount,
   num_user_pct_champ_only,
   num_user_response_rate,
   num_user_triangle_coords,
   char_user_account_type,
   char_user_triangle_data)


