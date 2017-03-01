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

#Q4: Across the United States, how have emissions from coal combustion-related 
#sources changed from 1999–2008?

#Get the index for rows where Short.Name contains keyword "coal"
coal_temp <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
#Pass the index and row data of SCC into 'coal' variable
coal <- SCC[coal_temp, ]
#'coal' variable contains the obs related to coal combustion, 
#'final_coal_data' will filter to have only relevant coal data in NEI, 
# by matching NEI SCC id that is in coal SCC id
final_coal_data <- NEI[NEI$SCC %in% coal$SCC, ]

coal_total_by_year <- with(final_coal_data, aggregate(Emissions, by = list(year), sum))

png(filename="./plot4.png", width=680,height=480,units="px")
ggplot(data = coal_total_by_year, aes(Group.1, x)) + geom_line() + geom_point(size=1, colour="red")+labs(x = "Year") + labs(y = "Total PM2.5 Emission") + labs(title = "Coal combustion-related sources changed from 1999–2008")
dev.off()
