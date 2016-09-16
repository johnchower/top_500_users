# Function: produce bar chart with n

# Give it a data frame with 3 columns:
# A grouping variable 
# A total variable 
# A percentage variable 

# It'll produce 2 items:
# A ggplot of the percentage bar chart
# The total, N, that you can then throw in the title if you like.

produce_bar_chart_with_n <- function(df, ...){
  df %<>% transform(group = reorder(group, desc(percent)))
  plot <- tufte_bar_chart(df, ybreaks = seq(.2,1,.2), x_var="group", y_var="percent", ...)
  N <- df$total[1]
  return(list(graph = plot,n=N))
}
