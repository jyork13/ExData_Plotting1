########################################################################################################
#
# plot3.R v 0.0.1
#
#       by Jim York 09/08/2015
#
# This is a project assignment for the following course:
#
#       Coursera exdata-032: Exploratory Data Analysis (Johns Hopkins Bloomberg School of Public Health)
#                               by Roger D. Peng, PhD, Jeff Leek, PhD, Brian Caffo, PhD
#
# This program retrieves the "Individual household electric power consumption Data Set" zipped data file
# from the UC Irvine Machine Learning Repository and creates a multi-line graph from the Sub_metering variables
# plotted against the day of week for the Dates 02-01-2007 and 02-02-2007 and stores the line graph as a png file.
#
#
########################################################################################################


########################################################################################################
#
# 0) Load libraries, Retrieve dataset, unzip and read data.
#
########################################################################################################

# Load libraries ()
# packages function checks to see if package is installed and if not, installs and loads
# (got this from http://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages)
packages<-function(x){
        x<-as.character(match.call()[[2]])
        if (!require(x,character.only=TRUE)){
                install.packages(pkgs=x,repos="http://cran.r-project.org")
                require(x,character.only=TRUE)
        }
}
packages(lubridate)
packages(dplyr)

# Initialize url and directory path and set working directory
fileurl <- 'http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
initial_working_directory <- "~/../RStudio/Data Exploration"
setwd(initial_working_directory)

# Get file, unzip and set working directory to directory with unzipped files
if (!file.exists("data")){dir.create("data")} #Create data directory if it doesn't exist
if (!file.exists("./data/Dataset.zip")){
        download.file(fileurl, destfile="./data/Dataset.zip", mode='wb')
        unzip("./data/Dataset.zip", exdir = "./data")
}
setwd("./data")

# Read file into data frame
hh_power <- read.table("household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";")

########################################################################################################
#
# 1) Convert data types for dates, times and numbers and filter data by dates.
#
########################################################################################################

# Create a date/time variable
hh_power$DateTime <- dmy_hms(paste(hh_power$Date, hh_power$Time))

# Convert chracter date to POSIXct using dmy function from lubridate
hh_power$Date <- dmy(hh_power$Date)

# Filter on dates of interest
hh_power.f <- filter(hh_power, Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))

# Convert Sub_metering variables from character to numeric
hh_power.f$Sub_metering_1 <- as.numeric(hh_power.f$Sub_metering_1)
hh_power.f$Sub_metering_2 <- as.numeric(hh_power.f$Sub_metering_2)
hh_power.f$Sub_metering_3 <- as.numeric(hh_power.f$Sub_metering_3)


########################################################################################################
#
# 2) Create line plot to view on screen and verify it's what we want
#
########################################################################################################

# Plot
with(hh_power.f, plot(DateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="", width=480, units="p"))
with(hh_power.f, lines(DateTime, Sub_metering_2, type="l", col="red"))
with(hh_power.f, lines(DateTime, Sub_metering_3, type="l", col="blue"))
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1))

########################################################################################################
#
# 3) Open png file graphics device, create plot, then close device (saving file).
#
########################################################################################################

# Open PNG device; create 'plot3.png' in my working directory
png(filename = "plot3.png", width=480,height=480)

# Create plot and send to a file (no plot appears on screen)
with(hh_power.f, plot(DateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="", width=480, units="p"))
with(hh_power.f, lines(DateTime, Sub_metering_2, type="l", col="red"))
with(hh_power.f, lines(DateTime, Sub_metering_3, type="l", col="blue"))
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1))

## Close the PNG file device
dev.off()
