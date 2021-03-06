#begin by downloading the file and reading in the desired data

#note that reading in the entire file would take approximately 149 MB of memory
#each cell takes 8 bytes of memory, so 2,075,259 rows times 9 columns times 8 bytes
#equals approximately 149 MB

library("data.table")
library("datasets")

#download and unzip the file
zipFile <- "exdata-data-household_power_consumption.zip"
textFile <- "./power/household_power_consumption.txt"
if (!file.exists(textFile)) {
    localFile <- tempfile()
    print("downloading zip file")
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", localFile)
    print("unzipping file")
    unzip(localFile, overwrite="T", exdir = "power")
}

#read the txt file
pwrData <- read.table(textFile, header=TRUE, sep=";", na.strings="?", stringsAsFactors=FALSE)

#create a data frame for the data from the specified dates
#puts date and time in correct format
pwrData$Date <- as.Date(pwrData$Date, format="%d/%m/%Y")
pwrDf <- pwrData[(pwrData$Date=="2007-02-01") | (pwrData$Date=="2007-02-02"),]
pwrDf$Time <- strptime(pwrDf$Time, format="%H:%M:%S")

#convert to numeric
activePower <- as.numeric(as.character(pwrDf$Global_active_power))

#create the png file
png(filename="plot1.png", width=480, height=480, units="px", bg="transparent")

#generate the plot
hist(activePower, 
     main = "Global Active Power", 
     ylab = "Frequency", 
     xlab = "Global Active Power (kilowatts)", 
     col = "red",
     breaks = 12,
     ylim = c(0, 1200)) 

dev.off()
