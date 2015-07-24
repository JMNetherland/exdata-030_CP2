##  Load data into R
NEI <- readRDS("summarySCC_PM25.rds")

##  Load the dplyr package
library(dplyr)

##  Create data fram with total Emissions by year for Baltimore City
##  with emission in kilotons
balt_data <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarise(total=sum(Emissions, na.rm = TRUE)) %>%
        mutate(kilotons = total/1000)

##  Intialize png graphic device with size 480x480
png(filename = "CP2_plot2.png"
    , width = 480
    , height = 480)

##  Create a barplot of Total Emissions by year for Baltimore City, MD
barplot(balt_data$kilotons
        , names.arg = balt_data$year
        , ylab = "Total Emissions(kt)"
        , main = "Total Emissions for Baltimore City, MD by Year"
        , col = 'red')

##  Close graphic device
dev.off()