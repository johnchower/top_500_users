# Fix up users whose first platform action happened before they created an account.

user_platform_action_facts %<>%
  group_by(user_id) %>%
  mutate(min_date = min(date_id)) %>% 
  filter(date_id == min_date) %>%
  summarise(premature_actions = !("Account Created" %in% platform_action),
            first_action_date_id = date_id[1]) %>%
  filter(premature_actions > 0) %>%
  select(user_id, first_action_date_id) %>% {
    left_join(user_createddate_champid, .)
  } %>%
  mutate(account_created_date_id = ifelse(
    is.na(first_action_date_id),
    account_created_date_id,
    first_action_date_id
  )) %>% 
  select(-first_action_date_id)
  
  