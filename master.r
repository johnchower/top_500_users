# Master Script

# Libraries
library(rprojroot)
library(dplyr)

max_date <- 20160801

source('load_data.R')
source('fix_guest_account_conversions.R')
source('filter_fake_and_nonexistent_users.R')


