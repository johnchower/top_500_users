# Master Script

# Libraries and functions
library(rprojroot)
library(dplyr)

source('fn_create_convex_data.R')
source('fn_produce_triangle_diagram_data.R')
source('fn_plot_triangle_diagram.R')

# Parameters

max_date <- 20160801 # Filter out all data for users who joined after this date.

# Load data and clean it up ####
source('load_data.R')
source('fix_guest_account_conversions.R')
source('filter_fake_and_nonexistent_users.R')

# Define user subsets
all_users <- user_createddate_champid %>%
  {.$user_id} %>%
  unique


  
