########################################################################################################
#
# plot4.R v 0.0.2
#
#       by Jim York 09/08/2015
#
# This is a project assignment for the following course:
#
#       Coursera exdata-032: Exploratory Data Analysis (Johns Hopkins Bloomberg School of Public Health)
#                               by Roger D. Peng, PhD, Jeff Leek, PhD, Brian Caffo, PhD
#
# This program retrieves the "Individual household electric power consumption Data Set" zipped data file
# from the UC Irvine Machine Learning Repository and creates a 2 x 2 matrix of plots of various data
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
hh_power.f$Global_active_power <- as.numeric(hh_power.f$Global_active_power)
hh_power.f$Global_reactive_power <- as.numeric(hh_power.f$Global_reactive_power)
hh_power.f$Voltage <- as.numeric(hh_power.f$Voltage)


########################################################################################################
#
# 2) Create a plot function and then execute function to view on screen and verify it's what we want
#
########################################################################################################

# Function to create the four plots
create_plots <- function(){
        
        # Setup for 4 plot grid and set margins
        par(mfrow = c(2, 2), mar = c(5, 4, 2, 2), oma = c(2, 2, 2, 2))
        
        # Plot 1 - Global Active Power
        with(hh_power.f, plot(DateTime, Global_active_power, type="n", ylab="Global Active Power", xlab=""))
        with(hh_power.f, lines(DateTime, Global_active_power, type="l"))
        
        # Plot 2 - Voltage
        with(hh_power.f, plot(DateTime, Voltage, type="n", ylab="Voltage", xlab="datetime"))
        with(hh_power.f, lines(DateTime, Voltage, type="l"))
        
        # Plot 3 - Energy sub metering
        with(hh_power.f, plot(DateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab=""))
        with(hh_power.f, lines(DateTime, Sub_metering_2, type="l", col="red"))
        with(hh_power.f, lines(DateTime, Sub_metering_3, type="l", col="blue"))
        legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               lty=c(1,1,1), bty = "n", cex=0.8) #lty puts lines in legend, cex changes legend font size
        
        # Plot 4 - Global Reactive Power
        with(hh_power.f, plot(DateTime, Global_reactive_power, type="n", ylab="Global_reactive_power", xlab="datetime"))
        with(hh_power.f, lines(DateTime, Global_reactive_power, type="l"))
}
# Display plots on screen to verify
create_plots()
########################################################################################################
#
# 3) Open png file graphics device, create plot, then close device (saving file).
#
########################################################################################################

# Open PNG device; create 'plot4.png' in my working directory
png(filename = "plot4.png", width=480,height=480)

# Create plot and send to a file (no plot appears on screen)
create_plots()

## Close the PNG file device
dev.off()
