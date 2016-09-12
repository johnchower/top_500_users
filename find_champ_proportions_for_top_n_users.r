# Find champ proportions for user tiers

# This script finds the proportion of champion users for each of the
# top_n user groups.

# Run it after you run master.r

source('fn_find_champ_users.r')

champ_proportion_data <- user_tier_cutoffs %>%
  {data.frame(n = .)} %>%
  group_by(n) %>%
  summarise(proportion_of_champion_users =
     find_champ_proportion(get(paste("top", n, "users", sep = "_")))   
  )
  
champ_proportion_plot <- champ_proportion_data %>%  
  mutate(n = paste("Top", n, "users", sep = " "))  
