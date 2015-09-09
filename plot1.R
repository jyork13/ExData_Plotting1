########################################################################################################
#
# plot1.R v 0.0.1
#
#       by Jim York 09/08/2015
#
# This is a project assignment for the following course:
#
#       Coursera exdata-032: Exploratory Data Analysis (Johns Hopkins Bloomberg School of Public Health)
#                               by Roger D. Peng, PhD, Jeff Leek, PhD, Brian Caffo, PhD
#
# This program retrieves the "Individual household electric power consumption Data Set" zipped data file
# from the UC Irvine Machine Learning Repository and creates a histogram from the Global Active Power variable
# for the Dates 02-01-2007 and 02-02-2007 and stores the histogram as a png file.
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

# Convert chracter date to POSIXct using dmy function from lubridate
hh_power$Date <- dmy(hh_power$Date)

# Filter on dates of interest
hh_power.f <- filter(hh_power, Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))

# Convert Global_active_power from character to numeric
hh_power.f$Global_active_power <- as.numeric(hh_power.f$Global_active_power)

########################################################################################################
#
# 2) Create histogram to view on screen and verify it's what we want
#
########################################################################################################

# Plot histogram
hist(hh_power.f$Global_active_power, col=2, xlab="Global Active Power (kilowatts)", main="Global Active Power")

########################################################################################################
#
# 3) Open png file graphics device, create plot, then close device (saving file).
#
########################################################################################################

# Open PNG device; create 'plot1.png' in my working directory
png(filename = "plot1.png")

# Create plot and send to a file (no plot appears on screen)
hist(hh_power.f$Global_active_power, col=2, xlab="Global Active Power (kilowatts)", main="Global Active Power")

## Close the PNG file device
dev.off()











