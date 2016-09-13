# Filter out fake and nonexistent users

nonexistent_users <- user_createddate_champid %>%
  filter(account_created_date_id > max_date) %>%
  {.$user_id} %>%
  unique 

base.df.list %>% 
  lapply(FUN = function(df)filter_user_ids(df, user.id.vec = nonexistent_users)) %>% 
  lapply(FUN = function(df){assign_by_colnames_listversion(df, name_list)}) 
  
