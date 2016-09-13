# read_user_filters

# email filters

users_with_champ_emails <- user_filters %>%
  filter(filter_type == "email") %>%
  {.$filter} %>%
  as.list %>%
  lapply(
    FUN = function(domain){
      user_email_name %>%
        filter(grepl(domain, email)) %>%
        {.$user_id}
    }
  ) %>%
  unlist 

internal_gloo_users <- user_filters %>%
  filter(filter_type == "user_id") %>%
  {.$filter} %>%
  as.numeric
