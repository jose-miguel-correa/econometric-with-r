#pull the data
dataset <- read.csv("njmin3.csv")
summary(dataset)

#taking care of missing data
dataset$fte <- ifelse(is.na(dataset$fte),
                      mean(dataset$fte, na.rm = TRUE),
                      dataset$fte)
dataset$demp <- ifelse(is.na(dataset$demp),
                       mean(dataset$demp, na.rm = TRUE),
                      dataset$demp)
summary(dataset)

#create the first regression model
model1 <- lm(fte ~ NJ + POST_APRIL92 + NJ_POST_APRIL92,
             data = dataset)
summary(model1)

#create 2nd regression model
model2 <- lm(fte ~ NJ + POST_APRIL92 + NJ_POST_APRIL92 +
               bk + kfc + wendys,
             data = dataset)
summary(model2)

#Create third regression model
model3 <- lm(fte ~ NJ + POST_APRIL92 + NJ_POST_APRIL92 +
               bk + kfc + wendys +
               co_owned + centralj + southj,
             data = dataset)
summary(model3)

par(mfrow = c(2, 2))
plot(model3)

# Actual vs Predicted for Model 3 using ggplot2
ggplot(dataset, aes(x = fte, y = pred3)) +
  geom_point(color = "green") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Model 3: Actual vs Predicted",
       x = "Actual fte", y = "Predicted fte") +
  theme_bw()

# Interaction plot for NJ and POST_APRIL92
with(dataset, interaction.plot(POST_APRIL92, NJ, fte,
                               xlab = "POST_APRIL92", ylab = "fte", trace.label = "NJ"))


# Plot coefficients for all models
coefplot(model1, model2, model3, intercept = TRUE, title = "Coefficient Comparison Between Models")

# Extract coefficients and confidence intervals from each model
model1_df <- broom::tidy(model1, conf.int = TRUE) %>% mutate(model = "Model 1")
model2_df <- broom::tidy(model2, conf.int = TRUE) %>% mutate(model = "Model 2")
model3_df <- broom::tidy(model3, conf.int = TRUE) %>% mutate(model = "Model 3")

# Combine into one data frame

models_df <- bind_rows(model1_df, model2_df, model3_df)


# Create the coefficient plot
dwplot(models_df, dodge_size = 0.4) +
  theme_bw() +
  labs(title = "Coefficient Comparison Between Models",
       x = "Coefficient Estimate",
       y = "") +
  theme(plot.title = element_text(hjust = 0.5))



#visualize results
#install.packages("stargazer")
library(stargazer)
stargazer(model1, model2, model3,
          type = "text",
          title = "Impact of minimum wage on employment",
          no.space = TRUE,
          keep.stat = "n",
          digits = 2)


# Calculate predicted values for each model
dataset$pred1 <- predict(model1)
dataset$pred2 <- predict(model2)
dataset$pred3 <- predict(model3)

# Set up the plotting area to have 1 row and 3 columns
par(mfrow = c(1, 3))

# Plot for Model 1
plot(dataset$fte, dataset$pred1,
     main = "Model 1: Actual vs Predicted",
     xlab = "Actual fte", ylab = "Predicted fte",
     pch = 16, col = "blue")
abline(0, 1, col = "red", lwd = 2)  # Reference line

# Plot for Model 2
plot(dataset$fte, dataset$pred2,
     main = "Model 2: Actual vs Predicted",
     xlab = "Actual fte", ylab = "Predicted fte",
     pch = 16, col = "green")
abline(0, 1, col = "red", lwd = 2)

# Plot for Model 3
plot(dataset$fte, dataset$pred3,
     main = "Model 3: Actual vs Predicted",
     xlab = "Actual fte", ylab = "Predicted fte",
     pch = 16, col = "purple")
abline(0, 1, col = "red", lwd = 2)

# Reset plotting area
par(mfrow = c(1, 1))










