# janitorID

> **Extended Data Cleaning Toolkit with Currency Conversion & Health Analytics**

Data scientists, according to interviews and expert estimates, spend from 50 percent to 80 percent of their time mired in this more mundane labor of collecting and preparing unruly digital data, before it can be explored for useful nuggets.

– "For Big-Data Scientists, 'Janitor Work' Is Key Hurdle to Insight" (New York Times, 2014)

[![R-CMD-check](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg)](https://www.r-project.org/)

---

## 📌 What is janitorID?

`janitorID` is an **extension and modification** of the popular `janitor` package by Sam Firke. It inherits the core philosophy of `janitor`—simple, user-friendly functions for examining and cleaning dirty data—but adds **new capabilities** for currency analytics and automated data health assessment.

### What is Inherited from the Original `janitor` Package?

From the original `janitor` package, `janitorID` preserves:

| Feature | Description |
|---------|-------------|
| **Tabulation Tools** | `tabyl()` for creating frequency tables of one, two, or three variables |
| **Data Cleaning Philosophy** | Simple, pipe-friendly functions for data preparation |
| **Tidyverse Integration** | Seamless compatibility with `%>%` pipes and `dplyr` workflows |
| **User-Friendliness** | Designed for both beginning and intermediate R users |

### What is Added/Modified in `janitorID`?

`janitorID` extends the original `janitor` package with **five major new capabilities**:

| New Feature | Description | Why It Matters |
|-------------|-------------|----------------|
| 💱 **Real-Time Currency Conversion** | Convert values across 146 world currencies using live exchange rates from a free API | Enables financial and international data analysis without manual rate lookups |
| 🧹 **Automated Data Cleaning Pipeline** | `auto_analyze()`: One-function solution for profiling, cleaning (missing values, outliers, duplicates), and reporting | Reduces repetitive data preparation work from hours to seconds |
| 📊 **Health Dashboard** | `plot_data_health()`: Interactive visualization of missing patterns, outliers, correlations, and distributions | Provides instant visual assessment of data quality |
| 📋 **Statistical Inference Reports** | `tabyl_to_statistical_report_console()`: Generate Chi-square tests, Cramer's V, and Odds Ratio directly from contingency tables | Bridges the gap between data cleaning and statistical analysis |
| 🎨 **Professional Visualizations** | `ggheatmap_tabyl()` and `plot_tabyl_sunburst_v2()`: Heatmaps and sunburst charts from tabyl objects | Enhances exploratory data analysis with publication-ready graphics |

### Why These Additions Were Made?

| Addition | Rationale |
|----------|-----------|
| **Currency Conversion** | Many real-world datasets involve financial data across different countries. No existing R package combines data cleaning with real-time currency conversion. |
| **Auto Cleaning Pipeline** | Users often perform the same cleaning steps repeatedly. This automation saves time and reduces errors. |
| **Health Dashboard** | Visual assessment of data quality is faster and more intuitive than numerical summaries alone. |
| **Statistical Reports** | After cleaning data, users typically want to test hypotheses. Integrating statistical inference reduces context switching. |
| **Professional Visualizations** | Effective communication of insights requires polished graphics. These functions make it effortless. |

---

## 🔧 Installation

You can install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("nnnaaakar209-sketch/janitorID")
