if(!file.exists("./PM25.zip")){
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile="./PM25.zip", method="curl")
unzip(zipfile="./PM25.zip", exdir="./")
}

if(!file.exists("summarySCC_PM25.rds") || !file.exists("Source_Classification_Code.rds")){
unzip(zipfile="./PM25.zip", exdir="./")
}

##read data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Q1: Have total emissions from PM2.5 decreased in the United States from 1999 
#to 2008? Using the base plotting system, make a plot showing the total PM2.5 
#emission from all sources for each of the years 1999, 2002, 2005, and 2008.

total_PM25 <- tapply(NEI$Emissions, NEI$year, sum)

png(filename="./plot1.png", width=680,height=480,units="px")
plot(names(total_PM25), total_PM25/10^6, type="l", col="blue",
     xlab="Year", 
     ylab="Total PM2.5 Emission (10^6)", 
     main="Total PM2.5 Emissions From All US Sources")
dev.off()


