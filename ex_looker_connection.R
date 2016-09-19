library(LookR)
looker_setup(id = "mz8bPyHzY7MY5JNhSmcj",
             secret = "vttZrNKZGcCyB8xyGq68qfVR",
             api_path = "https://api-looker.gloo.us/api/3.0")
look_1205 <- run_look(look_id =2160)
print(nrow(look_1205))
