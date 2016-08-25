######################################################
#################### by Shu Liu ######################
############ shutel at hotmail dot com ###############
################### 08/05/2016 #######################
###### Shiny project @ NYC Data Science Academy ######
######################################################

library(dplyr)
library(chron) # Used for arranging time in standard format

# Input data
crimedf_11 <- read.csv('./data/data_src/LAPD_Crime_and_Collision_Raw_Data_for_2011.csv', stringsAsFactors = FALSE, header = TRUE)
crimedf_12_15 <- read.csv('./data/data_src/Crimes_2012-2015.csv', stringsAsFactors = FALSE, header = TRUE)

# A glimpse of data
ncol(crimedf_11)
ncol(crimedf_12_15)
colnames(crimedf_11)
colnames(crimedf_12_15)

#[1] "Date.Rptd"    "DR.NO"        "DATE.OCC"     "TIME.OCC"     "AREA"
#[6] "AREA.NAME"    "RD"           "Crm.Cd"       "CrmCd.Desc"   "Status"
#[11] "Status.Desc"  "Address"      "Cross.Street" "LOCATION"

# Merge data
crm_src_df <- rbind(crimedf_11, crimedf_12_15)

# Clean variables unused
crm_src_df <- crm_src_df[, !(names(crm_src_df) %in% c('Date.Rptd', 'DR.NO', 'AREA', 'Crm.Cd', 'Status', 'Cross.Street'))]
# Save data
save(crm_src_df, file = './data/crm_src_df.RData')




########## Download data ############
load('./data/crm_src_df.RData')

################# Tidy the format of time and date ###################
# Time transform
dig6 <- sprintf('%06d', crm_src_df$TIME.OCC) # Change 'TIMM.OCC' value to a 6-digit number
dig6 <- gsub('000001$', '000100', dig6) # After data checking, 1 should represent 1:00
time = sub('(\\d{2})(\\d{2})(\\d{2})', '\\2:\\3:00', dig6) # Change 'dig6' to the format '--:--:--'
crm_src_df$TIME.OCC <- chron(times = time) # Finally transformed to 'times' type of the variable 'TIME.OCC'



# Date transform
crm_src_df$DATE.OCC <- as.Date(crm_src_df$DATE.OCC, format = '%m/%d/%y') 

## Extract days, months and years from date ##
crm_src_df$Year_occ <- format(crm_src_df$DATE.OCC, '%Y')
crm_src_df$Month_occ <- format(crm_src_df$DATE.OCC, '%m')
crm_src_df$Day_occ <- format(crm_src_df$DATE.OCC, '%A')

# Extract hours from time
crm_src_df$Hour_occ <- hours(crm_src_df$TIME.OCC)

################# Clean the format of location ###################
crm_cln_df <- crm_src_df[!crm_src_df$LOCATION == '', ] # reomve observations with wrong locations or wrong areas

locxy0 <- gsub('\\(|\\)', '', crm_cln_df$LOCATION) # reomve parentheses
locxy <- unlist(lapply(locxy0, strsplit, split = ', ')) # seperate x, y

lat_indexes<-seq(1,length(locxy),2) # select latitude data
long_indexes<-seq(2,length(locxy),2) # select longitude data
locx0 <- trimws(locxy[lat_indexes]) # remove whitespace
locy0 <- trimws(locxy[long_indexes]) # remove whitesapce

crm_cln_df$locx <- as.numeric(locx0)
crm_cln_df$locy <- as.numeric(locy0)
crm_cln_df <- crm_cln_df[!(crm_cln_df$locx == 0 | crm_cln_df$locy == 0), ] # remove wrong locations (0, 0)

# Save the clean data frame
save(crm_cln_df, file = './data/crm_cln_df.RData')

# Training dataset
load('./data/crm_cln_df.RData')
crm_train_df <- crm_cln_df[sample(nrow(crm_cln_df), 10000), ]
save(crm_train_df, file = './data/crm_train_df.RData')

crmcd <- read.csv('./data/data_src/Time_Code_Description.csv')

