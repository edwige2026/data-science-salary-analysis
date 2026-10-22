# Step 1: inspect source data quality and save a transparent quality report.
source("R/00_setup.R")

salary_raw <- load_raw_salary_data()
salary_clean <- clean_salary_data(salary_raw)

missing_cells <- sum(is.na(salary_raw))
exact_duplicate_rows <- sum(duplicated(salary_raw))
rows_after_drop_na <- nrow(tidyr::drop_na(salary_raw))

quality_report <- data.frame(
  metric = c(
    "source_rows",
    "source_columns",
    "missing_cells",
    "exact_duplicate_rows",
    "rows_after_drop_na",
    "rows_after_drop_na_and_exact_deduplication",
    "distinct_job_titles",
    "salary_min_usd",
    "salary_median_usd",
    "salary_mean_usd",
    "salary_max_usd",
    "min_work_year",
    "max_work_year"
  ),
  value = as.character(c(
    nrow(salary_raw),
    ncol(salary_raw),
    missing_cells,
    exact_duplicate_rows,
    rows_after_drop_na,
    nrow(salary_clean),
    dplyr::n_distinct(salary_clean$job_title),
    min(salary_clean$salary_in_usd, na.rm = TRUE),
    median(salary_clean$salary_in_usd, na.rm = TRUE),
    round(mean(salary_clean$salary_in_usd, na.rm = TRUE), 2),
    max(salary_clean$salary_in_usd, na.rm = TRUE),
    min(salary_clean$work_year, na.rm = TRUE),
    max(salary_clean$work_year, na.rm = TRUE)
  )),
  stringsAsFactors = FALSE
)

readr::write_csv(
  quality_report,
  file.path("outputs", "tables", "data_quality_report.csv")
)
readr::write_csv(
  salary_clean,
  file.path("data", "processed", "salaries_clean.csv")
)

cat("Data quality report written to outputs/tables/data_quality_report.csv\n")
cat("Rows in source:", nrow(salary_raw), "\n")
cat("Exact duplicate rows:", exact_duplicate_rows, "\n")
cat("Rows after cleaning:", nrow(salary_clean), "\n")
