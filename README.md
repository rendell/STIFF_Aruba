# STIF_Aruba

Short Term Inflation Forecast for Aruba

this repo contains Eviews code for running the STIF model.
The required data would be an adjusted version of components obtained from the 12-digit disagregated inflation data obtainable in excel format from the Central Bureau of Statistics Aruba.

Within this file, it is possible to construct the following components:
(1)  Housing index excl. energy component 
(2)  Transport index excl. energy components 
(3)  Food and non-alcoholic beverages 
(4)  Alcoholic beverages and tobacco 
(5)  Clothing and footwear 
(6)  Household operation 
(7)  Health 
(8)  Communications 
(9)  Recreation and culture 
(10) Education 
(11) Restaurants and hotels 
(12) Miscellaneous goods and services 
(13) Gasoline and diesel 
(14) Water 
(15) Electricity 

In essence, most variables are forecast using ARIMA.
Water and electricity are forecasted exogenously based on information gathered through comversations with officials of the water and electricity companies.
Gasoline is forecasted through OLS with the independent variable beeing Brent oil price forecasts.

The model also creates various inflation measures, including end of period inflation and 12-minth inflation per component. 

Further methodological reference consult the Bank of England STIFF model manuals.


 


