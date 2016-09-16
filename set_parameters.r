# Set Parameters

max_date <- 20160909 # Filter out all data for users who joined after this date.
one_month_ago <- calculate_one_month_ago(max_date)
user_tier_cutoffs <- c(10, 50, 100, 250, 500) # Default: look at top 10, 50, 100, 250, 500 users.

# Users are ranked by one of two metrics. 
# "actions" - the most active user is the one with the most platform actions in
#   the past 28 days.
# "active_days" - the most active user is the one with the most active days in 
#   the past 28 days.
ranking_metric <- "actions"

outloc <- "~/Google Drive/Analytics_graphs/top_500_sep_26"
