# find_top_users

top_user_list <- user_tier_cutoffs %>%
  {setNames(., paste("top", ., "users", sep = "_"))} %>%
  as.list %>%
  llply(
    .fun = find_top_n_users
  )

# for(N in user_tier_cutoffs){
#   name <- paste("top", N, "users", sep = "_")
#   
#   find_top_n_users(n = N) %>% {
#     assign(name, ., envir = globalenv())
#   }
# }