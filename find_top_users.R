# find_top_users

for(N in user_tier_cutoffs){
  name <- paste("top", N, "users", sep = "_")
  
  find_top_n_users(n = N) %>% {
    assign(name, ., envir = globalenv())
  }
}
  