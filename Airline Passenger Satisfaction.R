# Install Packages
install.packages(c("tidyverse", "janitor", "car", "pROC"))

## Load Packages
library(tidyverse)
library(janitor)
library(car)
library(pROC)

# Import the dataset
airline <- read.csv("airline_passenger_satisfaction.csv",
                    stringsAsFactors = FALSE)

airline <- clean_names(airline)

dim(airline)
head(airline)
str(airline)

# Understand the dataset
summary(airline)

str(airline)

nrow(airline)

ncol(airline)

## Check the unique categories

unique(airline$satisfaction)

unique(airline$class)

unique(airline$type_of_travel)

unique(airline$customer_type)

## Check missing values
colSums(is.na(airline))

## Check duplicate records
sum(duplicated(airline))

# Data cleaning

summary(airline[, c(
  "age",
  "flight_distance",
  "departure_delay",
  "arrival_delay",
  "departure_and_arrival_time_convenience",
  "ease_of_online_booking",
  "check_in_service",
  "online_boarding",
  "gate_location",
  "on_board_service",
  "seat_comfort",
  "leg_room_service",
  "cleanliness",
  "food_and_drink",
  "in_flight_service",
  "in_flight_wifi_service",
  "in_flight_entertainment",
  "baggage_handling"
)])

# Check the rating variables
rating_vars <- c(
  "departure_and_arrival_time_convenience",
  "ease_of_online_booking",
  "check_in_service",
  "online_boarding",
  "gate_location",
  "on_board_service",
  "seat_comfort",
  "leg_room_service",
  "cleanliness",
  "food_and_drink",
  "in_flight_service",
  "in_flight_wifi_service",
  "in_flight_entertainment",
  "baggage_handling"
)

lapply(airline[rating_vars], unique)

# Convert categorical variables to factors
airline <- airline %>%
  mutate(
    gender = factor(gender),
    customer_type = factor(customer_type),
    type_of_travel = factor(type_of_travel),
    class = factor(class),
    satisfaction = factor(
      satisfaction,
      levels = c("Neutral or Dissatisfied", "Satisfied")
    )
  )

str(airline)

# Create the binary outcome for logistic regression

airline <- airline %>%
  mutate(
    satisfied_binary = ifelse(
      satisfaction == "Satisfied", 1, 0
    )
  )

table(airline$satisfaction)

table(airline$satisfied_binary)

# Check the distribution of satisfaction

satisfaction_counts <- table(airline$satisfaction)

satisfaction_counts

prop.table(satisfaction_counts) * 100

## Visualise
ggplot(airline, aes(x = satisfaction)) +
  geom_bar() +
  labs(
    title = "Distribution of Airline Passenger Satisfaction",
    x = "Satisfaction",
    y = "Number of Passengers"
  ) +
  theme_minimal()

# Descriptive statistics
airline %>%
  summarise(
    Age_Mean = mean(age, na.rm = TRUE),
    Age_Median = median(age, na.rm = TRUE),
    Age_SD = sd(age, na.rm = TRUE),
    
    Flight_Distance_Mean = mean(flight_distance, na.rm = TRUE),
    Flight_Distance_Median = median(flight_distance, na.rm = TRUE),
    Flight_Distance_SD = sd(flight_distance, na.rm = TRUE),
    
    Departure_Delay_Mean = mean(departure_delay, na.rm = TRUE),
    Departure_Delay_Median = median(departure_delay, na.rm = TRUE),
    Departure_Delay_SD = sd(departure_delay, na.rm = TRUE),
    
    Arrival_Delay_Mean = mean(arrival_delay, na.rm = TRUE),
    Arrival_Delay_Median = median(arrival_delay, na.rm = TRUE),
    Arrival_Delay_SD = sd(arrival_delay, na.rm = TRUE)
  )

