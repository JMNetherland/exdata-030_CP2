##  Load data into R
NEI <- readRDS("summarySCC_PM25.rds")

##  Load the dplyr package
library(dplyr)

data <- NEI %>%
        group_by(year) %>%
        summarise(total=sum(Emissions, na.rm = TRUE)) %>%
        mutate(megatons = total/1000000)

##  Intialize png graphic device with size 480x480
png(filename = "CP2_plot1.png"
    , width = 480
    , height = 480)

##  Create a barplot of Total Emissions by year
barplot(data$megatons
        , names.arg = data$year
        , ylab = "Total Emissions(mt)"
        , main = "Total Emissions by Year"
        , col = 'blue')

##  Close graphic device
dev.off()