library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

pass <- readline(prompt = "Enter password: ")

con <- dbConnect(drv,
                 dbname="polymer_production",
                 host="localhost",
                 port=5442,
                 user="jhower",
                 password=pass)

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
