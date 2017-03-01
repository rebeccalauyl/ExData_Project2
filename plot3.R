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

#Q3: Of the four types of sources indicated by the type (point, nonpoint, 
#onroad, nonroad) variable, which of these four sources have seen decreases 
#in emissions from 1999–2008 for Baltimore City? Which have seen increases in 
#emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
#answer this question. 

Baltimore <- subset (NEI, fips == "24510")
Baltimore_total_type <- with(Baltimore, aggregate(Emissions, by = list(year, type), sum))
colnames(Baltimore_total_type)[colnames(Baltimore_total_type)=="Group.2"] <- "Type"

png(filename="./plot3.png", width=680,height=480,units="px")
ggplot(data = Baltimore_total_type, aes(Group.1, x)) + geom_line(aes(color = Type)) + geom_point(size=1, fill="red")+ labs(x = "Year") + labs(y = "Total PM2.5 Emission in Baltimore") + labs(title = "Baltimore City PM2.5 Emmission by source, type and year")
dev.off()
