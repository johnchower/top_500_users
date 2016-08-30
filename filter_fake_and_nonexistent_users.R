# Filter out fake and nonexistent users

nonexistent_users <- user_createddate_champid %>%
  filter(account_created_date_id > max_date) %>%
  {.$user_id} %>%
  unique 

fake_users <- fake_end_users %>%
  {.$user_id} %>%
  unique

fake_and_nonexistent_users <- rbind(data.frame(user_id = fake_end_users),
                                    data.frame(user_id = nonexistent_users))
  
source('fn_filter_user_ids.R')

c(x,y) %>%
  lapply(FUN = function(df)filter_user_ids(df, fake_and_nonexistent_users)) %>%
  lapply(FUN = function(df){assign_by_colnames_listversion(df, name_list)}) 
  

