# Load data table package
library("data.table")
# alternative: library(dplyr)... see below

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

# Handle .SD and data types (see plot1.R)

# Convert Global_active_power column to prevent frequency as scientific notation
powerDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Convert Date and Time columns from character to POSIXct and format as new variable
powerDT[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Subset dateTime column for 2007-02-01 to 2007-02-02 to decrease memory usage
powerDT <- powerDT[(dateTime >= "2007-02-01") & (dateTime <= "2007-02-03")]

# Convert dateTime to weekday abbreviation
powerDT[, Day := weekdays.POSIXt(dateTime, abbreviate = TRUE)]

# Activate png device of specified width 480 pixels and height 480 pixels
png("plot2.png", width=480, height=480)

## Plot 2: Construct per course project example

# Create location input for axis labels (seq to and from arguments)
dateRange <- c(min(powerDT[, dateTime]), max(powerDT[, dateTime]))
# [1] "2007-02-01 MST" "2007-02-03 MST"

# Plot with dateTime to obtain continuous variable 
# with axis label suppression (see below for resource)
plot(x = powerDT[, dateTime]
     , y = powerDT[, Global_active_power]
     , type="l"
     , ylab="Global Active Power (kilowatts)"
     , xlab="" # don't automatically title x-axis 
     , xaxt = "n") # don't plot x-axis tick labels 

# Label custom x-axis with day of the week abbreviations
axis.POSIXct(1, at = seq(dateRange[1], dateRange[2], by = "day"), format = "%a")

# Close png device and save plot1.png file in working directory
dev.off() # plot2.png created and available for viewing

# Note: axis.POSIXct and Thu, Fri, Sat
# example: https://personality-project.org/r/r.plottingdates.html
# Issue: specify x-axis or y-axis tick labels with date and or datetime
# Solution: axis.POSIXct or axis.Date (see documentation)
# Contributors: Roger Peng, William Revelle & Michael Galarnyk

# Alternative: library(dplyr)
# powerDT <- read.table("household_power_consumption.txt", sep=";", header=TRUE, as.is=TRUE, na.strings = "?")
# powerDT$DateTime <- paste(DT$Date, DT$Time)
# powerDT$DateTime <- strptime(DT$DateTime, format="%d/%m/%Y %H:%M:%S")
# powerDT <- filter(DT, DateTime >= "2007-02-01" & DateTime <= "2007-02-03")
# plot(DT$DateTime, DT$Global_active_power, type="l") 