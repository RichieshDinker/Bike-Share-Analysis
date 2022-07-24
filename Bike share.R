## Installing and Loading Packages

install.packages('tidyverse')
install.packages('janitor')
install.packages('lubridate')
install.packages('here')

library(tidyverse)
library(lubridate)
library(here)
library(janitor)

getwd()

trips_june21 <- read_csv('Extracted files/202106-divvy-tripdata.csv')
trips_july21 <- read_csv('Extracted files/202107-divvy-tripdata.csv')
trips_aug21 <- read_csv('Extracted files/202108-divvy-tripdata.csv')
trips_sep21 <- read_csv('Extracted files/202109-divvy-tripdata.csv')
trips_oct21 <- read_csv('Extracted files/202110-divvy-tripdata.csv')
trips_nov21 <- read_csv('Extracted files/202111-divvy-tripdata.csv')
trips_dec21 <- read_csv('Extracted files/202112-divvy-tripdata.csv')
trips_jan22 <- read_csv('Extracted files/202201-divvy-tripdata.csv')
trips_feb22 <- read_csv('Extracted files/202202-divvy-tripdata.csv')
trips_mar22 <- read_csv('Extracted files/202203-divvy-tripdata.csv')
trips_apr22 <- read_csv('Extracted files/202204-divvy-tripdata.csv')
trips_may22 <- read_csv('Extracted files/202205-divvy-tripdata.csv')
trips_june22 <- read_csv('Extracted files/202206-divvy-tripdata.csv')

compare_df_cols(trips_june21, trips_july21, trips_aug21, trips_sep21, trips_oct21, trips_nov21,trips_dec21, trips_jan22, trips_feb22, trips_mar22, trips_apr22, trips_may22, trips_june22, return= "mismatch")

trips <- bind_rows(trips_june21, trips_july21, trips_aug21, trips_sep21, trips_oct21, trips_nov21,trips_dec21, trips_jan22, trips_feb22, trips_mar22, trips_apr22, trips_may22, trips_june22)
View(trips)

trips <- trips %>% select(-c(start_lat, start_lng, end_lat, end_lng))
View(trips)
colnames(trips)

trips <- trips %>% rename(ride_type= rideable_type , start_date_time= started_at, end_date_time= ended_at, customer_type= member_casual)
