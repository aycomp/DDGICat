library(RPostgreSQL)
library(DT)
library(plotly)
library(rjson)
library(pool)

pool <- dbPool(
  drv = dbDriver("PostgreSQL", max.con = 100),
  dbname = "DDGICat",
  host = "localhost",
  user = "postgres",
  password = "terlik",
  idleTimeout = 3600000
)

