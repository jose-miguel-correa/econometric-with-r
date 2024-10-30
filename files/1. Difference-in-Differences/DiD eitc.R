#pull the data
#install.packages("haven")
library(haven)
dataset <- read_dta("eitc.dta")

#Create dummy variables
dataset$post93 <- ifelse(dataset$year > 1993, 1, 0)
dataset$mom <- ifelse(dataset$children > 0, 1, 0)
dataset$mom_post93 <- dataset$post93 * dataset$mom

#Creating first logistic regression model
model1 <- glm(work ~ post93 + mom + mom_post93,
              family = 'binomial',
              data = dataset)
summary(model1)

#Second logistic regression model
model2 <- glm(work ~ post93 + mom + mom_post93
              + nonwhite + ed,
              family = 'binomial',
              data = dataset)
summary(model2)

library(sjPlot)
# Render summary with sjPlot
tab_model(model2, title = "Logistic Regression Results")

# Install if necessary
install.packages("gt")

# Load libraries
library(gt)
library(broom)

# Convert model summary to a tidy format and create a gt table
model_summary <- tidy(model2)

# Customize the gt table
model_summary %>%
  gt() %>%
  tab_header(
    title = "Logistic Regression Results",
    subtitle = "Summary of model2"
  ) %>%
  fmt_number(
    columns = vars(estimate, std.error, statistic, p.value),
    decimals = 3
  ) %>%
  cols_label(
    term = "Term",
    estimate = "Estimate",
    std.error = "Std. Error",
    statistic = "Z-Value",
    p.value = "P-Value"
  )



#visualize regression results
#install.packages("stargazer")
library(stargazer)

models_strgzr = stargazer(model1, model2,
          type = "text",
          align = TRUE,
          covariate.labels = c("After 1993", "Is mom", "Is mom after 1993",
                               "Hispanic or white", "Years of education"
                               ),
          digits = 2,
          no.space = TRUE)

models_strgzr
tab_model(model1, model2)


#create placebo variables
dataset$post92 <- ifelse(dataset$year > 1992, 1, 0)
dataset$mom_post92 <- dataset$post92 * dataset$mom

#create placebo dataset
dataset_placebo <- subset(dataset, dataset$year < 1994)

#Create logistic regression for placebo experiment
#Creating first logistic regression model
model_placebo <- glm(work ~ post92 + mom + mom_post92,
              family = 'binomial',
              data = dataset_placebo)
tab_model(model_placebo)











