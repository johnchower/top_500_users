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


