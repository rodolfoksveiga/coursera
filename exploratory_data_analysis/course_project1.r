# setup environment ####
setwd('./exploratory_data_analysis/')
library(dplyr)
library(lubridate)
library(stringr)

# tidy data ####
df = 'household_power_consumption.txt' %>%
  read.table(sep = ';', header = 1, stringsAsFactors = FALSE) %>%
  filter(Date == '1/2/2007' | Date == '2/2/2007') %>%
  mutate(datetime = dmy_hms(paste(Date, Time))) %>%
  select(-c('Date', 'Time')) %>%
  mutate_if(is.character, as.numeric)

# plot 1 ####
png('plot11.png')
plot1 = hist(df$Global_active_power, main = 'Global Active Power',
             xlab = 'Global Active Power (kilowatts)', col = 'red')
dev.off()

# plot 2 ####
png('plot12.png')
plot2 = plot(df$Global_active_power ~ df$datetime, type = 'l',
             ylab = 'Global Active Power (kilowatts)', xlab = NA)
dev.off()

# plot 3 ####
png('plot13.png')
plot3 = with(df, {
  plot(Sub_metering_1 ~ datetime, type = 'l', col = 'black',
       ylab = 'Energy sub metering', xlab = NA)
  lines(Sub_metering_2 ~ datetime, col = 'red')
  lines(Sub_metering_3 ~ datetime, col = 'purple')
  legend('topright', lty = 1, col = c('black', 'red', 'purple'),
         legend = c(paste0('Sub_metering_', 1:3)))
})
dev.off()

# plot 4 ####
png('plot14.png')
par(mfrow = c(2, 2))
plot4 = with(df, {
  plot(Global_active_power ~ datetime, type = 'l', ylab = 'Global Active Power', xlab = NA)
  plot(Voltage ~ datetime, type = 'l', ylab = 'Voltage')
  plot(Sub_metering_1 ~ datetime, type = 'l', col = 'black',
       ylab = 'Energy sub metering', xlab = NA)
  lines(Sub_metering_2 ~ datetime, col = 'red')
  lines(Sub_metering_3 ~ datetime, col = 'purple')
  legend('topright', lty = 1, col = c('black', 'red', 'purple'),
         legend = c(paste0('Sub_metering_', 1:3)))
  plot(Global_reactive_power ~ datetime, type = 'l')
})
dev.off()
