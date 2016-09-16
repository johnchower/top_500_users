tufte_bar_chart <- function(df,
                            ybreaks,
                            x_var, y_var,
                            ...){
  df %>%
    ggplot(aes_string(x=x_var, y=y_var)) +
      theme_tufte(base_size = 14, ticks = F) +
      geom_bar(fill = "gray", stat = "identity", width=.25) +
      scale_y_continuous(breaks=ybreaks,...) +
      geom_hline(yintercept=ybreaks, col="white", lwd=1) +
      theme(axis.title = element_blank())
} 
