# SpotifyDataMining
This project aims to extract insights from my personal Spotify streaming history data using R. The data was originally in JSON format and contained 21 variables and 16,693 observations. I used the jsonlite library to import the data as a data frame and then performed data cleaning and preparation, including removing irrelevant columns, splitting the endTime column into separate date and time columns, and converting the ms_played variable into minutes and seconds.

I also created visualizations using ggplot2 to analyze the distribution of milliseconds played for all songs, the reasons why songs started, and the number of songs played by day of the week. Additionally, I used machine learning techniques to explore the data further and extract meaningful insights.

This project is still in progress, and I plan to continue exploring the data using more advanced machine learning algorithms to uncover patterns and relationships between the variables.
