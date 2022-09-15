### Melbourne Housing Dataset: PCA and Cluster Analysis
### Elaine Evangelista


### Ingest dataset
data.path <- 'C:\\Users\\Elaine\\Documents\\Desk R\\411 Unsupervised\\411_A2\\';
data.file <- paste(data.path,'Melbourne_housing_FULL.csv',sep='');

alldata = read.csv(data.file,header=TRUE)
houses = alldata[complete.cases(alldata),]
print(str(houses))
workdata = houses[,c("Rooms","Price","Distance","Bedroom2",
                     "Bathroom","Car","Landsize","BuildingArea","YearBuilt")]

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

# ----- EDA before clustering ----

library(readr)
library(tidyverse)
library(DataExplorer)
library(cluster)
library(factoextra)
library(dplyr)


# Remove Rooms and Bathroom due to high correlation with BuildingArea

workscaled2 <- workscaled[,c("Price","Distance", "Car","BuildingArea","YearBuilt","ppm")]

#PCA to look at variances within the dataset

library(psych)

pc <- prcomp(workscaled2[,-1], scale=FALSE)

pc

# bi plot - shows the correlation among the various factors
# there is not much of a correlation between price and size or Year Built

biplot(pc, xlim=c(-0.08, 0.08), col = c('grey', 'red'))

workscaled2.1 <- cbind(workscaled2, pc$x[,1:2])
workscaled2.1

# Contributions of variables to PCs
var <- get_pca_var(pc)
var_cont <- var$contrib
var_cont

# PC loadings have the same information as the variable contributions
pc$rotation

summary(pc)

# The first 2 PCs account for 62% of the variance in the dataset
# PC1: Distance and PPM have the highest loadings
# PC2: Car and Building Area have the highest loadings

### Cluster Analysis
# use nbclust to find optimal k size
library(NbClust)

set.seed(123)
worksample1 <- workscaled2[sample(nrow(workscaled2), size = 2000, replace = FALSE)] 

clusterNo=NbClust(worksample1,distance="euclidean",
                  min.nc=2,max.nc=15,method="complete",index="all")

set.seed(892)
worksample2 <- workscaled2[sample(nrow(workscaled2), size = 2000, replace = FALSE)] 

clusterNo=NbClust(worksample2,distance="euclidean",
                  min.nc=2,max.nc=15,method="complete",index="all")

#### K-Means model

# K-means on k =3

set.seed(1234)
k3 <- kmeans(workscaled2, centers=3, nstart = 25)
fviz_cluster(k3, data = workscaled2, main = "Cluster Plot k=3")

# Check K-means on k = 6 for comparison

set.seed(692)
k6 <- kmeans(workscaled2, centers=6, nstart = 25)
fviz_cluster(k6, data = workscaled2, main = "Cluster Plot k=6")

# cluster sizes
k3$size

k6$size

# Get summary of 6 clusters by converting the scaled results to original numbers
# Create new df to match workscaled2 variables
workdata3 <- workdata2[,c("Price","Distance", "Car","BuildingArea","YearBuilt","ppm")]

