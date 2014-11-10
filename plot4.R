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
#put date and time in correct format
pwrData$Date <- as.Date(pwrData$Date, format="%d/%m/%Y")
pwrData$DateTime <- strptime(paste(pwrData$Date, pwrData$Time), "%d/%m/%Y %H:%M:%S")
pwrDf <- pwrData[(pwrData$Date=="2007-02-01") | (pwrData$Date=="2007-02-02"),]

#convert to numeric
activePower <- as.numeric(as.character(pwrDf$Global_active_power))
reactivePower <- as.numeric(as.character(pwrDf$Global_reactive_power))
voltage <- as.numeric(as.character(pwrDf$Voltage))
subMetering1 <- as.numeric(as.character(pwrDf$Sub_metering_1))
subMetering2 <- as.numeric(as.character(pwrDf$Sub_metering_2))
subMetering3 <- as.numeric(as.character(pwrDf$Sub_metering_3))

#create the png file
png(filename="plot4.png", width=480, height=480, units="px", bg="transparent")

#generate the plot
plot(pwrData$DateTime,
    activePower,
     type = "l", 
     ylab = "Global Active Power (kilowatts)", 
     xlab = "",
     col = "black",
     main = " ")

plot(pwrData$DateTime,
     subMetering1,
     type = "l",
     ylab = "Energy sub metering", 
     xlab = "",
     main = " ")
lines(pwrData$DateTime, subMetering2, col="red")
lines(pwrData$DateTime, subMetering3, col="blue")
#legend
subs <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
colors <- c("black", "red", "blue")
legend("topright", col=colors, legend=variables, lwd = 1, lty = 1)

plot(pwrData$DateTime, 
     voltage,
     type="l",
     ylab="Voltage",
     xlab="datetime",
     col="black",
     main=" ")

plot(pwrData$DateTime,
     reactivePower,
     type="l",
     ylab="Global_reactive_power",
     xlab="datetime",
     col="black",
     main="")

dev.off()