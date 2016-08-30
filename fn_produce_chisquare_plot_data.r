# Function: produce_chisquare_plot_data

# Takes the result of a chisquare_analysis call and plots the data needed for
# the bar charts that compare the expected to the actual counts in each category.

produce_chisquare_plot_data <- function(results, # Take this from a chisquare analysis. You'll have to apply your own filters before calling the function
                                        group_variable = colnames(results)[1]){
    results %>% {
        colnames(.)[3] <- "observed"
        return(.)
      } %>% 
      group_by_(group_variable) %>% 
      mutate(total_actions = sum(observed),
            percent_observed = observed/total_actions,
            percent_expected = expected/total_actions,
            err = err/total_actions) %>% 
    ungroup %>% 
    dlply(
      .variables = group_variable,
    )
}