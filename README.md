# Cyclistic-bike-share (Google Data Analytics Capstone Project)

## Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes 
differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

### Introduction
This is a case study on analysing bike usage pattern of different customer base of a company called 'Cyclistic'. Being the junior data analyst of the Cyclistic's marketing team, I am expected to answer key business questions and provide valuable insights and recommendations based on analysis.

### Business Problem
What is the past usage pattern of casual riders and annual members?
Should the marketing campaign be focussed on gaining new members or in converting casual riders to annual members?

### Key stakeholders
Lily Moreno (Project Manager and Director of Marketing), Cyclistic marketing analytics team, Cyclistic executive team

## R Code for Data Preparation, Processing and Analysis

### Installing and Loading Packages
install.packages('tidyverse')
install.packages('janitor')
install.packages('lubridate')
install.packages('here')

library(tidyverse)
library(lubridate)
library(here)
library(janitor)

### Loading dataframes using read_csv function  
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


### Checking the column names
colnames(trips)

### Comparing if the columns in all dataframes are same
compare_df_cols(trips_june21, trips_july21, trips_aug21, trips_sep21, trips_oct21, trips_nov21,trips_dec21, trips_jan22, 
                trips_feb22, trips_mar22, trips_apr22, trips_may22, trips_june22, return= "mismatch")

### Binding all dataframes together
trips <- bind_rows(trips_june21, trips_july21, trips_aug21, trips_sep21, trips_oct21, trips_nov21,trips_dec21, trips_jan22, 
                   trips_feb22, trips_mar22, trips_apr22, trips_may22, trips_june22)
View(trips)

### Removing fields not needed for analysis
trips <- trips %>% select(-c(start_lat, start_lng, end_lat, end_lng))

### Renaming the fields
trips <- trips %>% rename(ride_type= rideable_type , start_date_time= started_at, end_date_time= ended_at, customer_type= member_casual)

### Adding a column trip_duration
trips$trip_duration <- difftime(trips$end_date_time, trips$start_date_time, units= "mins")

### Changing the datatype of trip_duration
trips$trip_duration <- as.numeric(as.character(trips$trip_duration))

### Creating separate columns(day, month, year, weekday) from start_date_time column
trips$date <- as.Date(trips$start_date_time)

trips$day <- format((trips$date), "%d")

trips$month <- format(trips$date, "%m")

trips$year <- format(trips$date, "%Y")

trips$weekday <- weekdays(trips$date)

### Cleaning Data
trips_final <- trips %>% filter(trip_duration>0 & (end_date_time>start_date_time))

trips_final1 <- trips_final[!duplicated(trips_final$ride_id),]

View(trips_final1)

### Checking the structure of the data and descriptive statistics
glimpse(trips_final1)
str(trips_final1)
summary(trips_final1)

### Grouping and Summarising data
ride_length_by_month <- trips_final1 %>% group_by(customer_type,month)%>% summarise(number_of_rides = n(),mean_ride_length = mean(trip_duration)) %>% arrange(month)

ride_summary_by_week <- trips_final1 %>% group_by(weekday, customer_type) %>% summarise(number_of_rides = n(), mean_ride_length = mean(trip_duration))

ride_type_summary <- trips_final1 %>% group_by(ride_type, customer_type) %>% summarise(number_of_rides = n()) 

### Saving summarised data as a CSV file
write.csv(ride_length_by_month, "D:/Google Data Analytics Certification Learning/Capstone- Bike share/Extracted files/ride_length_by_month.csv", row.names= FALSE)

write.csv(ride_summary_by_week, "D:/Google Data Analytics Certification Learning/Capstone- Bike share/Extracted files/ride_summary_by_week.csv", row.names= FALSE)

write.csv(ride_type_summary, "D:/Google Data Analytics Certification Learning/Capstone- Bike share/Extracted files/ride_type_summary.csv", row.names= FALSE)

