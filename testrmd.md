---
output:
  html_document: default
  word_document: default
  pdf_document: default
---
## 1.1.	Methanol price analysis

To assess methanol price dependence, we have run correlation analysis between methanol prices and main factors: oil prices, coal prices and euro exchange rate

From a wide range of factors that are used in the company forecasting system, it is possible to select three that have the highest correlation with the price of methanol.

- The first is the price of gas, with a correlation of 0.906. The factor demonstrates a strong relationship with the price of methanol and is present in all models, regardless of the estimation interval.

- The second factor is the price of oil, with a correlation of 0.805. The factor also demonstrates a strong relationship with the price of methanol and is present in all models, regardless of the estimation interval.

- The third factor is the price of Australian coal, which correlates with 0.516. The factor begins to significantly influence after the 2008-2009 crisis.

In addition, the analysis of the impact of the growth rate of world GDP on the price of methanol was carried out. The chart below shows that significant downward pressure on prices occurs during periods of low and negative GDP growth. The main example of such a period is Q2 and Q3 2020 amid restrictions due to the coronavirus pandemic. It is not possible to find a stable connection for periods of more calm growth in the analysed interval.

An analysis of the directions of the relationship between the variables shows that the most correct models are obtained when using data from 2012.



```
## Error in path.expand(path): invalid 'path' argument
```

```
## Error in path.expand(path): invalid 'path' argument
```

Using these correlations, we created combined methanol price model depending on oil prices, coal prices and the euro / dollar exchange rate:


```
## Error in path.expand(path): invalid 'path' argument
```

```
## Error in path.expand(path): invalid 'path' argument
```
-	For almost 9 years since 2012, there have been two periods of price increases and two periods of price decreases. All these movements can be explained using a three-factor model. At the same time, model estimates are smoother, and real data are more volatile.
-	In the process of modeling, the possibility of delayed influence of factors was taken into account. The analysis showed that the best quality model is obtained using gas prices with a lag of one month.
-	The final equation of the methanol price model:
Methanol price (`$`) = 61.2 + 0.624 * Brent price (`$`) + 27.32 * Gas price (`$`) + 0.628 * Coal price (`$`)
-	The R-square index of the model is 0.830.
-	The model does not use the autoregressive component, since the analysis showed that when using it, forecasts for 1-3 months are improved, but the accuracy of forecasts for periods of more than 3 months decreases due to the underestimated influence of other factors.


## Methanol forecast

Using the model described above we ran predictive simulation of methanol prices in 3 distinct oil scenarios.

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>year</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>oil</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>euro</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>coal</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>gdp</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>gas</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>methanol</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>gdp_less_1</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>model</th>
<th style='padding-left: 1em; font-family: Panton; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;'>err</th>
</tr>
</thead>
<tbody>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2012</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>101.981784845454</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.43387001252214</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>86.5860722072907</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.08876466626792</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>10.2394745402009</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>440.712518076378</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>459.031695971295</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.0415671830128095</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2013</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>120.64979051004</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.23612752339748</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>81.1625624945347</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2.61852522192059</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>11.560642916694</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>534.085326008545</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>503.363191308705</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.0575228960687608</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2014</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>67.4588542334582</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24612565471194</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>67.4909126620702</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2.86932681220107</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>7.83278393823013</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>340.907799422328</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>359.735137928679</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.0552270688387118</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2015</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>40.8327954829559</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.00924862045023</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>50.3974840077218</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2.81548900806371</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>5.49272704225732</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>234.331715116386</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>268.445961734192</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.145581005118586</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2016</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>57.0274671451487</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.996050098886062</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>84.7081921400949</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2.7082812976313</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>5.19280952759029</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>290.320894778671</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>291.933516576903</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.00555461844887506</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2017</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>58.5055220682118</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.28200041578028</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>99.6197434482686</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>3.1941020497585</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>7.69086160011093</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>332.055285398687</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>370.471661911061</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.115692712032122</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2018</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>55.5405431792289</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.03612948157499</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>100.066975972602</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2.88107112631098</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>8.76924568064744</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>306.03977454984</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>398.360864633874</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.301663697863559</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2019</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>60.4067801605817</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.21843972830468</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>60.7732007344868</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2.35622611294959</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.45733770488203</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>235.107143511827</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>258.902157511928</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0.101209234414029</td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2020</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>44.2200014732927</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.21652612052529</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>58.941562063247</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>-2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>3.96062192470767</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>-2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>234.079245568887</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2021</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>45</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>63.69</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>3.66448886194379</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>229.462141119045</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2022</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>45</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.22</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>69.6080065625</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.88572420088728</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>266.543925775684</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2023</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>45</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>74.27375</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>5.05664274751648</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>274.146581578167</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2024</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>45</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>5.29190037015231</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>281.40706346754</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2025</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>45.99</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.22940806641501</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>253.000576098195</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2026</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>47.00178</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.32245504387614</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>256.173825740355</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2027</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>48.03581916</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.41754905484142</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>259.416886874643</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2028</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>49.09260718152</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.51473513404793</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>262.731295353885</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2029</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>50.1726445395134</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.61405930699698</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>266.11862081967</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2030</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>51.2764427193827</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.71556861175092</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>269.580467445703</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2031</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>52.4045244592092</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.81931112120944</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>273.118474697509</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2032</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>53.5574239973118</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>4.92533596587605</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>276.734318108854</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2033</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>54.7356873252526</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>5.03369335712532</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>280.429710075249</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2034</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>55.9398724464082</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>5.14443461098208</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'>284.206400664904</td>
<td style='padding-left: 1em; font-family: Panton; text-align: left;'></td>
</tr>
<tr>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>2035</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>57.1705496402292</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>1.24</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>75.6</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>2</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>5.25761217242368</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'></td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>0</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'>288.066178447532</td>
<td style='padding-left: 1em; font-family: Panton; border-bottom: 2px solid grey; text-align: left;'></td>
</tr>
</tbody>
</table>
