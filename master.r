# Master Script

# This script loads all the data, functions, and libraries that are required for
# further analysis.

# Libraries and functions ####
library(rprojroot)
library(plyr)
library(dplyr)
library(magrittr)
library(plotly)
library(htmlwidgets)

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
source('fn_produce_cohort_breakdown_graph_data.R')
source('fn_graph_user_cohort_breakdown.r')
source('fn_save_or_print.r')

# Parameters ####

max_date <- 20160831 # Filter out all data for users who joined after this date.
one_month_ago <- calculate_one_month_ago(max_date)

user_tier_cutoffs <- c(10, 50, 100, 250, 500) # Default: look at top 10, 50, 100, 250, 500 users.

# Users are ranked by one of two metrics. 
# "actions" - the most active user is the one with the most platform actions in
#   the past 28 days.
# "active_days" - the most active user is the one with the most active days in 
#   the past 28 days.
ranking_metric <- "actions"

# Load data, clean it up, and manipulate it into required formats for plots later ####
source('load_data.R')
source('fix_guest_account_conversions.R')
source('filter_fake_and_nonexistent_users.R')

triangle_diagram_data <- produce_triangle_diagram_data()

user_platform_action_date_group <- user_platform_action_facts %>%
  left_join(select(platform_action_facts, platform_action, group))

user_to_cohort_bridges %<>% 
  filter(created_date_id <= max_date)

source('assign_cohort_groups.r')

# Define user subsets ####
all_users <- user_createddate_champid %>%
  {.$user_id} %>%
  unique

source('find_top_users.R')

# Clean up ####
# rm(x, y,
#    assign_by_colnames,
#    assign_by_colnames_listversion,
#    create_convex_data,
#    produce_triangle_diagram_data,
#    filter_user_ids,
#    find_top_n_users,
#    )
