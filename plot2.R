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

#Q2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
#(fips=="24510")from 1999 to 2008? Use the base plotting system to make a plot 
#answering this question.

Baltimore <- subset (NEI, fips == "24510")
Baltimore_total_PM25 <- tapply(Baltimore$Emissions, Baltimore$year, sum)

png(filename="./plot2.png", width=680,height=480,units="px")
plot(names(Baltimore_total_PM25), Baltimore_total_PM25, type="l", col="blue",
     xlab="Year", 
     ylab="Total PM2.5 Emission", 
     main="Total PM2.5 Emissions From Baltimore")
dev.off()
