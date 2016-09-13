# Define a bunch of relevant user subsets here

all_users <- user_createddate_champid %>%
  {.$user_id} %>%
  unique

nominally_end_users <- user_createddate_champid %>%
  filter(account_type == 'End User') %>%
  {.$user_id} %>%
  unique

end_users_who_have_taken_a_champ_only_action <- 
  find_champ_users(nominally_end_users)

# Top N users, N %in% user_tier_cutoffs
for(N in user_tier_cutoffs){
  name <- paste("top", N, "users", sep = "_")

  find_top_n_users(n = N) %>% {
    assign(name, ., envir = globalenv())
  }
}

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

end_users_who_are_actually_internal_gloo_users <- user_filters %>%
  filter(filter_type == "user_id") %>%
  {.$filter} %>%
  as.numeric
