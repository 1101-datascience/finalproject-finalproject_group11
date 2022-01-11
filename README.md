# [GroupID] Group 11 Boston Housing price

### Groups
* 曾偉綱	資科碩二	108753122
* 盧禹叡	經濟碩二	109258026
* 張修誠	資科碩一	110753165
* 邱顯安	資科碩一	110753110



### Goal
A breif introduction about your project, i.e., what is your goal?

### Demo 
Commend to reproduce our result
```R
Rscript performance.R --fold <k> --input data/training --output results/performance.csv
```
* Shiny io app :

## Folder organization and its related information

### docs
* Your presentation, 1101_datascience_FP_<yourID|groupName>.ppt/pptx/pdf, by **Jan. 13**
* Any related document for the final project
  * papers
  * software user guide

### data

* Form Kaggle API : $ kaggle competitions download boston-housing
* Input format : CSV
* Preprocessing
  * Check Missing value
  ```R
  colSums(is.na(data))
  ```
  ![Missing Value](Missing_value_checking.png)
    No missing value
  * Outlier check & remove by box plot
  * Skewness check & process
  * Correlated Heat Map between Features 
  

### code

* Which method do you use?
  We use Random forest model for our prediction.
  ```R
  train_control <- trainControl(method = "none")

  model <- train(medv~., data = train_data, method = "rf", trControl = train_control)
  ```
* What is a null model for comparison?
  We compare our model with Linear Model & KNN Model respectively
 ```R
 model <- train(medv~., data = train_data, method = "knn", trControl = train_control)
 model <- train(medv~., data = train_data, method = "lm", trControl = train_control)
 ```
 ![KNN model](KNN_model.png)
 ![Linear regression model](Linear_Regression_model.png)
 ![Random forest model](Random_forest_model.png)
 
* How do your perform evaluation? ie. cross-validation, or addtional indepedent data set
  We use cross-validation to evaluate our performance, and also use the addtio.nal indepedent data     set to check our prediction on Kaggle.
  ![Kaggle submission](Kaggle.png)
  
  
  
### results

* Which metric do you use 
  We use RMSE as our metric.
* Is your improvement significant?
* What is the challenge part of your project?

## References
* Packages you use
  ```R
  library(caret)
  library(randomForest)  
  ```
* Related publications
  https://www.kaggle.com/c/boston-housing/overview
