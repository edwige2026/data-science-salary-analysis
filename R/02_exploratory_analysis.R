# Step 2: create descriptive tables and exploratory charts.
source("R/00_setup.R")

salary_raw <- load_raw_salary_data()
salary <- clean_salary_data(salary_raw)

experience_labels <- c(
  EN = "Entry-level",
  MI = "Mid-level",
  SE = "Senior",
  EX = "Executive"
)

salary <- salary |>
  dplyr::mutate(
    experience_label = factor(
      experience_level,
      levels = names(experience_labels),
      labels = unname(experience_labels)
    ),
    remote_ratio_label = factor(
      remote_ratio,
      levels = c(0, 50, 100),
      labels = c("0% remote", "50% remote", "100% remote")
    )
  )

salary_by_experience <- salary |>
  dplyr::group_by(experience_label) |>
  dplyr::summarise(
    n = dplyr::n(),
    median_salary_usd = median(salary_in_usd),
    mean_salary_usd = mean(salary_in_usd),
    q1_salary_usd = as.numeric(stats::quantile(salary_in_usd, 0.25)),
    q3_salary_usd = as.numeric(stats::quantile(salary_in_usd, 0.75)),
    .groups = "drop"
  ) |>
  dplyr::arrange(experience_label)

salary_by_year <- salary |>
  dplyr::group_by(work_year) |>
  dplyr::summarise(
    n = dplyr::n(),
    median_salary_usd = median(salary_in_usd),
    mean_salary_usd = mean(salary_in_usd),
    .groups = "drop"
  ) |>
  dplyr::arrange(work_year)

minimum_job_count <- 30L
top_job_titles <- salary |>
  dplyr::group_by(job_title) |>
  dplyr::summarise(
    n = dplyr::n(),
    median_salary_usd = median(salary_in_usd),
    mean_salary_usd = mean(salary_in_usd),
    .groups = "drop"
  ) |>
  dplyr::filter(n >= minimum_job_count) |>
  dplyr::arrange(dplyr::desc(median_salary_usd)) |>
  dplyr::slice_head(n = 15)

correlation_report <- data.frame(
  variable_x = "work_year",
  variable_y = "salary_in_usd",
  pearson_correlation = stats::cor(salary$work_year, salary$salary_in_usd),
  n = nrow(salary)
)

readr::write_csv(salary_by_experience, "outputs/tables/salary_by_experience.csv")
readr::write_csv(salary_by_year, "outputs/tables/salary_by_year.csv")
readr::write_csv(top_job_titles, "outputs/tables/top_job_titles_by_median_salary.csv")
readr::write_csv(correlation_report, "outputs/tables/year_salary_correlation.csv")

usd_label <- scales::label_dollar(prefix = "$", big.mark = ",", accuracy = 1)

p_distribution <- ggplot2::ggplot(salary, ggplot2::aes(x = salary_in_usd)) +
  ggplot2::geom_histogram(bins = 40, fill = "#2F6B7C", color = "white", alpha = 0.95) +
  ggplot2::geom_vline(
    xintercept = median(salary$salary_in_usd),
    color = "#D97757", linewidth = 1, linetype = "dashed"
  ) +
  ggplot2::coord_cartesian(xlim = c(0, stats::quantile(salary$salary_in_usd, 0.98))) +
  ggplot2::scale_x_continuous(labels = usd_label) +
  ggplot2::labs(
    title = "Salary distribution in the dataset",
    subtitle = "Exact duplicates removed; displayed x-axis ends at the 98th percentile",
    x = "Annual salary (USD)", y = "Number of records",
    caption = "Dashed line: median salary. The upper tail is clipped for readability."
  ) +
  ggplot2::theme_minimal(base_size = 12)

p_experience <- ggplot2::ggplot(
  salary_by_experience,
  ggplot2::aes(x = experience_label, y = median_salary_usd)
) +
  ggplot2::geom_col(fill = "#2F6B7C", width = 0.68) +
  ggplot2::geom_text(
    ggplot2::aes(label = usd_label(median_salary_usd)),
    vjust = -0.45, size = 3.6, color = "#263238"
  ) +
  ggplot2::scale_y_continuous(labels = usd_label, expand = ggplot2::expansion(mult = c(0, 0.15))) +
  ggplot2::labs(
    title = "Median salary by experience level",
    subtitle = "Records with missing values and exact duplicates removed",
    x = NULL, y = "Median annual salary (USD)"
  ) +
  ggplot2::theme_minimal(base_size = 12) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 0, hjust = 0.5))

p_year <- ggplot2::ggplot(
  salary_by_year,
  ggplot2::aes(x = work_year, y = median_salary_usd)
) +
  ggplot2::geom_line(color = "#2F6B7C", linewidth = 1.1) +
  ggplot2::geom_point(color = "#D97757", size = 3) +
  ggplot2::geom_text(
    ggplot2::aes(label = usd_label(median_salary_usd)),
    vjust = -0.8, size = 3.2, check_overlap = TRUE
  ) +
  ggplot2::scale_x_continuous(breaks = salary_by_year$work_year) +
  ggplot2::scale_y_continuous(labels = usd_label, expand = ggplot2::expansion(mult = c(0.05, 0.18))) +
  ggplot2::labs(
    title = "Median salary by year",
    subtitle = "The 2024 median is lower than the 2023 median in this extract",
    x = "Work year", y = "Median annual salary (USD)"
  ) +
  ggplot2::theme_minimal(base_size = 12)

p_top_jobs <- ggplot2::ggplot(
  top_job_titles,
  ggplot2::aes(
    x = stats::reorder(job_title, median_salary_usd),
    y = median_salary_usd
  )
) +
  ggplot2::geom_col(fill = "#2F6B7C", width = 0.72) +
  ggplot2::coord_flip() +
  ggplot2::scale_y_continuous(labels = usd_label) +
  ggplot2::labs(
    title = "Job titles with higher observed median salaries",
    subtitle = paste0("Top 15 by median; only titles with at least ", minimum_job_count, " records"),
    x = NULL, y = "Median annual salary (USD)"
  ) +
  ggplot2::theme_minimal(base_size = 11)

save_project_plot(p_distribution, "salary_distribution.png", width = 10, height = 6)
save_project_plot(p_experience, "median_salary_by_experience.png", width = 9, height = 5.5)
save_project_plot(p_year, "median_salary_by_year.png", width = 9, height = 5.5)
save_project_plot(p_top_jobs, "top_job_titles_by_median_salary.png", width = 10, height = 7)

cat("Exploratory tables and figures written to outputs/.\n")
cat("Pearson correlation (year vs salary):", round(correlation_report$pearson_correlation, 3), "\n")
