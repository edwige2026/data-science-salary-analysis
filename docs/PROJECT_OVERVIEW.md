# Project overview

## Business context

A student entering the data and analytics job market wants to understand how recorded salaries vary across role titles, experience levels, and years. This project transforms that broad question into a reproducible exploratory analysis and a small prediction baseline.

## Objectives

- Understand the structure and quality of the supplied dataset.
- Describe salary distributions using robust summaries such as medians and quartiles.
- Compare salary records by experience level, year, and job title.
- Quantify the association between year and salary without implying causality.
- Build and evaluate a transparent baseline regression model.

## Scope

The dataset contains job-salary records from 2020–2024. The analysis uses `salary_in_usd` as the comparable outcome, excludes the original local-currency `salary` field from the regression, and removes exact duplicate rows for its primary exploratory summaries. The source record count and duplicate count are retained in the quality report.

## Questions

1. How are the recorded USD salaries distributed?
2. How do salary medians differ by experience level?
3. Does the year-wise median show a clear monotonic pattern?
4. Which job titles have higher observed medians when a minimum group size is required?
5. How well does a simple regression baseline perform on a held-out sample compared with predicting the training median?

## Success criteria

The project is complete when another user can download the source CSV, run one command in RStudio, regenerate the summary tables and charts, and inspect model evaluation metrics and the documented limitations.
