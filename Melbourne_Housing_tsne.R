### Melbourne Housing Dataset: t-SNE Analysis with Clusters
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

# Remove Rooms and Bathroom due to high correlation with BuildingArea

workscaled2 <- workscaled[,c("Price","Distance", "Car","BuildingArea","YearBuilt","ppm")]

# Run cluster model so that clusters can be applied to t-sne 
# K-means on k =3

set.seed(1234)
k3 <- kmeans(workscaled2, centers=3, nstart = 25)

#### T-SNE with clusters
library(ggplot2)
library(ggmap)
library(Rtsne)


set.seed(773)

# Create new df for tsne since it requires only unique rows
workdata4 <- workdata3
workdata4$ClusterKM <- k3$cluster
workdata4u <- unique(workdata4)

# Create df with cluster removed for tsne plot. Cluster assignment will be used to color the plot
workdata4u1 = workdata4u %>% select(-ClusterKM)
tsnescaled = data.frame(scale(workdata4u1))

# Run tsne analysis
tsnefinal = Rtsne(tsnescaled,dims=3,perplexity=50,verbose=TRUE,max_iter=5000,learning=200)

#Review tnse results
tsnedf <- tsnefinal$Y

tsnefinalpts = data.frame(x=tsnefinal$Y[,1],y=tsnefinal$Y[,2],z=tsnefinal$Y[,3],color=workdata4u$ClusterKM)

#Plotting tsne
tsnefinalgraph2d = ggplot(data=tsnefinalpts,mapping=aes()) +
  geom_point(aes(x=x,y=y,color=as.factor(workdata4u$ClusterKM)))
labs(x = "t-SNE Dimension 1", y = "t-SNE Dimension 2", title = "t-SNE visualized data, Colored by Cluster",color="Cluster") +
  theme_linedraw()
