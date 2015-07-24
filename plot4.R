##  Load data into R
##  The files summarySCC_PM25.rds and Source_Classification_Code.rds
##  need to be in your working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##  Load the dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)

## Merges NEI and SCC into a single data frame
NEI_merge <- merge(NEI, SCC, by.x = "SCC", by.y = "SCC")

##  Removed NEI and SCC as they are no longer needed
rm(NEI)
rm(SCC)

##  Create at data frame with total emission grouped by year and EI.Sector 
##  and that filters on the key word comb and coal to find all coal
##  combustions readings
data <- NEI_merge %>%
        filter(grepl("comb", EI.Sector, ignore.case = TRUE)
               , grepl("coal", EI.Sector, ignore.case = TRUE)) %>%
        group_by(year,EI.Sector) %>%
        summarise(total=sum(Emissions, na.rm = TRUE)) %>%
        mutate(kilotons = total/1000)

##  Turns year into a factor variable
data$year <- factor(data$year)

##  Reset the factor levels on EI.Sector in data excluding the 
##  Fuel Comb - and - Coal in the begining and end as they are redundant
data$EI.Sector <- sub("Fuel Comb - ", "", data$EI.Sector)
data$EI.Sector <- sub(" - Coal", "", data$EI.Sector)
data$EI.Sector <- factor(data$EI.Sector)

## Creates a variable g that contains the plot
g <- ggplot(data, aes(year, kilotons)) 

##  Set the facets to EI.Sector with scales set to free
g <- g + facet_wrap(~ EI.Sector
                    , scales = "free") 
##  Creats a bar plot of the data
g <- g + geom_bar(stat = "identity"
                  , fill = "orange") 
##  Adds a trend line
g <- g + geom_smooth(aes(group = 1)
                     , method = "lm"
                     , se = FALSE
                     , col = "steel blue"
                     , size = 1.5) 
## Adds labels to x and y and sets title
g <- g + labs(x = "Year"
              , y = "Total Emissions(kt)"
              , title = expression(bold("Total Emmisions By Year For Each Coal Combustion Source")))

##  Intialize png graphic device with size 480x480
png(filename = "CP2_plot4.png"
    , width = 480
    , height = 480)

## Prints g to the png device that was previously opened
print(g)

##  Close graphic device
dev.off()