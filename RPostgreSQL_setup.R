library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

pass <- get_password()

con <- 
  dbConnect(
    drv
    , dbname="polymer_production"
    , host="localhost"
    , port=5442
    , user="jhower"
    , password="your password"
)

champions <- dbReadTable(con, "champions")

champions_queried <- 
  dbGetQuery(con, 
    "
    /* Put SQL query below*/
    select id, name 
    from champions
    where id=10;
    "
)
