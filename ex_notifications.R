notification_status <- dbGetQuery(con,"
  select user_id,
    status,
    count(*)
  from notification_events
  group by user_id, status
  order by user_id, status
  ;") %>%
  group_by(user_id) %>%
  mutate(total_notifications = sum(count),
         percent = count/total_notifications) %>%
  arrange(user_id) 
