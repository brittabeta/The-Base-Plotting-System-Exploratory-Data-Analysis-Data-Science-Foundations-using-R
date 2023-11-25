# Load data table package
library("data.table") 

# as needed: dev.new()

# Download data and unzip
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

# Reads in data from file, interpret ? as NA values
powerDT <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)

# Convert Date and Time columns from character to POSIXct and format as new variable
powerDT[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Subset dateTime column for 2007-02-01 to 2007-02-02 to decrease memory usage
powerDT <- powerDT[(dateTime >= "2007-02-01") & (dateTime <= "2007-02-03")]

# Convert dateTime to weekday abbreviation
powerDT[, Day := weekdays.POSIXt(dateTime, abbreviate = TRUE)]

# Activate png device of specified width 480 pixels and height 480 pixels
png("plot4.png", width=480, height=480)

# Create location input for axis labels (seq to and from arguments)
dateRange <- c(min(powerDT[, dateTime]), max(powerDT[, dateTime]))
# [1] "2007-02-01 MST" "2007-02-03 MST"

# Create 2 x 2 panel of plots
par(mfcol = c(2, 2))

# Global_active_power plot

# Convert Global_active_power column to prevent frequency as scientific notation
powerDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

plot(x = powerDT[, dateTime]
     , y = powerDT[, Global_active_power]
     , type="l"
     , ylab="Global Active Power (kilowatts)"
     , xlab="" # don't automatically title x-axis 
     , xaxt = "n") # don't plot x-axis tick labels 

axis.POSIXct(1, at = seq(dateRange[1], dateRange[2], by = "day"), format = "%a")

# Sub_metering_1 _2 _3 plot

# Convert energy sub-metering No. 1 (in watt-hour of active energy) kitchen
powerDT[, Sub_metering_1 := lapply(.SD, as.numeric), .SDcols = c("Sub_metering_1")]
# Convert energy sub-metering No. 2 (in watt-hour of active energy) laundry room
powerDT[, Sub_metering_2 := lapply(.SD, as.numeric), .SDcols = c("Sub_metering_2")]
# Convert energy sub-metering No. 3 (in watt-hour of active energy) heat & AC
powerDT[, Sub_metering_3 := lapply(.SD, as.numeric), .SDcols = c("Sub_metering_3")]

plot(x = powerDT[, dateTime]
     , y = powerDT[, Sub_metering_1]
     , type="l"
     , col = "black"
     , ylab="" # don't automatically title y-axis 
     , xlab="" # don't automatically title x-axis 
     , xaxt = "n") # don't plot x-axis tick labels 

lines(x = powerDT[, dateTime]
      , y = powerDT[, Sub_metering_2]
      , type="l"
      , col = "red"
      , ylab="" 
      , xlab=""  
      , xaxt = "n") 

lines(x = powerDT[, dateTime]
      , y = powerDT[, Sub_metering_3]
      , type="l"
      , col = "blue"
      , ylab="" 
      , xlab="" 
      , xaxt = "n") 

# Label y-axis
title(ylab = "Energy sub metering")

# Label custom x-axis with day of the week abbreviations
axis.POSIXct(1, at = seq(dateRange[1], dateRange[2], by = "day"), format = "%a")

# Add legend
legend("topright"
       , lty = 1
       , col = c("black", "red", "blue")
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , bty = "n") # no box #

# Voltage plot

# Convert Voltage
powerDT[, Voltage := lapply(.SD, as.numeric), .SDcols = c("Voltage")]

plot(x = powerDT[, dateTime]
     , y = powerDT[, Voltage]
     , type="l"
     , ylab="Voltage"
     , xlab="datetime"
     , xaxt = "n") # don't plot x-axis tick labels 

# Label custom x-axis with day of the week abbreviations
axis.POSIXct(1, at = seq(dateRange[1], dateRange[2], by = "day"), format = "%a")

# Global_reactive_power plot

# Convert Global_reactive_power
powerDT[, Global_reactive_power := lapply(.SD, as.numeric), .SDcols = c("Global_reactive_power")]

plot(x = powerDT[, dateTime]
     , y = powerDT[, Global_reactive_power]
     , type="l"
     , ylab="Global_reactive_power"
     , xlab="datetime"
     , xaxt = "n") # don't plot x-axis tick labels 

# Label custom x-axis with day of the week abbreviations
axis.POSIXct(1, at = seq(dateRange[1], dateRange[2], by = "day"), format = "%a")

# Close png device and save plot1.png file in working directory
dev.off() # plot4.png created and available for viewing
