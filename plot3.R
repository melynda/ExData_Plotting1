#begin by downloading the file and reading in the desired data

library("data.table")
library("datasets")
library("quantmod")

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
#put date and time in correct format
pwrData$Date <- as.Date(pwrData$Date, format="%d/%m/%Y")
pwrDf <- pwrData[(pwrData$Date=="2007-02-01") | (pwrData$Date=="2007-02-02"),]
pwrDf$DateTime <- paste(pwrDf$Date, pwrDf$Time, sep=" ")
pwrDf$DateTime <- strptime(pwrDf$DateTime, "%d/%m/%Y %H:%M:%S")

#convert to numeric
pwrDf$Sub_metering_1 <- as.numeric(as.character(pwrDf$Sub_metering_1))
pwrDf$Sub_metering_2 <- as.numeric(as.character(pwrDf$Sub_metering_2))
pwrDf$Sub_metering_3 <- as.numeric(as.character(pwrDf$Sub_metering_3))

#create the png file
png(filename="plot3.png", width=480, height=480, units="px", bg="transparent")

#generate the plot
plot(pwrDf$DateTime,
     pwrDf$Sub_metering_1,
     type = "l",
     main = " ", 
     ylab = "Energy sub metering", 
     xlab = " ", 
     xaxt = "n")
lines(pwrDf$Sub_metering_2, col="red")
lines(pwrDf$Sub_metering_3, col="blue")

#label x axis with specified days of the week
xpoints = c(0, 1450, 2900)
days = c("Thu", "Fri", "Sat")
axis(1, at=xpoints, labels=days)

#legend
subs <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
colors <- c("black", "red", "blue")
legend("topright", col=colors, legend=variables, lwd = 1, lty = 1)

dev.off()