# Descriptive statistics by satisfaction
airline %>%
  group_by(satisfaction) %>%
  summarise(
    n = n(),
    mean_age = mean(age, na.rm = TRUE),
    mean_flight_distance = mean(flight_distance, na.rm = TRUE),
    mean_departure_delay = mean(departure_delay, na.rm = TRUE),
    mean_arrival_delay = mean(arrival_delay, na.rm = TRUE),
    mean_seat_comfort = mean(seat_comfort, na.rm = TRUE),
    mean_online_boarding = mean(online_boarding, na.rm = TRUE),
    mean_cleanliness = mean(cleanliness, na.rm = TRUE),
    mean_inflight_service = mean(in_flight_service, na.rm = TRUE)
  )

# Satisfaction by travel class
## Create a cross-tabulation
class_satisfaction <- table(
  airline$class,
  airline$satisfaction
)

class_satisfaction

## Calculate percentages
prop.table(class_satisfaction, margin = 1) * 100

## Visualise
ggplot(airline, aes(x = class, fill = satisfaction)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Passenger Satisfaction by Travel Class",
    x = "Travel Class",
    y = "Percentage of Passengers",
    fill = "Satisfaction"
  ) +
  theme_minimal()

# Hypothesis 1 — Chi-square test
chi_class <- chisq.test(class_satisfaction)

chi_class

## Check expected frequencies
chi_class$expected

## Effect size using Cramer's V
cramers_v <- sqrt(
  as.numeric(chi_class$statistic) /
    (sum(class_satisfaction) * min(
      nrow(class_satisfaction) - 1,
      ncol(class_satisfaction) - 1
    ))
)

cramers_v

# Data preparation for delay analysis
## Create a dataset for delay analysis
delay_data <- airline %>%
  select(satisfaction, departure_delay, arrival_delay) %>%
  drop_na()

## Check the number of observations removed
nrow(airline)
nrow(delay_data)
nrow(airline) - nrow(delay_data)

## Check the distribution of satisfaction groups
table(delay_data$satisfaction)

## Descriptive statistics by satisfaction
delay_data %>%
  group_by(satisfaction) %>%
  summarise(
    n = n(),
    mean_departure_delay = mean(departure_delay),
    median_departure_delay = median(departure_delay),
    sd_departure_delay = sd(departure_delay),
    mean_arrival_delay = mean(arrival_delay),
    median_arrival_delay = median(arrival_delay),
    sd_arrival_delay = sd(arrival_delay)
  )

## Boxplot of departure delay by satisfaction
ggplot(delay_data, aes(x = satisfaction, y = departure_delay)) +
  geom_boxplot() +
  labs(
    title = "Departure Delay by Passenger Satisfaction",
    x = "Satisfaction",
    y = "Departure Delay (minutes)"
  ) +
  theme_minimal()

## Distribution of departure delay
ggplot(delay_data, aes(x = departure_delay)) +
  geom_histogram(bins = 40) +
  labs(
    title = "Distribution of Departure Delay",
    x = "Departure Delay (minutes)",
    y = "Number of Passengers"
  ) +
  theme_minimal()

# Welch Independent Samples t-test
## Compare mean departure delay between satisfaction groups
delay_ttest <- t.test(
  departure_delay ~ satisfaction,
  data = delay_data,
  var.equal = FALSE
)

delay_ttest

## 95% confidence interval
delay_ttest$conf.int

## Group-level descriptive statistics
delay_data %>%
  group_by(satisfaction) %>%
  summarise(
    n = n(),
    mean = mean(departure_delay),
    sd = sd(departure_delay),
    se = sd / sqrt(n)
  )

# Sensitivity Check: Wilcoxon Rank-Sum Test
wilcox_delay <- wilcox.test(
  departure_delay ~ satisfaction,
  data = delay_data,
  exact = FALSE
)

wilcox_delay

