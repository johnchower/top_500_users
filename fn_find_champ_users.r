# Function: find_champ_users

# Find subset of users in a given subset who have taken a "champion only"
# action at some point.

find_champ_users <- function(user_subset,
                                  coa=champion_only_actions,
                                  upf=user_platform_action_facts){

  filter(upf, 
         platform_action %in% coa$platform_action,
         user_id %in% user_subset) %>%
    {.$user_id} %>%
    unique

}
                                  
find_champ_proportion <- function(user_subset,
                                  ...){
  user_subset %>%{
    length(find_champ_users(.,...))/length(.)}
}
