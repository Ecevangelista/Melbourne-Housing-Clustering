# Melbourne Housing Data: Create Investment Strategy with Cluster Analysis 
Unsupervised learning methods: PCA, Cluster Analysis, t-SNE

The 2016 Melbourne Housing Market dataset contains real estate data on over 34K units including townhomes and houses and property attributes such as number of bedrooms, baths, the size of the building area, and several geographic attributes such as neighborhood and Council Area. 
 
This assessment uses unsupervised machine learning techniques to draw conclusions about the overall real estate market with the goal of assisting real estate investors with identifying potential areas and properties that may be undervalued. Methods explored include Principal Components Analysis (PCA), K-Means Clustering, and t-SNE analysis to understand latent traits within the dataset and segment properties according to attribute similarities.

### Objective 
Develop a strategy to identify potentially undervalued properties within the Melbourne Housing dataset 
 
### Data Source and Exploratory Data Analysis 
2016 Melbourne Housing Market - [Kaggle](https://www.kaggle.com/datasets/anthonypino/melbourne-housing-market)  
The dataset in this project was adapted from the Kaggle dataset 
- Over 34,000 properties were reduced to 8,887 properties when reviewing complete cases. Removal of outliers reduced the final dataset to over 8,300 properties. 
- Prices are listed in AUD and distance/sizes are listed in meters 
- Correlation analysis revealed a high correlation between BuildingArea (size of the building in meters) and Room (0.72) and Bathroom (0.65): This lead me to drop the Room and Bathroom variables from the dataset 
- New feature created: Price per Meter (ppm) provides a standardized way to compare prices amongst properties with similar BuildingArea 
  - PPM = Price/ Building Area 
 
### Methodology 
Principal Components Analysis, K-Means Clustering, and t-SNE visualization were explored 
 
**Principal Components Analysis (PCA)**  
PCA provides a method to understand linear combinations of variables that contribute to the most variability within the data. By examining the first 2 principal components, we can graph data and discover relationships that account for the highest overall variety in the dataset. The biplot indicates that Distance and ppm have the highest contribution to variance in the 1st PC to create . The 2nd PC reflects a combination of BuildingArea and Car to create a building size component. The first 2 principal components account for 62% of the variance in the data. 

![biplot grey pca](https://user-images.githubusercontent.com/49419673/190304408-4af2d56e-3995-4e3c-b6f9-3dea18ca72ab.jpeg) 
 
**K-Means Clustering**  
K-Means clustering segments the dataset into clusters based on similarities. Initial analysis using the Nbclust package indicated that 3 clusters was the optimal cluster size. The clusters were validated by splitting the data into train and test sets to verify similar results in cluster size and cluster means. The cluster plot shows that 3 clusters as well-defined. Profiles of each clusters are shown below and were developed by analyzing the mean values of each property attribute.  
From the profile summary, Cluster 1 has the best value:   
- Lowest average ppm: $5,746 
- Mid-range average price: $1 MM 
- Newest housing stock, with average Year Built: 1985  
 
Cluster 3 has the highest average price ($1.6MM) and highest average ppm ($11,804) despite having the oldest average housing stock (avg. year built 1922). 
 
![Cluster profiles chart](https://user-images.githubusercontent.com/49419673/190306604-50d2c90d-6080-46b5-8c20-cf8592cd246b.png) 
 
![cluster means chart](https://user-images.githubusercontent.com/49419673/190306636-7f47b1f0-95b0-4fe2-9de1-fb08cbca931d.png) 


![Cluster plot on k=3](https://user-images.githubusercontent.com/49419673/190304736-228c88c4-6993-4b21-ba8f-2855d3c3de37.jpeg) 
 
**t-SNE**   
The t-SNE image provides another method to visualize the high-dimensional data by mapping the data into a 2-D visualization. The plot shows property groupings where Cluster 1 and Cluster 3 co-mingle, which can lead to an investment strategy of identifying undervalued properties in Cluster 1 with below-average price per meter that fall in the same neighborhoods or Council Areas of Cluster 3.  

![Tsne plot cluster](https://user-images.githubusercontent.com/49419673/190304909-38b2ec5b-3e85-476b-98df-9e7fa7dfcbd5.jpeg) 

### Conclusions: Recommended Investment Criteria to Identify Undervalued Properties 
 
Criteria focusing on Cluster 1 properties are developed to create a list of potentially undervalued properties: 
- Price below Cluster 3 market average: $1.5MM 
- PPM below market average: $7,300 
- BuildingArea greater than or equal to 100 meters 
- Council Areas shared between Cluster 1 and Cluster 3: Boroondara, Glen Eira, Moreland, Moonee Valley, Darebin, Stonnington, Port Phillip, Melbourne 
 
30 properties meet the above criteria and are located within the city councils of Boroondara, Darebin, Moonee Valley, Stonnington. These properties also reflect newer builds found in Cluster 1 and on average were built around 1987. The newer housing age may indicate lower efforts needed to renovate the property to yield a higher sales price.  
