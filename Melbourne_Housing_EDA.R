### Melbourne Housing Dataset

data.path <- 'C:\\Users\\Elaine\\Documents\\Desk R\\411 Unsupervised\\411_A2\\';
data.file <- paste(data.path,'Melbourne_housing_FULL.csv',sep='');


### Ingest dataset

alldata = read.csv(data.file,header=TRUE)
houses = alldata[complete.cases(alldata),]
print(str(houses))
workdata = houses[,c("Rooms","Price","Distance","Bedroom2",
                     "Bathroom","Car","Landsize","BuildingArea","YearBuilt")]

summary(houses)

par(mfrow=c(2,2))

### Exploratory Data Analysis to look for outliers or transformation opportunities

hist(houses$Rooms, 
     main="Histogram for Rooms", 
     xlab="Rooms", 
     border="blue", 
     col="green")

print( mean(houses$Rooms))

boxplot(houses$Rooms, main="Box plot of Rooms")

hist(houses$Price, 
     main="Histogram for Price", 
     xlab="Price", 
     border="blue", 
     col="red")

print( mean(houses$Price))

boxplot(houses$Price, main="Box plot of Prices")

num_distance = as.numeric(houses$Distance)

hist(num_distance, 
     main="Histogram for Distance", 
     xlab="Distance", 
     border="blue", 
     col="yellow")

print( mean(num_distance))
boxplot(num_distance, main="Box plot of Distances")

hist(houses$Bedroom2, 
     main="Histogram for Bedroom2", 
     xlab="BedRoom2", 
     border="blue", 
     col="purple")

print( mean(houses$Bedroom2))
boxplot(houses$Bedroom2, main="Box plot of Bedroom2")

hist(houses$Bathroom, 
     main="Histogram for Bathroom", 
     xlab="Bathroom", 
     border="blue", 
     col="orange")

print( mean(houses$Bathroom))
boxplot(houses$Bathroom, main="Box plot of Bathroom")

hist(houses$Car, 
     main="Histogram for Car", 
     xlab="Cars", 
     border="blue", 
     col="darkmagenta")

print( mean(houses$Car))
boxplot(houses$Car, main="Box plot of Car")

hist(houses$Landsize, 
     main="Histogram for Landsize", 
     xlab="Landsize", 
     border="blue", 
     col="turquoise")

print( mean(houses$Landsize))
boxplot(houses$Landsize, main="Box plot of Landsize")

hist(houses$BuildingArea, 
     main="Histogram for Building-Area", 
     xlab="Building Area", 
     border="blue", 
     col="magenta")

print( mean(houses$BuildingArea))
boxplot(houses$BuildingArea, main="Box plot of BuildingArea")

par(mfrow=c(2,2))

hist(houses$YearBuilt, 
     main="Histogram for Year Built", 
     xlab="Year Built", 
     border="blue",
     xlim=c(1870,2022),
     col="turquoise")

print( mean(houses$YearBuilt))
boxplot(houses$YearBuilt, main="Box plot of YearBuilt")

#### Extreme outliers were found in YearBuilt, BuildingArea, Rooms, Price, Bathrooms, Car, 
# and Distance. A review of Landsize and Bedroom2 variables revealed inconsistencies in the data
# that lead to the removal of these variables: Landsize did not correspond to BuildingArea,
# and over 2,000 Landsize records showed values of "0". Bedroom2 also showed inconsistencies with
# 97% of records with values greater than the values in Rooms.

### Preprocessing the dataset to remove outliers and variables Landsize and Bedroom2

# Remove outliers
houses <- subset(houses, houses$YearBuilt > 1870)
houses <- subset(houses, houses$BuildingArea < 600)
houses <- subset(houses, houses$Rooms <= 6)
houses <- subset(houses, houses$Price <= 4000000)
houses <- subset(houses, houses$Bathroom <= 4)
houses <- subset(houses, houses$Car <= 4)
houses <- subset(houses, as.numeric(houses$Distance) < 30)
houses <- subset(houses, houses$BuildingArea >= 10)

# Create new dataframe after removing outliers in houses, remove Bedroom2 & LandSize

workdata2 = houses[,c("Rooms","Price","Distance",
                      "Bathroom","Car","BuildingArea","YearBuilt")]

workdata2$Distance <- as.numeric(workdata2$Distance)

# Feature Engineering: Price per Meter (PPM)

workdata2$ppm <- workdata2$Price/workdata2$BuildingArea

# create new data frame with scaled data
workscaled <- scale(workdata2)

library(tidyverse)
library(DataExplorer)
library(dplyr)

# look at correlation on unscaled data using DataExplorer package
plot_correlation(workdata2)

# Highest correlations between BuildingArea vs. Rooms (0.72) and vs. Bathroom (0.65)

# Remove Rooms and Bathroom due to high correlation with BuildingArea

workscaled2 <- workscaled[,c("Price","Distance", "Car","BuildingArea","YearBuilt","ppm")]

# final dataset including scaled data: workscaled2