# Prepare Logistic Regression Dataset
model_data <- airline %>%
  select(
    satisfied_binary,
    class,
    type_of_travel,
    customer_type,
    age,
    flight_distance,
    departure_delay,
    arrival_delay,
    online_boarding,
    seat_comfort,
    cleanliness,
    on_board_service,
    in_flight_service,
    in_flight_entertainment,
    in_flight_wifi_service,
    baggage_handling
  ) %>%
  drop_na()

## Check dataset size
dim(model_data)

## Check outcome counts
table(model_data$satisfied_binary)

## Check outcome percentages
prop.table(table(model_data$satisfied_binary)) * 100


# EDA Plot 1: Satisfaction by Type of Travel
travel_satisfaction <- table(
  airline$type_of_travel,
  airline$satisfaction
)

prop.table(travel_satisfaction, margin = 1) * 100

ggplot(airline, aes(x = type_of_travel, fill = satisfaction)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Passenger Satisfaction by Type of Travel",
    x = "Type of Travel",
    y = "Percentage of Passengers",
    fill = "Satisfaction"
  ) +
  theme_minimal()

# EDA Plot 2: Age Distribution by Satisfaction
ggplot(airline, aes(x = age, fill = satisfaction)) +
  geom_density(alpha = 0.4) +
  labs(
    title = "Age Distribution by Passenger Satisfaction",
    x = "Age",
    y = "Density",
    fill = "Satisfaction"
  ) +
  theme_minimal()

# EDA Plot 3: Key Service Ratings by Satisfaction
service_data <- airline %>%
  select(
    satisfaction,
    online_boarding,
    seat_comfort,
    cleanliness,
    on_board_service,
    in_flight_service
  ) %>%
  pivot_longer(
    cols = -satisfaction,
    names_to = "service",
    values_to = "rating"
  )

service_data$service <- dplyr::recode(
  service_data$service,
  online_boarding = "Online Boarding",
  seat_comfort = "Seat Comfort",
  cleanliness = "Cleanliness",
  on_board_service = "On-board Service",
  in_flight_service = "In-flight Service"
)

