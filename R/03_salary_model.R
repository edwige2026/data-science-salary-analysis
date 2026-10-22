# Step 3: fit a transparent baseline model and evaluate it on a hold-out sample.
# This is a baseline, not a deployment-ready salary estimator.
source("R/00_setup.R")

salary_raw <- load_raw_salary_data()
salary <- clean_salary_data(salary_raw)

model_data <- salary |>
  dplyr::mutate(
    log_salary = log(salary_in_usd),
    experience_level = factor(experience_level, levels = c("EN", "MI", "SE", "EX")),
    employment_type_group = forcats::fct_lump_min(
      factor(employment_type), min = 30, other_level = "Other"
    ),
    job_title_group = forcats::fct_lump_min(
      factor(job_title), min = 50, other_level = "Other"
    ),
    remote_ratio = factor(remote_ratio),
    company_size = factor(company_size)
  ) |>
  dplyr::select(
    salary_in_usd, log_salary, work_year, experience_level,
    employment_type_group, job_title_group, remote_ratio, company_size
  )

set.seed(87)
train_idx <- sample.int(
  n = nrow(model_data),
  size = floor(0.80 * nrow(model_data))
)
train <- model_data[train_idx, , drop = FALSE]
test <- model_data[-train_idx, , drop = FALSE]

salary_model <- stats::lm(
  log_salary ~ work_year + experience_level + employment_type_group +
    job_title_group + remote_ratio + company_size,
  data = train
)

predicted_log_salary <- stats::predict(salary_model, newdata = test)
predicted_salary <- exp(predicted_log_salary)
actual_salary <- test$salary_in_usd

# Median-only benchmark, calculated from the training set (no test-set information used).
baseline_salary <- rep(stats::median(train$salary_in_usd), length(actual_salary))

evaluate_predictions <- function(model_name, actual, predicted) {
  valid <- is.finite(actual) & is.finite(predicted)
  actual <- actual[valid]
  predicted <- predicted[valid]
  data.frame(
    model = model_name,
    evaluation_rows = length(actual),
    RMSE_USD = sqrt(mean((actual - predicted)^2)),
    MAE_USD = mean(abs(actual - predicted)),
    R_squared = 1 - sum((actual - predicted)^2) / sum((actual - mean(actual))^2),
    stringsAsFactors = FALSE
  )
}

metrics <- dplyr::bind_rows(
  evaluate_predictions("Training-median baseline", actual_salary, baseline_salary),
  evaluate_predictions("Log-linear regression", actual_salary, predicted_salary)
)

readr::write_csv(metrics, "outputs/tables/model_evaluation.csv")
readr::write_csv(
  data.frame(term = names(stats::coef(salary_model)), coefficient_log_scale = unname(stats::coef(salary_model))),
  "outputs/tables/model_coefficients.csv"
)

prediction_results <- data.frame(
  actual_salary_usd = actual_salary,
  predicted_salary_usd = predicted_salary
)

p_predictions <- ggplot2::ggplot(
  prediction_results,
  ggplot2::aes(x = actual_salary_usd, y = predicted_salary_usd)
) +
  ggplot2::geom_point(alpha = 0.35, color = "#2F6B7C") +
  ggplot2::geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "#D97757") +
  ggplot2::scale_x_continuous(labels = scales::label_dollar(prefix = "$", big.mark = ",")) +
  ggplot2::scale_y_continuous(labels = scales::label_dollar(prefix = "$", big.mark = ",")) +
  ggplot2::labs(
    title = "Baseline regression: actual vs predicted salary",
    subtitle = "Random 80/20 hold-out split; predictions are back-transformed from log salary",
    x = "Actual salary (USD)", y = "Predicted salary (USD)",
    caption = "Dashed line indicates perfect predictions. A single split is not sufficient for production validation."
  ) +
  ggplot2::theme_minimal(base_size = 12)

save_project_plot(p_predictions, "actual_vs_predicted_salary.png", width = 8.5, height = 6.5)

cat("Model evaluation written to outputs/tables/model_evaluation.csv\n")
print(metrics)
