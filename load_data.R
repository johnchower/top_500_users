# load_data

source('in_data_frame_name_list.R')
source('fn_assign_by_colnames.R')

looker.csvs = paste(find_root(has_file("README.md")), "looker_csvs", sep = "/")
static.csvs = paste(find_root(has_file("README.md")), "static_csvs", sep = "/")

x <- looker.csvs %>%
  {paste(., dir(.), sep = "/")} %>%
  lapply(FUN = function(path)read.csv(path, stringsAsFactors = F)) 

y <- static.csvs %>%
  {paste(., dir(.), sep = "/")} %>%
  lapply(FUN = function(path)read.csv(path, stringsAsFactors = F))

c(x, y) %>%
  lapply(FUN = function(df){assign_by_colnames_listversion(df, name_list)})

champion_only_actions %<>% 
  rename(platform_action = User.Platform.Action.Facts.Platform.Action)

platform_action_facts %<>%
  mutate(end_user_allowed = !(platform_action %in% champion_only_actions$platform_action))

