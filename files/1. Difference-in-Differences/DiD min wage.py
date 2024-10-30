
#importing the libraries
import numpy as np
import pandas as pd

#pulling the data
dataset = pd.read_csv('njmin3.csv')

#check our data
dataset.describe()
pd.set_option('display.max_columns', None)

#check if there are more NAs
dataset.isnull().any()

#replacing NAs with averages
from sklearn.impute import SimpleImputer

missingvalues = SimpleImputer(missing_values = np.nan,
                              strategy = 'mean')
missingvalues = missingvalues.fit(dataset[['fte', 'demp']])
dataset[['fte', 'demp']] = missingvalues.transform(dataset[['fte', 'demp']])

#check if there are more NAs
dataset.isnull().any()

#isolating the X and Y variables
X = dataset.iloc[:, 0:3].values
Y = dataset.iloc[:, 3].values

#creating the first model
import statsmodels.api as sm

X = sm.add_constant(X)
model1 = sm.OLS(Y, X).fit()
model1.summary(yname = "FTE",
               xname = ("intercept", "New Jersey", "After April 1992",
                        "New Jersey and after April 1992"))

#isolating the X and Y variables part 2
X = dataset.loc[:, ['NJ', 'POST_APRIL92', 'NJ_POST_APRIL92',
                'bk', 'kfc', 'wendys']].values

#creating the second model
import statsmodels.api as sm

X = sm.add_constant(X)

model2 = sm.OLS(Y, X).fit()

model2.summary(yname = "FTE",
               xname = ("intercept", "New Jersey", "After April 1992",
                        "New Jersey and after April 1992",
                        "Burger King", "KFC", "Wendy's"))

#isolating the X and Y variables part 2
X = dataset.loc[:, ['NJ', 'POST_APRIL92', 'NJ_POST_APRIL92',
                'bk', 'kfc', 'wendys',
                'co_owned', 'centralj', 'southj']].values

#creating the third model
import statsmodels.api as sm

X = sm.add_constant(X)

model3 = sm.OLS(Y, X).fit()

model3.summary(yname = "FTE",
               xname = ("intercept", "New Jersey", "After April 1992",
                        "New Jersey and after April 1992",
                        "Burger King", "KFC", "Wendy's",
                        "Co-owned", "Central J", "South J"))
                        
from statsmodels.iolib.summary2 import summary_col

models = [model1, model2, model3]
summary = summary_col(models, stars=True, model_names=["Model 1", "Model 2", "Model 3"])

print(summary)
          
import pandas as pd

def extract_model_info(model, model_name):
    return pd.DataFrame({
        "Model": model_name,
        "Coefficients": model.params,
        "Std Errors": model.bse,
        "P-values": model.pvalues
    })

models_info = [
    extract_model_info(model1, "Model 1"),
    extract_model_info(model2, "Model 2"),
    extract_model_info(model3, "Model 3")
]

comparison_table = pd.concat(models_info, axis=0)
print(comparison_table)
                        
                        
import matplotlib.pyplot as plt

models = [model1, model2, model3]
model_names = ["Model 1", "Model 2", "Model 3"]

coefficients = [model.params for model in models]

for i, coef in enumerate(coefficients):
    plt.plot(coef, label=model_names[i])

plt.xlabel("Coefficient Index")
plt.ylabel("Coefficient Value")
plt.legend()
plt.title("Comparison of Coefficients Across Models")
plt.show()
                        










































