ggplot(
  service_data,
  aes(x = service, y = rating, fill = satisfaction)
) +
  stat_summary(
    fun = mean,
    geom = "bar",
    position = "dodge"
  ) +
  labs(
    title = "Average Service Ratings by Passenger Satisfaction",
    x = "Service Attribute",
    y = "Mean Rating",
    fill = "Satisfaction"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

# Stratified Train/Test Split
set.seed(123)

## Identify satisfied and dissatisfied observations
satisfied_rows <- which(model_data$satisfied_binary == 1)
dissatisfied_rows <- which(model_data$satisfied_binary == 0)

## Select 70% from each group
train_satisfied <- sample(
  satisfied_rows,
  size = floor(0.70 * length(satisfied_rows))
)

train_dissatisfied <- sample(
  dissatisfied_rows,
  size = floor(0.70 * length(dissatisfied_rows))
)

## Combine training observations
train_index <- c(
  train_satisfied,
  train_dissatisfied
)

## Create training and testing datasets
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

## Check sample sizes
nrow(train_data)
nrow(test_data)

## Check class proportions
prop.table(table(train_data$satisfied_binary)) * 100
prop.table(table(test_data$satisfied_binary)) * 100

# Multiple Logistic Regression
logistic_model <- glm(
  satisfied_binary ~
    class +
    type_of_travel +
    customer_type +
    age +
    flight_distance +
    departure_delay +
    arrival_delay +
    online_boarding +
    seat_comfort +
    cleanliness +
    on_board_service +
    in_flight_service +
    in_flight_entertainment +
    in_flight_wifi_service +
    baggage_handling,
  data = train_data,
  family = binomial
)

## Display model results
summary(logistic_model)

# Odds Ratios and 95% Confidence Intervals
odds_ratios <- exp(coef(logistic_model))

odds_ratio_ci <- exp(confint(logistic_model))

odds_ratio_results <- cbind(
  Odds_Ratio = odds_ratios,
  Lower_95_CI = odds_ratio_ci[, 1],
  Upper_95_CI = odds_ratio_ci[, 2]
)

round(odds_ratio_results, 3)

# Statistical Significance of Predictors
model_coefficients <- summary(logistic_model)$coefficients

significant_predictors <- model_coefficients[
  model_coefficients[, "Pr(>|z|)"] < 0.05,
  ,
  drop = FALSE
]

significant_predictors

# Multicollinearity Check
vif_values <- vif(logistic_model)

vif_values

# Overall Model Fit
## Null model
null_model <- glm(
  satisfied_binary ~ 1,
  data = train_data,
  family = binomial
)

## Likelihood-ratio test
anova(
  null_model,
  logistic_model,
  test = "Chisq"
)

## AIC
AIC(logistic_model)

## McFadden's pseudo R-squared
mcfadden_r2 <- 1 -
  logistic_model$deviance /
  logistic_model$null.deviance

mcfadden_r2

# Test Set Predictions
test_probabilities <- predict(
  logistic_model,
  newdata = test_data,
  type = "response"
)

test_predictions <- ifelse(
  test_probabilities >= 0.5,
  1,
  0
)

# View first predictions
head(test_probabilities)
head(test_predictions)

# Confusion Matrix
confusion_matrix <- table(
  Predicted = test_predictions,
  Actual = test_data$satisfied_binary
)

confusion_matrix

# Model Performance Metrics
TP <- confusion_matrix["1", "1"]
TN <- confusion_matrix["0", "0"]
FP <- confusion_matrix["1", "0"]
FN <- confusion_matrix["0", "1"]

accuracy <- (TP + TN) / sum(confusion_matrix)

precision <- TP / (TP + FP)

recall <- TP / (TP + FN)

f1_score <- 2 * (
  precision * recall
) / (
  precision + recall
)

performance <- data.frame(
  Metric = c(
    "Accuracy",
    "Precision",
    "Recall",
    "F1 Score"
  ),
  Value = c(
    accuracy,
    precision,
    recall,
    f1_score
  )
)

performance

# ROC Curve and AUC
roc_model <- roc(
  test_data$satisfied_binary,
  test_probabilities
)

plot(
  roc_model,
  main = "ROC Curve for Airline Passenger Satisfaction Model"
)

auc_value <- auc(roc_model)

auc_value

# Find an Alternative Classification Threshold
coords(
  roc_model,
  "best",
  ret = c(
    "threshold",
    "sensitivity",
    "specificity"
  )
)

# Linearity of the Logit for Continuous Predictors
## Check age
age_check <- train_data %>%
  mutate(age_group = cut(
    age,
    breaks = 10,
    include.lowest = TRUE
  )) %>%
  group_by(age_group) %>%
  summarise(
    mean_age = mean(age),
    satisfaction_rate = mean(satisfied_binary),
    .groups = "drop"
  )

ggplot(age_check, aes(x = mean_age, y = satisfaction_rate)) +
  geom_point() +
  geom_line() +
  labs(
    title = "Satisfaction Rate Across Age Groups",
    x = "Mean Age",
    y = "Satisfaction Rate"
  ) +
  theme_minimal()

## Check flight distance
distance_check <- train_data %>%
  mutate(distance_group = cut(
    flight_distance,
    breaks = 10,
    include.lowest = TRUE
  )) %>%
  group_by(distance_group) %>%
  summarise(
    mean_distance = mean(flight_distance),
    satisfaction_rate = mean(satisfied_binary),
    .groups = "drop"
  )

ggplot(
  distance_check,
  aes(x = mean_distance, y = satisfaction_rate)
) +
  geom_point() +
  geom_line() +
  labs(
    title = "Satisfaction Rate Across Flight Distance Groups",
    x = "Mean Flight Distance",
    y = "Satisfaction Rate"
  ) +
  theme_minimal()

# Logistic Regression Diagnostic Plots

par(mfrow = c(2, 2))
plot(logistic_model)
par(mfrow = c(1, 1))
