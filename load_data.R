# Load Data

# Load all looker and static csvs into memory.
# Save with names determined by name_list.JSON
name_list <- fromJSON('name_list.JSON')
base.df.list <- load_data() 
lapply(base.df.list, FUN = function(df){assign_by_colnames_listversion(df, name_list)})

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
  

# Filter out any users whose account was created after the max_date cutoff
nonexistent_users <- user_createddate_champid %>%
  filter(account_created_date_id > max_date) %>%
  {.$user_id} %>%
  unique 

base.df.list %>% 
  lapply(FUN = function(df)filter_user_ids(df, user.id.vec = nonexistent_users)) %>% 
  lapply(FUN = function(df){assign_by_colnames_listversion(df, name_list)}) 
  
rm(nonexistent_users)

# Filter out any fields whose date occurs after the max_date cutoff

user_to_cohort_bridges %<>% 
  filter(created_date_id <= max_date)

# Produce user_cohort_groups

user_cohort_groups <- user_to_cohort_bridges %>%
  select(-created_date_id) %>%
  left_join(cohort_to_champion_bridges) %>% 
  rename(cohort_champion_id = champion_id) %>% {
    left_join(
      select(user_createddate_champid, user_id, first_champion_id = champion_id),
      .
    )
  } %>%
  mutate(belongs_to_cohort = ifelse(is.na(cohort_id),
                                    F, T),
         champion_id = ifelse(is.na(cohort_id),
                              first_champion_id,
                              cohort_champion_id)) %>%
  select(user_id, champion_id, belongs_to_cohort) %>%
  left_join(select(champion_facts, champion_id, champion_name)) %>%
  mutate(cohort_group_name = ifelse(belongs_to_cohort,
                                    paste("Cohort", champion_name, sep = " - "),
                                    paste("No Cohort", champion_name, sep = " - ")
  ))

# Produce triangle diagram data
triangle_diagram_data <- produce_triangle_diagram_data()

# Classify platform actions that can't be taken by end users
champion_only_actions <- rename(champion_only_actions,
                                platform_action = User.Platform.Action.Facts.Platform.Action)

platform_action_facts %<>% 
  mutate(end_user_allowed=
         !(platform_action %in% champion_only_actions$platform_action)) %>%
  left_join(rename(platform_action_group_new, new_group = group)) %>%
  mutate(new_group = ifelse(is.na(new_group),"",new_group))

# Join platform action group to user_platform_action_date

user_platform_action_date_group <- user_platform_action_facts %>%
  left_join(select(platform_action_facts, platform_action, group, new_group))
