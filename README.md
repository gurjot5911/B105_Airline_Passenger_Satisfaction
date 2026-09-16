# Airline Passenger Satisfaction – Applied Statistical Modelling

## Project Overview

This project was developed for the B105 Applied Statistical Modelling assessment. The project applies statistical analysis and binary logistic regression to investigate airline passenger satisfaction.

The analysis combines exploratory data analysis, descriptive statistics, hypothesis testing, logistic regression, model diagnostics and predictive evaluation to examine factors associated with passenger satisfaction.

## Business Problem

Passenger satisfaction is an important indicator of airline customer experience. Understanding the factors associated with satisfaction can help airlines identify areas of the passenger journey that may require attention.

This project investigates the relationships between passenger satisfaction and passenger characteristics, travel characteristics, flight delays and service ratings. Statistical modelling is used to identify significant associations and evaluate the ability to predict passenger satisfaction.

## Dataset

The project uses the **Airline Passenger Satisfaction Dataset** obtained from Kaggle.

Dataset source:

https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction

The original dataset contains **129,880 observations and 24 variables**, including demographic characteristics, travel information, flight delays, service ratings and passenger satisfaction.

The dataset is not included in this repository. It can be downloaded directly from the Kaggle source above.

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

The following statistical techniques were implemented in R:

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

The original dataset contained **129,880 observations and 24 variables**.

Initial data-quality checks identified **393 missing values in arrival delay**. No duplicate rows were identified.

For the modelling analysis, observations with missing values in the selected modelling variables were excluded, resulting in **129,487 observations**.

The satisfaction variable was converted into a binary outcome:

- `0` = Neutral or Dissatisfied
- `1` = Satisfied

The final modelling data were divided using a **stratified 70/30 train-test split**:

- Training data: **90,640 observations**
- Test data: **38,847 observations**

The stratified split maintained approximately the same satisfaction-class proportions in both datasets.

## Exploratory Analysis

Descriptive analysis examined passenger age, flight distance, departure delay, arrival delay and satisfaction across passenger groups.

Overall:

- Neutral/Dissatisfied: **73,452 passengers (56.55%)**
- Satisfied: **56,428 passengers (43.45%)**

Passenger class showed substantial differences in satisfaction:

- Business: **69.44% satisfied**
- Economy: **18.77% satisfied**
- Economy Plus: **24.64% satisfied**

Satisfaction also differed by type of travel:

- Business travel: **58.37% satisfied**
- Personal travel: **10.13% satisfied**

The analysis also identified differences in age, flight distance, delays and service ratings between satisfaction groups.

## Inferential Analysis

A chi-square test identified a statistically significant association between passenger class and satisfaction:

- Chi-square = **32,906**
- Degrees of freedom = **2**
- p-value < **2.2 × 10⁻¹⁶**
- Cramer's V = **0.5033**

A Welch independent-samples t-test identified a statistically significant difference in departure delays between satisfaction groups:

- Neutral/Dissatisfied mean = **16.34 minutes**
- Satisfied mean = **12.44 minutes**
- t = **18.722**
- df = **127,485**
- p-value < **2.2 × 10⁻¹⁶**
- 95% CI = **[3.496, 4.314] minutes**

A Wilcoxon rank-sum sensitivity analysis also indicated a statistically significant difference in the delay distributions:

- W = **2,210,334,343**
- p-value < **2.2 × 10⁻¹⁶**

## Logistic Regression

A binary logistic regression model was developed using passenger, travel, delay and service-rating variables.

Important associations included:

- Economy vs Business class: **OR = 0.462**
- Economy Plus vs Business class: **OR = 0.425**
- Personal vs Business travel: **OR = 0.062**
- Returning vs First-time customer: **OR = 6.746**
- Online Boarding: **OR = 1.860**
- Cleanliness: **OR = 1.306**
- On-board Service: **OR = 1.441**
- In-flight Service: **OR = 1.218**
- In-flight Wi-Fi Service: **OR = 1.292**
- Baggage Handling: **OR = 1.264**

Flight distance and in-flight entertainment were not statistically significant predictors in the fitted model.

The model showed a substantial improvement over the null model, with a likelihood-ratio comparison producing **p < 2.2 × 10⁻¹⁶**.

The model's **McFadden pseudo-R² was 0.4904**.

## Model Diagnostics

Multicollinearity was assessed using VIF/GVIF diagnostics. Most predictors showed relatively modest values, while departure delay and arrival delay had higher adjusted GVIF values of approximately **3.78**, reflecting their relationship.

Diagnostic plots indicated some non-linear patterns for age and flight distance and some unusual residual observations. The leverage diagnostic did not indicate that a small number of observations dominated the model.

## Model Performance

The logistic regression model was evaluated using the independent test dataset.

Performance results were:

- **Accuracy:** 86.37%
- **Precision:** 85.35%
- **Recall:** 82.86%
- **F1-score:** 84.09%
- **ROC-AUC:** 0.9193
- **Optimal threshold:** approximately 0.5122
- **Sensitivity:** 82.45%
- **Specificity:** 89.64%

### Confusion Matrix

- True Negatives: **19,568**
- False Positives: **2,400**
- False Negatives: **2,893**
- True Positives: **13,986**

These results indicate that the model provides useful classification performance for distinguishing satisfied and neutral/dissatisfied passengers on unseen test observations.

## Software and Packages

The analysis was conducted using **R/RStudio**.

Main packages used include:

- `tidyverse`
- `janitor`
- `car`
- `pROC`

## Repository Contents

The repository contains the main R implementation and project documentation.

### `Airline Passenger Satisfaction.R`

This script contains the complete statistical analysis, including:

- Data preparation
- Exploratory data analysis
- Descriptive statistics
- Inferential statistical testing
- Logistic regression modelling
- Model diagnostics
- Predictive evaluation

### `README.md`

Provides an overview of the project, dataset, methodology, statistical analysis and key findings.

### `.gitignore`

Contains rules for excluding datasets, temporary files and generated files from the Git repository.

## How to Run the Project

1. Download the Airline Passenger Satisfaction dataset from Kaggle:

https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction

2. Open RStudio.

3. Open:

`Airline Passenger Satisfaction.R`

4. Update the dataset file path in the R script if required.

5. Install the required R packages if they are not already installed.

6. Run the script sequentially from the beginning.

## Important Note

The original dataset is not stored in this repository. Users should download the dataset directly from the Kaggle source provided above before running the R script.

## Author

**Gurjot Deol**

GitHub: https://github.com/gurjot5911

Email: gurjotdeol3226@gmail.com