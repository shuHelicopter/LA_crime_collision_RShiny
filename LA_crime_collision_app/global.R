######################################################
#################### by Shu Liu ######################
############ shutel at hotmail dot com ###############
################### 08/05/2016 #######################
###### Shiny project @ NYC Data Science Academy ######
######################################################

library(DT)
library(dplyr)
library(tidyr)
library(shiny)
library(googleVis)
library(leaflet)
library(graphics)
library(plotly)
library(RColorBrewer)
library(chron)
library(wordcloud)

# Download data
load('./data/crm_cln_df.RData')
crimedf = crm_cln_df

crimedf1 <- crimedf[sample(nrow(crimedf), 2000), ]  # Limit observations selected for leaflet map due to efficieny

# Extract data for leaflet map
map_df <- crimedf1[, c('Year_occ', 'locx', 'locy', 'CrmCd.Desc', 'AREA.NAME',  'Address', 'Status.Desc')]

###### Code below about 'save' is for improving efficiency of Shiny display 
###### They are not 
#save(map_df, file = './data/data_pieces/map_df.RData')

# Bar chart for crime areas
areaTOTcount_df <- crimedf %>%
  group_by(AREA.NAME) %>%
  summarise(volume = n())

areaTOTcount_df <- areaTOTcount_df[order(areaTOTcount_df$volume),]

#save(areaTOTcount_df, file = './data/data_pieces/areaTOTcount_df.RData')

# Line chart of total cirmes changes
TOTcount_df <- crimedf %>%
  group_by(Year_occ) %>%
  summarise(volume = n())

#save(TOTcount_df, './data/data_pieces/TOTcount_df.RData')

## Calender (Will be used in th future)
#dycount_df <- crimedf %>% 
#  group_by(DATE.OCC) %>% 
#  summarise(cnt = n())

#save(dycount_df, './data/data_pieces/dycount_df.RData')

# Crimes data table 
dttable_df <- crimedf[, c('DATE.OCC', 'TIME.OCC', 'AREA.NAME', 'CrmCd.Desc', 'Status.Desc', 'Address', 'LOCATION')]


# Crimes time analysis 
timcount_df <- crimedf %>%
  group_by(Day_occ, Hour_occ) %>%
  summarise(volume = n()) %>% 
  spread(Hour_occ, volume)

timcount_df <- timcount_df[match(c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"), timcount_df$Day_occ),]
crime_time <- as.matrix(timcount_df[, -1]) ## remove day name strings and transform a data frmae to a matrix


# Crime types during different time and seasons

ts_part_df <- crimedf[, c('CrmCd.Desc', 'Month_occ', 'Hour_occ')]
ts_part_df$season <- ifelse(as.numeric(ts_part_df$Month_occ) > 4 & as.numeric(ts_part_df$Month_occ) < 11, 
                            'Hot', 'Warm')

ts_part_df$tm_period <- ifelse(ts_part_df$Hour_occ %in% c(4, 5, 6, 7), 'Early Morning', 
                               ifelse(ts_part_df$Hour_occ %in% c(8, 9, 10), 'Morning', 
                                      ifelse(ts_part_df$Hour_occ %in% c(11, 12, 13), 'Noon', 
                                             ifelse(ts_part_df$Hour_occ %in% c(14, 15, 16), 'Afternoon',
                                                    ifelse(ts_part_df$Hour_occ %in% c(17, 18, 19), 'Evening', 
                                                           ifelse(ts_part_df$Hour_occ %in% c(20, 21, 22), 'Night', 'Midnight'
                                                           )
                                                    )
                                             )
                                      )
                               )
)

ts_part_df <- ts_part_df[, c('CrmCd.Desc', 'season', 'tm_period')]
ts_part_df <- ts_part_df[!ts_part_df$CrmCd.Desc == '',]
ts_part_df$CrmCd.Desc <- gsub("([A-Za-z]+).*", "\\1", ts_part_df$CrmCd.Desc) # get the first word of the crime name for plotting wordcloud

# Show relation among crime, season and time using bar chart
crm_sen_tm_df <- ts_part_df %>%
  group_by(tm_period, season) %>%
  summarise(volume = n()) %>% 
  spread(season, volume)

crm_sen_tm_df <- crm_sen_tm_df[match(c('Early Morning', 'Morning', 'Noon', 'Afternoon', 'Evening', 'Night', 'Midnight'), crm_sen_tm_df$tm_period),]

# Show crimes in different days using bar chart
daycount_df <- crimedf %>%
  group_by(Day_occ) %>%
  summarise(volume = n()) 
daycount_df <- daycount_df[match(c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"), daycount_df$Day_occ),]
