# Function: calculate one month ago

calculate_one_month_ago <- function(date_num){
  date_num %>%
    as.character %>%
    as.Date(format = "%Y%m%d") %>%
    {. - 28} %>%
    as.character %>%{
      gsub("-", "", .)
    } %>%
    as.numeric
}