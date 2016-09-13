# Find the top n non-internal users
non_internal_users <- user_createddate_champid %>%
  filter(Account_Type != "Internal User") %>%
  {.$user_id} %>%
  unique

for(N in user_tier_cutoffs){
  name <- paste("top", N, "users", sep = "_")

  find_top_n_users(n = N, user_subset = non_internal_users) %>% {
    assign(name, ., envir = globalenv())
  }
}
