# Load data table package
library("data.table") 
# alternative: library(dplyr)... see below

# Download data and unzip
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

# Reads in data from file, interpret ? as NA values
powerDT <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)

# Handle .SD and data types see below

# Convert Global_active_power column to prevent frequency as scientific notation
powerDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Convert Date column from character to date and format as "YYYY-MM-DD" 
powerDT[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# Subset Date column for 2007-02-01 to 2007-02-02 to decrease memory usage
powerDT <- powerDT[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

# Activate png device of specified width 480 pixels and height 480 pixels
png("plot1.png", width=480, height=480)

## Plot 1: Construct per course project example
hist(powerDT[, Global_active_power], main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", col="red")

# Close png device and save plot1.png file in working directory
dev.off() # plot1.png created and available for viewing

# Note:
# .SD = special symbol data in data.table "Subset of Data"
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-sd-usage.html
# Issue: results in printing of scientific notation
# Solution: handle .SD by converting data types
# Contributors: Roger Peng & Michael Galarnyk

# Alternative: library(dplyr)
# powerDT <- read.table("household_power_consumption.txt", sep=";", header=TRUE, as.is=TRUE, na.strings = "?")
# powerDT$DateTime <- paste(DT$Date, DT$Time)
# powerDT$DateTime <- strptime(DT$DateTime, format="%d/%m/%Y %H:%M:%S")
# powerDT <- filter(DT, DateTime >= "2007-02-01" & DateTime <= "2007-02-03")
# plot(DT$DateTime, DT$Global_active_power, type="l") 