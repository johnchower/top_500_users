# Function: create_underscore_version_of_name

create_underscore_version_of_name <- function(name){
  name %>%
    {gsub(" - ", "_", .)} %>%
    {gsub(" ", "_", .)} %>%
    {paste(., "users", sep = "_")}
}