# Master Script

# Libraries and functions
library(rprojroot)
library(dplyr)

source('fn_create_convex_data.R')
source('fn_produce_triangle_diagram_data.R')
source('fn_plot_triangle_diagram.R')
source('fn_calculate_one_month_ago.R')

# Parameters

max_date <- 20160801 # Filter out all data for users who joined after this date.
one_month_ago <- max_date %>%
  calculate_one_month_ago

user_tier_cutoffs <- c(10, 50, 100, 250, 500) # Default: look at top 500, 250, 100, 50 and 10 users.

# Load data, clean it up, and manipulate it into formats for triangle diagram ####
source('load_data.R')
source('fix_guest_account_conversions.R')
source('filter_fake_and_nonexistent_users.R')
triangle_diagram_data <- produce_triangle_diagram_data()

# Define user subsets
all_users <- user_createddate_champid %>%
  {.$user_id} %>%
  unique

# Find the most active users


  
