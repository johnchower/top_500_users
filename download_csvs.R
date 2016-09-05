# Download csvs:
# This script uses LookR to download all csv files necessary for the
# top_500_user analysis  

# Load libraries and functions

library("devtools")
install_github("looker/lookr")	
  
library(LookR)
library(dplyr)

# Read in arguments
# input.args <- commandArgs(trailingOnly = T)
client.id <- input.args[1]
client.secret <- input.args[2]

looker_setup(
  id = client.id,
  secret = client.secret,
  api_path = "https://api-looker.gloo.us/api/3.0"
)

my.look <- run_look(look_id = 1748,limit = NULL) %>%
  unique
nrow(my.look)





