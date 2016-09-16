drv <- dbDriver("PostgreSQL")

pass <- readline(prompt = "Enter password: ")

con <- 
  dbConnect(
    drv
    , dbname="polymer_production"
    , host="localhost"
    , port=5442
    , user="jhower"
    , password=pass
)
