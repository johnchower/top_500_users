# Function chiplot

# Wraps the three chisquare plot functions together into a single call

chiplot <- function(user_set,
                    user_set_name, 
                    upg = user_platform_action_date_group, 
                    p.thresh = .001,
                    positive.only = T,
                    ...){
  upg %>%
    select(-date_id) %>%
    mutate(in_subset = ifelse(user_id %in% user_set, user_set_name, "other")) %>%
    group_by(in_subset, group) %>%
    summarise(number_of_actions = n()) %>%
    chisquare_analysis %>%
    {.$results} %>%
    produce_chisquare_plot_data %>%
    create_chisquare_plots(thing_being_counted = "Platform Actions",
                           thing_being_sliced = "Users", 
                           err_bar_width = 5, 
                           pthresh = p.thresh,
                           positive_only = positive.only,
                           ...)
    
}