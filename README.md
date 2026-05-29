# Nashville_Housing_Analysis

## Project Overview
This project analyses 56,372 recorded property transactions across the Nashville metropolitan area from 2013 to 2016 — one of the most significant real estate booms in recent US history.

The analysis follows the full data science pipeline:
Raw SQL data → Python cleaning → Exploratory analysis → Formal statistical testing → Feature engineering → Predictive modelling → Market segmentation
Every finding is grounded in formal statistical testing, with effect sizes reported alongside p-values to distinguish practical significance from statistical noise.

## Objectives
1) Predict sale price from information a buyer or seller typically has at hand, and identify which property characteristics carry the most predictive weight.
2) Segment the market into natural property groups and characterise what separates premium from mid-market properties.
3) Confirm whether observed price differences across cities, property types, and construction eras are statistically meaningful - not artefacts of sample size.

## Key Findings
1) Location: Brentwood commands +21% over Nashville median; Madison sits 46% below. City effects explain more price variation than any structural feature.
2) Land Value: Strongest single predictor (Spearman r = 0.50). What buyers pay for is the land - the building is secondary.
3) Building Quality: Bathrooms correlate more strongly with price (r = 0.33) than bedrooms (r = 0.23). Size and finish quality beat room count.
4) Property Age: U-shaped relationship confirmed. Price dips at ~47 years; pre-1900 heritage and 2010+ modern builds both command premiums.
                 The 1980s are the value decade.
5) Market Demand: 75%+ of properties sold above assessed value (median ratio 1.28). Pre-1960 stock reached ratios of 1.37+, signalling persistent under-assessment.

## Market Highlights:
Median sale prices grew from ~$185K (2013) to ~$229K (2016), a 24% cumulative increase in three years.
Madison recorded the fastest single-family price growth at +43%, starting from the lowest base ($125K median).
A consistent Q2 (spring) seasonal peak was visible each year.

## Repository Structure:
Nashville_Housing_Analysis:

1) nashville_housing_raw.xlsx          # Source dataset (56,477 rows)
2) sql: data_cleaning.sql              # SQL Server cleaning scripts
3) data_cleaning.ipynb              # Python cleaning & imputation
4) exploratory_analysis.ipynb       # EDA & visualisations
5) statistical_analysis.ipynb       # Hypothesis testing
6) feature_engineering.ipynb        # Feature creation
7) modelling_segmentation.ipynb     # Regression & clustering

8) Nashville_Housing_Data_Analysis_Report.pdf  # Full written report
9) README.md

## Tools & Technologies:
1) Database & SQL: SQL Server, T-SQL (CTEs, window functions, PARSENAME)
2) Data Manipulation: Python, pandas, NumPy
3) Visualisation: Matplotlib, Seaborn
4) Statistical Testing: SciPy (Kruskal-Wallis, Mann-Whitney U, Dunn test)
5) Modelling: scikit-learn, XGBoost, LightGBM, statsmodels
6) Dimensionality Reduction: PCA (sklearn)
7) Clustering: K-Means (sklearn)

## Model Results:
All models predict log(Sale Price) on an 80/20 train/test split across 30 features.

<img width="745" height="412" alt="image" src="https://github.com/user-attachments/assets/8a70cb13-db9a-4c20-98e8-95866ef4d7ca" />

XGBoost is recommended. The remaining ~55% of unexplained variance reflects data not in this dataset: interior condition, renovation quality, and square footage.


## Market Segments:
K-Means clustering (k=2, silhouette score = 0.530) identified two distinct segments:

<img width="800" height="187" alt="image" src="https://github.com/user-attachments/assets/7697a056-83a1-4b6a-b8b9-00cf10199347" />


## Getting Started:
pip install pandas numpy matplotlib seaborn scipy scikit-learn xgboost lightgbm statsmodels openpyxl

#### Run SQL cleaning first, then notebooks in order
jupyter notebook notebooks/01_data_cleaning.ipynb

The full methodology, statistical test outputs, and model diagnostics are documented in [Nashville_Housing_Data_Analysis_Report.pdf].







