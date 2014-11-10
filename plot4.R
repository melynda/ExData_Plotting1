
library("quantmod")
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
pwrData <- read.table(textFile, header=TRUE, sep=";", na.strings=c("NA", "?"), stringsAsFactors=FALSE)

#create a data frame for the data from the specified dates
#put date and time in correct format
pwrDf <- pwrData[(pwrData$Date=="1/2/2007") | (pwrData$Date=="2/2/2007"),]
pwrData$Date <- as.Date(pwrData$Date, format="%d/%m/%Y")
pwrDf$DateTime <- paste(pwrDf$Date, pwrDf$Time, sep=" ")
pwrDf$DateTime <- strptime(pwrDf$DateTime, "%d/%m/%Y %H:%M:%S")
dateTime <- pwrDf$DateTime

#convert to numeric
activePower <- as.numeric(as.character(pwrDf$Global_active_power))
reactivePower <- as.numeric(as.character(pwrDf$Global_reactive_power))
voltage <- as.numeric(as.character(pwrDf$Voltage))
subMetering1 <- as.numeric(as.character(pwrDf$Sub_metering_1))
subMetering2 <- as.numeric(as.character(pwrDf$Sub_metering_2))
subMetering3 <- as.numeric(as.character(pwrDf$Sub_metering_3))

#create the png file
png(filename="plot4.png", width = 480, height = 480, units="px")
par(mfrow=c(2,2))

#generate the plots
plot(dateTime,
    activePower,
     type = "l", 
     ylab = "Global Active Power (kilowatts)", 
     xlab = "",
     col = "black",
     main = " ")

plot(dateTime, 
     voltage,
     type="l",
     ylab="Voltage",
     xlab="datetime",
     col="black",
     main=" ")

plot(dateTime,
     subMetering1,
     type = "l",
     ylab = "Energy sub metering", 
     xlab = "",
     main = " ")
lines(dateTime, subMetering2, col="red")
lines(dateTime, subMetering3, col="blue")
#legend
subs <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
colors <- c("black", "red", "blue")
legend("topright", col=colors, legend=subs, lwd = 1, lty = 1)

plot(dateTime,
     reactivePower,
     type="l",
     ylab="Global_reactive_power",
     xlab="datetime",
     col="black",
     main="")

dev.off()