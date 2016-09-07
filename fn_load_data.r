# Function: load_data
# Reads all csv files in looker.csvs and static.csvs
# Outputs a list of data frames for further manipulation.

load_data <- function(df.list=name_list,
                      looker.csvs=paste(find_root(has_file("README.md")),
                                          "looker_csvs",
                                          sep = "/"),
                      static.csvs=paste(find_root(has_file("README.md")),
                                          "static_csvs", 
                                          sep = "/")){
x <- looker.csvs %>%
  {paste(., dir(.), sep = "/")} %>%
  lapply(FUN = function(path)read.csv(path, stringsAsFactors = F)) 

y <- static.csvs %>%
  {paste(., dir(.), sep = "/")} %>%
  lapply(FUN = function(path)read.csv(path, stringsAsFactors = F))

c(x,y)
}
