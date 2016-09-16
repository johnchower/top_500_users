# Prep platform action data for distribution plot

# Takes the result of a call to
# prep_user_platform_action_data_for_chisquare_analysis and transforms it to
# allow for a straight-up platform action distribution plot.

prep_platform_action_data_for_distribution_plot <- 
  function(df){

  df %>%
    filter(in_set != "other", new_group != "", !is.na(new_group)) %>%
    arrange(desc(number_of_actions))
}
