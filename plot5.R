library(ggplot2)

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

#Q5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#Get the index for rows where EI.Sector contains keyword "vehicles"
mv_temp <- grep("vehicles", SCC$EI.Sector, ignore.case = TRUE)
#Pass the index and row data of SCC into 'vehicle' variable
mv <- SCC[mv_temp, ]

#get final Baltimore motor vehicle data
final_mv_data <- NEI[NEI$SCC %in% mv$SCC & NEI$fips == "24510",]
MV_total_by_year <- with(final_mv_data, aggregate(Emissions, by = list(year), sum))

png(filename="./plot5.png", width=680,height=480,units="px")
ggplot(data = MV_total_by_year, aes(Group.1, x)) + geom_line() + geom_point(size=1, colour="red")+labs(x = "Year") + labs(y = "Total PM2.5 Emission") + labs(title = "PM2.5 Emissions by Motor Vehicles in Baltimore")
dev.off()
