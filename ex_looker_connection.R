library(LookR)
looker_setup(id = "mz8bPyHzY7MY5JNhSmcj",
             secret = "vttZrNKZGcCyB8xyGq68qfVR",
             api_path = "https://api-looker.gloo.us/api/3.0")

user_connected_to_champion <- run_inline_query(model = "gloo",
                 view = "user_platform_action_facts",
                 fields = c("user_dimensions.id",
                          "user_connected_to_champion_dimensions.id"),
                 filters = list(c("user_dimensions.id", "24"))) %>%
  rename(user_id = user_dimensions.id,
         connected_to_champion = user_connected_to_champion_dimensions.id) %>%
  melt(id.vars = "user_id")
head(query_1)

