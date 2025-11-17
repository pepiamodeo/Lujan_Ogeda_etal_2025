
rm(list=ls())

library(lubridate)
library(stringr)

# ========================================
# DATA LOAD
# ========================================

data <- read.csv2("./data/data.csv")

# ========================================
# FORMAT VARIABLES
# ========================================

data$date <- as.Date(data$date, format = "%Y-%m-%d")
data$sampling_day <- yday(data$date)
data$id_lizard <- as.factor(data$id_lizard)
data$site_id <- paste(data$site,data$id_lizard,sep="_") 
data$site_id <- as.factor(data$site_id)

