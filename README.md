# Airline Passenger Satisfaction – Applied Statistical Modelling

## Project Overview

This project was developed for the B105 Applied Statistical Modelling assessment. The purpose of the project is to analyse airline passenger satisfaction using descriptive statistics, exploratory data analysis, inferential statistical testing and binary logistic regression.

The analysis investigates whether passenger characteristics, travel characteristics, flight delays and service ratings are associated with overall passenger satisfaction. A logistic regression model is also developed to predict whether a passenger is satisfied or neutral/dissatisfied.

## Business Problem

Airline passenger satisfaction is an important measure of customer experience. Understanding the factors associated with satisfaction can help airlines identify areas of the passenger journey that may require attention.

This project uses statistical analysis to identify relationships between passenger satisfaction and variables such as passenger class, type of travel, customer type, delays and service ratings.

## Dataset

The project uses the **Airline Passenger Satisfaction Dataset** obtained from Kaggle.

Dataset source:

https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction

The dataset contains 129,880 passenger observations and 24 variables covering demographic characteristics, travel information, flight delays, service ratings and passenger satisfaction.

The original dataset is not included in this repository. It can be obtained from the Kaggle link above.

## Research Questions

1. Is there a significant association between passenger class and overall passenger satisfaction?

2. Is there a significant difference in departure delays between satisfied and neutral/dissatisfied passengers?

3. Which passenger characteristics, travel characteristics and service ratings are associated with passenger satisfaction?

4. How accurately can the selected variables predict whether a passenger is satisfied or neutral/dissatisfied?

## Hypotheses

### Passenger Class and Satisfaction

**H0:** Passenger class and satisfaction are independent.

**H1:** Passenger class and satisfaction are significantly associated.

### Departure Delay and Satisfaction

**H0:** The mean departure delay is the same for satisfied and neutral/dissatisfied passengers.

**H1:** The mean departure delay differs between satisfied and neutral/dissatisfied passengers.

### Logistic Regression Predictors

**H0:** The selected predictors have no significant association with the probability of passenger satisfaction after controlling for the other predictors.

**H1:** At least one selected predictor has a significant association with the probability of passenger satisfaction after controlling for the other predictors.

## Statistical Methods

The following statistical methods were applied using R:

- Data cleaning and preprocessing
- Descriptive statistics
- Exploratory data analysis and visualisation
- Chi-square test of independence
- Cramer's V effect size
- Welch independent-samples t-test
- Wilcoxon rank-sum sensitivity analysis
- Binary logistic regression
- Odds ratios and 95% confidence intervals
- Multicollinearity assessment using VIF/GVIF
- Logistic regression diagnostic assessment
- Confusion matrix analysis
- Accuracy, precision, recall and F1-score
- ROC curve and ROC-AUC analysis
- Classification threshold assessment

## Data Preparation

The original dataset contained 129,880 observations and 24 variables.

Initial data-quality checks identified 393 missing values in the `arrival_delay` variable. No duplicate rows were identified.

For the logistic regression analysis, incomplete observations involving the selected modelling variables were excluded, resulting in 129,487 observations.

The satisfaction variable was converted into a binary outcome:

- `0` = Neutral or Dissatisfied
- `1` = Satisfied

A stratified 70/30 train-test split was then used:

- Training data: 90,640 observations
- Test data: 38,847 observations

The stratification maintained approximately the same satisfaction-class proportions in both datasets.

## Software and Packages

The analysis was conducted in **R/RStudio**.

Main R packages used include:

- `tidyverse`
- `janitor`
- `car`
- `pROC`

## Main Analysis

The project investigates the relationship between passenger satisfaction and several explanatory variables, including:

- Passenger class
- Type of travel
- Customer type
- Age
- Flight distance
- Departure delay
- Arrival delay
- Online boarding
- Seat comfort
- Cleanliness
- On-board service
- In-flight service
- In-flight entertainment
- In-flight Wi-Fi service
- Baggage handling

The main predictive model is a binary logistic regression model, with passenger satisfaction as the dependent variable.

## Model Evaluation

The logistic regression model was evaluated using the independent test dataset.

Performance measures included:

- Accuracy
- Precision
- Recall
- F1-score
- ROC-AUC
- Sensitivity
- Specificity
- Confusion matrix

The model achieved an accuracy of approximately 86.37% and a ROC-AUC of 0.9193 on the test dataset.

## Repository Contents

This repository contains the main R implementation for the project.

### `Airline Passenger Satisfaction.r`

This R script contains the complete statistical analysis, including:

- Data preparation
- Exploratory data analysis
- Descriptive statistics
- Inferential statistical tests
- Logistic regression modelling
- Model diagnostics
- Predictive evaluation

## How to Run the Project

1. Download the Airline Passenger Satisfaction dataset from Kaggle using the dataset link provided above.

2. Open RStudio.

3. Open the file:

`Airline Passenger Satisfaction.r`

4. Update the dataset file path in the R script if required.

5. Install the required packages if they are not already installed.

6. Run the R script sequentially from the beginning.

## Author

**Gurjot Deol**

GitHub: `gurjot5911`

Email: `gurjotdeol3226@gmail.com`