clconv6 <- workdata3 %>%
  mutate(Cluster = k6$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

print(clconv6, width = Inf)

#use readr to write csv - copy in your filepath
write_csv(clconv6, "~/Desk R/411 Unsupervised/411_A2/A2git/clustkm6summ.csv")

clconv3 <- workdata3 %>%
  mutate(Cluster = k3$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

print(clconv3, width = Inf)

write_csv(clconv3, "~/Desk R/411 Unsupervised/411_A2/A2git/clustkm3summ.csv")

# Validate 3-cluster model
set.seed(123)

#use 70% of dataset as training set and 30% as test set
sample <- sample(c(TRUE, FALSE), nrow(workdata3), replace=TRUE, prob=c(0.7,0.3))
train  <- workdata3[sample, ]
test   <- workdata3[!sample, ]

train_sc <- scale(train)
test_sc <- scale(test)

set.seed(1234)
k3train <- kmeans(train_sc, centers=3, nstart = 25)
fviz_cluster(k3train, data = train, main = "Cluster Plot k=3 train")

# cluster sizes
k3train$size

# Convert train to orginal scale to review the means
clconv3train <- train %>%
  mutate(Cluster = k3train$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

print(clconv3train, width = Inf)

write_csv(clconv3train, "~/Desk R/411 Unsupervised/411_A2/A2git/clustkm3summtrain.csv")

# Validate model with test set

set.seed(1234)
k3test <- kmeans(test_sc, centers=3, nstart = 25)
fviz_cluster(k3test, data = test, main = "Cluster Plot k=3 test")

# Cluster sizes
k3test$size

# Convert test to original scale to review the means
clconv3test <- test %>%
  mutate(Cluster = k3test$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

print(clconv3test, width = Inf)

write_csv(clconv3test, "~/Desk R/411 Unsupervised/411_A2/A2git/clustkm3summtest.csv")

# Review of the train and test sets show consistency in cluster 

# Move forward with 3 clusters after validation

k3$cluster[1:5]

# Create new df to assign kmeans clusters to df to run additional analysis with other variables

workdfkm <- as.data.frame(houses) 

workdfkm$ppm <- workdfkm$Price/workdfkm$BuildingArea

workdfkm['ClusterKM'] <- k3$cluster

workdfkm$Distance <- as.numeric(workdfkm$Distance)

# reduce workdfkm columns


workdfkm2 <- subset(workdfkm, select=c("Suburb","Rooms","Type","Price", "ppm","Distance","Bathroom",
                                       "Car","BuildingArea","YearBuilt","CouncilArea","Lattitude",
                                       "Longtitude", "Regionname", "ClusterKM"))

#Compare cluster solution with house type and suburb/location - create tibble

cluster_type <- workdfkm2 %>%
  group_by(ClusterKM, Type) %>%
  summarise(n=n())

cluster_type

# Export tibble
write.table(cluster_type , file = "~/Desk R/411 Unsupervised/411_A2/A2git/cluster_type.csv", sep="," )

#tibble on Council Area
cluster_CA <- workdfkm2 %>%
  group_by(ClusterKM, CouncilArea) %>%
  summarise(CouncilArea_total=n())

cluster_CA

# Export tibble
write.table(cluster_CA , file = "~/Desk R/411 Unsupervised/411_A2/A2git/cluster_CA.csv", sep="," )

# tibble on Council Area with Type breakout
cluster_CAtype <- workdfkm2 %>%
  group_by(ClusterKM, CouncilArea, Type) %>%
  summarise(Type_total=n())

cluster_CAtype

# Export tibble
write.table(cluster_CAtype , file = "~/Desk R/411 Unsupervised/411_A2/A2git/cluster_CAtype.csv", sep="," )

cluster_region<- workdfkm2 %>%
  group_by(ClusterKM, Regionname) %>%
  summarise(Region_total=n())

cluster_region

# Export tibble
write.table(cluster_region , file = "~/Desk R/411 Unsupervised/411_A2/A2git/cluster_region.csv", sep="," )

# Find properties in Cluster 1 that may be undervalued
nrow(workdfkm2[workdfkm2$ClusterKM == 1 & workdfkm2$BuildingArea >=100 & 
                 workdfkm2$CouncilArea == c('Darebin City Council', 'Boroondara City Council',
                                            'Moonee Valley City Council', ' Glen Eira City Council',
                                            'Stonnington City Council', 'Melbourne City Council',
                                            'Moreland City Council',' Port Phillip City Council'),])

clus1props <- workdfkm2[workdfkm2$ClusterKM == 1 & workdfkm2$BuildingArea >=100 & 
            workdfkm2$CouncilArea == c('Darebin City Council', 'Boroondara City Council',
                                       'Moonee Valley City Council', ' Glen Eira City Council',
                                      'Stonnington City Council', 'Melbourne City Council', 
                                      ' Moreland City Council',' Port Phillip City Council'),]

write_csv(clus1props, "~/Desk R/411 Unsupervised/411_A2/A2git/clus1props.csv")

