#define pre and post period dates
start = "2016-01-01"
treatment = "2018-03-17"
end = "2018-07-17"


library(BatchGetSymbols)
stocks <- c("Meta", "WMT", "DIS", "BMW.DE", "NVS")
data <- BatchGetSymbols(tickers = stocks, first.date = start, last.date = end)
head(data$df.tickers)
data2 <- data.frame(data)
data3 <- data2 %>% select(df.tickers.ref.date, df.tickers.price.close, df.control.ticker)

#retrieve data
#install.packages("tseries")
library(tseries)
Facebook <- get.hist.quote(instrument = "Meta",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m",)
Walmart <- get.hist.quote(instrument = "WMT",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
Disney <- get.hist.quote(instrument = "DIS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
BMW <- get.hist.quote(instrument = "BMW.DE",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
Novartis <- get.hist.quote(instrument = "NVS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
Goldman_sachs <- get.hist.quote(instrument = "GS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
GE <- get.hist.quote(instrument = "GE",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
Heinz <- get.hist.quote(instrument = "KHC",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
McDonalds <- get.hist.quote(instrument = "MCD",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")
Carlsberg <- get.hist.quote(instrument = "CARL-B.CO",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "m")


#plotting data
series <- cbind(Facebook, Walmart, Disney, BMW, Novartis, Goldman_sachs,
                GE, Heinz, McDonalds, Carlsberg)

series <- cbind(Facebook, Walmart, Disney, BMW, Novartis)
                
series <- na.omit(series)
#install.packages("ggplot2")
library(ggplot2)
autoplot(series, facet = NULL) + xlab("time") + ylab("Price Close")
#autoplot(series) + xlab("time") + ylab("Price Close")


library(tidyverse)

# Assuming your data frame is named 'data3' with columns: date, stock_price, and ticker
data3_wide <- data3 %>%
  pivot_wider(
    names_from = ticker,        # Column to turn into new column names
    values_from = stock_price    # Column to fill with values
  )

# Display the transformed data frame
print(data3_wide)

#from dataframe to zoo
data3_tozoo <- zoo(data3$df.tickers.ref.date, order.by = data3$df.tickers.ref.date)
data3_tozoo
autoplot(data3_tozoo) + xlab("time") + ylab("Price Close")


#correlation check
dataset_cor <- window(series, start = start, end = treatment)
dataset_cor <- as.data.frame(dataset_cor)
cor(dataset_cor)

#selecting the final dataset
final_series <- cbind(Facebook, Walmart, Goldman_sachs, McDonalds, Carlsberg)
final_series <- na.omit(final_series)
autoplot(final_series, facet = NULL) + xlab("time") + ylab("Price Close")

#Create pre and post period objects
pre.period <- as.Date(c(start, treatment))
post.period <- as.Date(c(treatment, end))

#Running Causal Impact
#install.packages("CausalImpact")
library(CausalImpact)
impact <- CausalImpact(data = final_series,
                       pre.period = pre.period,
                       post.period = post.period,
                       model.args = list(niter = 2000,
                                         nseasons = 52))

#Visualize results
plot(impact)
summary(impact)
summary(impact, "report")



























