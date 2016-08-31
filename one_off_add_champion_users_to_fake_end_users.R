champion_users <- user_email_name %>% 
  filter(grepl("stadia.cc", email) |
           grepl("kffdn.org", email) |
           grepl("pacden.com", email) |
           grepl("pacificdentalservices.com", email) |
           grepl("cfacorp.com", email) |
           grepl("cfafranchisee.com", email) |
           grepl("chick-fil-a.com", email) |
           grepl("uchealth.org", email) |
           grepl("urbanministries.com", email) |
           grepl("relishtraymedia.com", email) ) %>%
           {.$user_id} %>%
  unique %>%
  {data.frame(user_id = .)}

rbind(champion_users, fake_end_users) %>%
  unique %>%
  write.csv("~/Projects/top_500_users/static_csvs/fake_end_users.csv")