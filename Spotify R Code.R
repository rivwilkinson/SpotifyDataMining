#Loading libraries
library(jsonlite)   #to import json file as a data frame
library(tidyverse)
library(data.table) #to convert chr to time format

#Saved as csv once the data is finalized####
write.csv(extended, "ExtendedStreaming.csv", row.names = FALSE)

#Creating a data frame####
extended <- fromJSON("endsong_1.json")

#Getting a summary view of the data
summary(extended)


#Checking the distribution of milliseconds played for all songs
ggplot(extended, aes(x = ms_played)) +
  geom_histogram(binwidth = 1000, color = "black", fill = "lightblue") +
  ggtitle("Distribution of Songs by Milliseconds Played") +
  xlab("Milliseconds Played") +
  ylab("Number of Songs") +
  scale_x_continuous(limits = c(0, 10000), breaks = seq(0, 10000, 1000))

#Counting the number of songs that weren't played at all
count(extended, ms_played == 0)


#Checking the reasons why songs started
ggplot(extended, aes(x = factor(songstartreason, levels = c("trackdone", "backbtn", "clickrow", "fwdbtn", "appload", "playbtn", "trackerror", "remote")))) +
  geom_bar(fill = c("#03396c", "#005b96", "#6497b1", "#b3cde0", "#8cbed6", "#577590", "#0b1e2d", "#005b96")) +
  ggtitle("Reasons why a song started") +
  xlab("Reason") +
  ylab("Number of Songs") +
  scale_x_discrete() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(limits = c(0, 3000), breaks = seq(0, 3000, 500))

##DATA CLEANING & PREPARATION####
#Checking the name of the columns in the data frame
names(extended)

#Removing irrelevant columns####
extended <- extended %>% 
  select(-conn_country,-ip_addr_decrypted,-user_agent_decrypted,
         -spotify_track_uri,-episode_name,-episode_show_name,
         -spotify_episode_uri,-shuffle,-offline,-offline_timestamp,-incognito_mode)

#Splitting the endTime column into two separate columns####
split_trackstop <- str_split_fixed(extended$ts, pattern = "T", n = 2)
extended <- cbind(extended, split_trackstop)
colnames(extended)[8:9] <- c("datePlayed", "timePlayed")
extended <- subset(extended, select = -ts)

#Updating data types for new columns####
extended$dateplayed <- as.Date(extended$datePlayed, format = "%Y-%m-%d")
extended$timeplayed <- as.ITime(extended$timePlayed)

#Converting ms_played into minutes and seconds####
extended$ms_played <- as.numeric(extended$ms_played)
extended$minutesplayed <- ceiling(extended$ms_played / 60000)
extended$secondsplayed <- round((extended$ms_played %% 60000) / 1000)

#Removing ms_played since it's no longer needed####
extended <- subset(extended, select= -ms_played)

#Adding day of the week####
extended$dayOfWeek <- weekdays(as.Date(extended$datePlayed))

#Renaming columns to have the same format####
extended <- extended %>% rename(songname = master_metadata_track_name, artistname = master_metadata_album_artist_name, albumname = master_metadata_album_album_name, songstartreason = reason_start, songendreason = reason_end, weekday = dayOfWeek)


##DATA VISUALIZATION####
#Checking the date range for the data for chart title
min(extended$dateplayed)
max(extended$dateplayed)


#Plotting the number of songs played by weekday
ggplot(extended, aes(x = factor(weekday, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")))) +
  geom_bar(fill = c("#03396c", "#005b96", "#6497b1", "#b3cde0", "#8cbed6", "#577590", "#0b1e2d")) +
  ggtitle("Number of Songs Played by Day of Week (2016-2023)") +
  xlab("Day of Week") +
  ylab("Number of Songs Played") +
  scale_x_discrete() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(limits = c(0, 3000), breaks = seq(0, 3000, 500))



