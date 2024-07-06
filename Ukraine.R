# Credit https://www.kaggle.com/datasets/jpmiller/conflict-in-ukraine?resource=download
install.packages("tidyverse")
install.packages("sf")
install.packages("mapview")
install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")
install.packages("raster")

library(tidyverse)
library(sf)
library(mapview)
library(ggplot2)
library(readr)
library(dplyr)
library(raster)

Sys.setlocale("LC_ALL", "English_United States.1252")
Sys.getlocale()

data <- read_csv("Ukraine.csv")
head(data, 10)

data$event_date <- as.Date(data$event_date, format = "%d %B %Y")

fatalities_data <- data %>%  
  dplyr::select(event_date, fatalities)

fatalities_by_date_data <- fatalities_data %>% 
  dplyr::group_by(event_date) %>% 
  dplyr::summarise(total_fatalities = sum(fatalities, na.rm = TRUE))

tf <- fatalities_by_date_data$total_fatalities
ggplot(data=fatalities_by_date_data) +
  geom_point(mapping=aes(x=event_date, y=total_fatalities)) +
  labs(title = "Fatalities in Ukraine from 2019-07-16 to 2022-07-15 per day",
       caption=paste('average:',round(mean(tf),digits=2),                                                                                          'min:',min(tf),'max:',max(tf)),
       x = 'time', y = 'fatalities')

fatalities_by_date_filtered_data <- fatalities_by_date_data %>% 
  filter(event_date >= as.Date('2022-02-24'))

tf <- fatalities_by_date_filtered_data$total_fatalities
ggplot(fatalities_by_date_filtered_data) +
  geom_point(mapping=aes(x=event_date, y=total_fatalities)) +
  labs(title = "Fatalities in Ukraine from 2022-02-24 to 2022-07-15 per day",
       caption=paste('average:',round(mean(tf),digits=2),
                      'min:',min(tf),'max:',max(tf)),
       x = 'time', y = 'fatalities')

ggplot(data) + 
  geom_bar(mapping=aes(x=event_type, fill = sub_event_type)) +
  theme(axis.text.x = element_text(angle=90)) +
  labs(title = "Fatalities in Ukraine from 2019-07-16 to 2022-07-15 by event")

ggplot(data) + 
  geom_histogram(mapping=aes(x=fatalities)) +
  labs(title = "Fatalities in Ukraine from 2019-07-16 to 2022-07-15 by event", x = 'fatalities',)

ggplot(fatalities_by_date_filtered_data) + 
  geom_histogram(mapping=aes(x=total_fatalities)) +
  labs(title = "Fatalities in Ukraine from 2022-02-24 to 2022-07-15 per day", x = 'fatalities')


filtered_data <- data %>% 
  filter(event_date >= as.Date('2022-02-24'))
ggplot(filtered_data) + 
  geom_bar(mapping=aes(x=event_type, fill = sub_event_type)) +
  theme(axis.text.x = element_text(angle=90)) +
  labs(title = "Fatalities in Ukraine from 2022-02-24 to 2022-07-15")


fatalities_map <- st_as_sf(data, coords = c("longitude", "latitude"), crs = 4326)
mapview(fatalities_map , cex = 3, col.regions = "red")

max_fatalities <- max(data$fatalities)
print("The event with the most death:")
print(note_max_fatalities <- data$notes[which.max(data$fatalities)])