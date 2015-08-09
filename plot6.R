#  Load data into R
NEI <- readRDS("summarySCC_PM25.rds")

##  Load the dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)

##  Create at data frame with total emission grouped by year and type
data <- NEI %>%
        filter(type == "ON-ROAD", fips %in% c("24510", "06037")) %>%
        group_by(year, fips) %>%
        summarise(total=sum(Emissions, na.rm = TRUE)) %>%
        mutate(kilotons = total/1000)

##  Turns year into a factor variable
data$year <- factor(data$year)

##  Turns fips int a factor varible then changes the level names to city names
data$fips <- factor(data$fips)
levels(data$fips) <- c("Los Angeles County, California", "Baltimore City, Maryland")

## Creates a variable g that contains the plot
g <- ggplot(data, aes(year, total)) 

##  Set the facets to type in a 2 by 2 grid with scales set to free
g <- g + facet_wrap(~ fips) 

##  Creats a bar plot of the data
g <- g + geom_bar(stat = "identity"
                  , fill = "grey") 
##  Adds a trend line
g <- g + geom_smooth(aes(group = 1)
                     , method = "lm"
                     , se = FALSE
                     , col = "yellow"
                     , size = 1.5) 
## Adds labels to x and y and sets title
g <- g + labs(x = "Year"
              , y = "Total Emissions(kt)"
              , title = expression(bold("Comparison Of Total Emmisions By Year For\nBaltimore City and Los Angeles Motor Vehicles")))

##  Intialize png graphic device with size 480x480
png(filename = "plot6.png"
    , width = 480
    , height = 480)

## Prints g to the png device that was previously opened
print(g)

##  Close graphic device
dev.off()