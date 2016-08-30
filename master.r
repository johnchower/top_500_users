# Master Script

# Libraries
library(rprojroot)
library(dplyr)

max_date <- 20160801

# Load data and clean it up ####
source('load_data.R')
source('fix_guest_account_conversions.R')
source('filter_fake_and_nonexistent_users.R')

source('fn_create_convex_data.R')
source('fn_produce_triangle_diagram_data.R')

produce_triangle_diagram_data()
  
