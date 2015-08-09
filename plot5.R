#  Load data into R
NEI <- readRDS("summarySCC_PM25.rds")

##  Load the dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)

##  Create at data frame with total emission grouped by year and type
data <- NEI %>%
        filter(type == "ON-ROAD", fips == "24510") %>%
        group_by(year) %>%
        summarise(total=sum(Emissions, na.rm = TRUE)) %>%
        mutate(kilotons = total/1000)

##  Turns year into a factor variable
data$year <- factor(data$year)

## Creates a variable g that contains the plot
g <- ggplot(data, aes(year, total)) 

##  Creats a bar plot of the data
g <- g + geom_bar(stat = "identity"
                  , fill = "steel blue") 
##  Adds a trend line
g <- g + geom_smooth(aes(group = 1)
                     , method = "lm"
                     , se = FALSE
                     , col = "red"
                     , size = 1.5) 
## Adds labels to x and y and sets title
g <- g + labs(x = "Year"
              , y = "Total Emissions(tons)"
              , title = expression(bold("Total Emmisions By Year For Baltimore City Motor Vehicles")))

##  Intialize png graphic device with size 480x480
png(filename = "plot5.png"
    , width = 480
    , height = 480)

## Prints g to the png device that was previously opened
print(g)

##  Close graphic device
dev.off()