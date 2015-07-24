#  Load data into R
NEI <- readRDS("summarySCC_PM25.rds")

##  Load the dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)

##  Create at data frame with total emission grouped by year and type
data <- NEI %>%
        group_by(year,type) %>%
        summarise(total=sum(Emissions, na.rm = TRUE)) %>%
        mutate(megatons = total/1000000)

##  Turns year into a factor variable
data$year <- factor(data$year)

## Creates a variable g that contains the plot
g <- ggplot(data, aes(year, megatons)) 

##  Set the facets to type in a 2 by 2 grid with scales set to free
g <- g + facet_wrap(~ type
                   , nrow = 2
                   , ncol = 2
                   , scales = "free") 
##  Creats a bar plot of the data
g <- g + geom_bar(stat = "identity"
                 , fill = "green") 
##  Adds a trend line
g <- g + geom_smooth(aes(group = 1)
                    , method = "lm"
                    , se = FALSE
                    , col = "blue"
                    , size = 1.5) 
## Adds labels to x and y and sets title
g <- g + labs(x = "Year"
             , y = "Total Emissions(mt)"
             , title = expression(bold("Total Emmisions By Year For Each Type")))

##  Intialize png graphic device with size 480x480
png(filename = "CP2_plot3.png"
    , width = 480
    , height = 480)

## Prints g to the png device that was previously opened
print(g)

##  Close graphic device
dev.off()