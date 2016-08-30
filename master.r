# Master Script

# Libraries and functions ####
library(rprojroot)
library(plyr)
library(dplyr)
library(magrittr)
library(plotly)

source('fn_create_convex_data.R')
source('fn_produce_triangle_diagram_data.R')
source('fn_plot_triangle_diagram.R')
source('fn_calculate_one_month_ago.R')
source('fn_find_top_n_users.R')
source('fn_chisquare_analysis.R')
source('fn_create_chisquare_plots.R')
source('fn_produce_chisquare_plot_data.r')
source('fn_prep_user_platform_action_data_for_chisquare_analysis.R')
source('fn_bar_chart_layout.r')

# Parameters ####

max_date <- 20160801 # Filter out all data for users who joined after this date.
one_month_ago <- calculate_one_month_ago(max_date)

user_tier_cutoffs <- c(10, 50, 100, 250, 500) # Default: look at top 10, 50, 100, 250, 500 users.

# Load data, clean it up, and manipulate it into formats for triangle diagram ####
source('load_data.R')
source('fix_guest_account_conversions.R')
source('filter_fake_and_nonexistent_users.R')
triangle_diagram_data <- produce_triangle_diagram_data()
user_platform_action_date_group <- user_platform_action_facts %>%
  left_join(select(platform_action_facts, platform_action, group))

# Define user subsets ####
all_users <- user_createddate_champid %>%
  {.$user_id} %>%
  unique

source('find_top_users.R')

# 

plot.data <- prep_user_platform_action_data_for_chisquare_analysis(user_set = top_10_users) %>% 
  chisquare_analysis %>%
  {.$results} %>%
  produce_chisquare_plot_data 

plot.data %>% 
  create_chisquare_plots(pthresh = .01)