# Melbourne Housing Data: Create Investment Strategy with Cluster Analysis 
Unsupervised learning methods: PCA, Cluster Analysis, t-SNE

The 2016 Melbourne Housing Market dataset contains real estate data on over 34K units including townhomes and houses and property attributes such as number of bedrooms, baths, the size of the building area, and several geographic attributes such as neighborhood and Council Area. 
 
This assessment uses unsupervised machine learning techniques to draw conclusions about the overall real estate market with the goal of assisting real estate investors with identifying potential areas and properties that may be undervalued. Methods explored include Principal Components Analysis (PCA), K-Means Clustering, and t-SNE analysis to understand latent traits within the dataset and segment properties according to attribute similarities.

### Objective 
Develop a strategy to identify potentially undervalued properties within the Melbourne Housing dataset 
 
### Data Source and Exploratory Data Analysis 
2016 Melbourne Housing Market - [Kaggle](https://www.kaggle.com/datasets/anthonypino/melbourne-housing-market) 
The dataset in this project was adapted from the Kaggle dataset 
- Over 50,000 properties were reduced to 8887 properties when reviewing complete cases 
- Prices are listed in AUD and distance/sizes are listed in meters 
- Correlation analysis revealed a high correlation between BuildingArea (size of the building in meters) and Room (0.72) and Bathroom (0.65): This lead me to drop the Room and Bathroom variables from the dataset 
- New feature created: Price per Meter (ppm) provides a standardized way to compare prices amongst properties with similar BuildingArea 
  - PPM = Price/ Building Area 
 
### Methodology 
Principal Components Analysis, K-Means Clustering, and t-SNE visualization were explored 
 
**Principal Components Analysis (PCA)**  
PCA provides a method to understand linear combinations of variables that contribute to the most variability within the data. By examining the first 2 principal components, we can graph data and discover relationships that account for the highest overall variety in the dataset. The biplot indicates that Distance and ppm have the highest contribution to variance in the 1st PC to create . The 2nd PC reflects a combination of BuildingArea and Car to create a building size component. The first 2 principal components account for 62% of the variance in the data. 

