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

#Q6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
#vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city has seen
#greater changes over time in motor vehicle emissions?


##Get the index for rows where EI.Sector contains keyword "vehicles"
mv_temp <- grep("vehicles", SCC$EI.Sector, ignore.case = TRUE)
#Pass the index and row data of SCC into 'vehicle' variable
mv <- SCC[mv_temp, ]

#get final Baltimore motor vehicle data
Baltimore_final_mv_data <- NEI[NEI$SCC %in% mv$SCC & NEI$fips == "24510",]

#get final LA motor vehicle data
LA_final_mv_data <- NEI[NEI$SCC %in% mv$SCC & NEI$fips == "06037",]

#merge data
Merge_MV_data<- rbind(Baltimore_final_mv_data, LA_final_mv_data)
MV_total_by_year <- with(Merge_MV_data, aggregate(Emissions, by = list(fips, year), sum))

MV_total_by_year$county <- ifelse(MV_total_by_year$Group.1 == "06037", "Los Angeles", "Baltimore")

png(filename="./plot6.png", width=680,height=480,units="px")
ggplot(data = MV_total_by_year, aes(Group.2, x)) + geom_line(aes(colour=county)) + geom_point()+labs(x = "Year") + labs(y = "Total PM2.5 Emission") + labs(title = "PM2.5 Emissions by Motor Vehicles in Baltimore Vs Los Angeles")
dev.off()
