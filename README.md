## Cyclistic-bike-share (Google Data Analytics Capstone Project)

### Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

### Introduction
This is a case study on analysing bike usage pattern of different customer base of a company called 'Cyclistic'. Being the junior data analyst of the Cyclistic's marketing team, I am expected to answer key business questions and provide valuable insights and recommendations based on analysis.

### Business Problem
What is the past usage pattern of casual riders and annual members?
Should the marketing campaign be focussed on gaining new members or in converting casual riders to annual members?

### Key stakeholders
Lily Moreno (Project Manager and Director of Marketing), Cyclistic marketing analytics team, Cyclistic executive team

### Data Background
The data has been made available by Motivate International Inc..The data is downloaded from this link- [Cyclistic Dataset](https://divvy-tripdata.s3.amazonaws.com/index.html) for 12 month period (June 2021 - May 2022).

## R Code for Data Preparation, Processing and Analysis
### Installing and loading packages
```{r Installing and Loading Packages}
install.packages('tidyverse')
install.packages('janitor')
install.packages('lubridate')
install.packages('here')
library(tidyverse)
library(lubridate)
library(here)
library(janitor)
```

### Loading dataframes using read_csv function  
```{r Loading dataframes using read_csv function}
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
```

### Checking Data and comparing the column names in all dataframes
```{r Checking and comparing Column names}
summary(trips_june21)
glimpse(trips_june21)
str(trips_june21)

summary(trips_july21)
glimpse(trips_july21)
str(trips_july21)

summary(trips_aug21)
glimpse(trips_aug21)
str(trips_aug21)

summary(trips_sep21)
glimpse(trips_sep21)
str(trips_sep21)

summary(trips_oct21)
glimpse(trips_oct21)
str(trips_oct21)

summary(trips_nov21)
glimpse(trips_nov21)
str(trips_nov21)

summary(trips_dec21)
glimpse(trips_dec21)
str(trips_dec21)

summary(trips_jan22)
glimpse(trips_jan22)
str(trips_jan22)

summary(trips_feb22)
glimpse(trips_feb22)
str(trips_feb22)

summary(trips_mar22)
glimpse(trips_mar22)
str(trips_mar22)

summary(trips_apr22)
glimpse(trips_apr22)
str(trips_apr22)

summary(trips_may22)
glimpse(trips_may22)
str(trips_may22)

compare_df_cols(trips_june21, trips_july21, trips_aug21, trips_sep21, trips_oct21, trips_nov21,trips_dec21, trips_jan22, trips_feb22, trips_mar22, trips_apr22, trips_may22, trips_june22, return= "mismatch")
```

### Combining all dataframes together
```{r Binding dataframes}
trips <- bind_rows(trips_june21, trips_july21, trips_aug21, trips_sep21, trips_oct21, trips_nov21,trips_dec21, trips_jan22, trips_feb22, trips_mar22, trips_apr22, trips_may22, trips_june22)
colnames(trips)
View(trips)
```

### Removing fields not needed for analysis
```{r Removing Columns}
trips <- trips %>% select(-c(start_lat, start_lng, end_lat, end_lng))
```

### Renaming the fields
```{r Renaming Columns}
trips <- trips %>% rename(ride_type= rideable_type , start_date_time= started_at, end_date_time= ended_at, customer_type= member_casual)
```

### Creating a column 'trip_duration'
```{r Creating Column}
trips$trip_duration <- difftime(trips$end_date_time, trips$start_date_time, units= "mins")
```

### Changing the datatype of 'trip_duration'
```{r Changing datatype}
trips$trip_duration <- as.numeric(as.character(trips$trip_duration))
```

### Creating separate columns(day, month, year, weekday) from 'start_date_time' column
```{r Creating day, month, year, weekday columns}
trips$date <- as.Date(trips$start_date_time)
trips$day <- format((trips$date), "%d")
trips$month <- format(trips$date, "%m")
trips$year <- format(trips$date, "%Y")
trips$weekday <- weekdays(trips$date)
```

### Cleaning Data
```{r Data Cleaning}
trips_final <- trips %>% filter(trip_duration>0 & (end_date_time>start_date_time))
trips_final1 <- trips_final[!duplicated(trips_final$ride_id),]
View(trips_final1)
```

### Checking the structure of the cleaned data
```{r Descriptive Statistics}
glimpse(trips_final1)
str(trips_final1)
summary(trips_final1)
```

### Grouping and Summarising data
```{r Summarizing data by month}
ride_length_by_month <- trips_final1 %>% group_by(customer_type,month)%>% summarise(number_of_rides = n(),mean_ride_length = mean(trip_duration)) %>% arrange(month)
write.csv(ride_length_by_month, "D:/Google Data Analytics Certification Learning/Capstone- Bike share/Extracted files/ride_length_by_month.csv", row.names= FALSE)
```
![Monthly Ride Count](https://user-images.githubusercontent.com/107660678/181787606-a966c7cf-fc2d-442d-8210-9e64044fe408.png)
![Monthly Ride Duration](https://user-images.githubusercontent.com/107660678/181789045-5ed9a858-d062-4361-9536-0e171bf29814.png)

```{r Summarizing data by week}
ride_summary_by_week <- trips_final1 %>% group_by(weekday, customer_type) %>% summarise(number_of_rides = n(), mean_ride_length = mean(trip_duration))
write.csv(ride_summary_by_week, "D:/Google Data Analytics Certification Learning/Capstone- Bike share/Extracted files/ride_summary_by_week.csv", row.names= FALSE)
```
![Weekly Ride Count](https://user-images.githubusercontent.com/107660678/181789106-615f98b3-ac33-43a4-90f3-96771f3ca45c.png)

```{r Ride Type}
ride_type_summary <- trips_final1 %>% group_by(ride_type, customer_type) %>% summarise(number_of_rides = n()) 
write.csv(ride_type_summary, "D:/Google Data Analytics Certification Learning/Capstone- Bike share/Extracted files/ride_type_summary.csv", row.names= FALSE)
```
![Ride Type Preference](https://user-images.githubusercontent.com/107660678/181789151-2685e36a-cbeb-41a2-b870-78fe5ee4b960.png)

![Member Vs Casual](https://user-images.githubusercontent.com/107660678/181789242-e13af285-f575-4a1f-8233-5b6aff14c020.png)

## Dashboard
![Bike share Analysis Dashboard](https://user-images.githubusercontent.com/107660678/181829197-9af8372a-a3ee-4ce0-b3d6-2702aadb1f96.png)

Note: For better worksheet and dashboard experience, check my Tableau Public profile for the visualization -  [Click Here](https://public.tableau.com/app/profile/richiesh.dinker/viz/BikeShareAnalysisDashboardGoogleDataAnalyticsCapstone/BikeshareAnalysisDashboard)

### Findings and Conclusion
Out of the total number of Bike users, 56% are annual members whereas apprimately 44% are casual users, which is still a bigger number not subscribing for memberships.

The number of rides for annual members is more for almost three quarters (from Sept 2021- May 2022) and only during the summer months of June, July and August, the number of rides is more for casual riders. These annual members might be chicagoians who are using the bikes for regular commutes to office. On the other hand, casual riders might be tourists using the services during summers. 

Also analysing number of rides weekly through the graph above, the number spikes up on weekends for casual riders whereas, there is a slight drop for annual members during weekends,  which makes sense considering the scenario thought of in the previous point.

When it comes to bike type, classic bike is the obvous and the most prominent option for both annual aswell as casual users. Next comes the electic bike whereas docked bike is not at all the choice for annual members.  

### Recommendations






