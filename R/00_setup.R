# Shared helpers for all analysis scripts.
# Run scripts from the repository root (opening Assignment.Rproj in RStudio does this).

required_packages <- c("readr", "dplyr", "tidyr", "ggplot2", "forcats", "scales")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Missing packages: ", paste(missing_packages, collapse = ", "),
    ". Install them with install.packages('tidyverse') and rerun."
  )
}

ensure_output_dirs <- function() {
  dirs <- c(
    "data/processed",
    "outputs/figures",
    "outputs/tables"
  )
  for (dir in dirs) {
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  }
}

load_raw_salary_data <- function() {
  data_path <- file.path("data", "raw", "DataScience_salaries_2024.csv")
  if (!file.exists(data_path)) {
    stop(
      "Dataset not found at '", data_path, "'. Download it from Kaggle and place it there.\n",
      "See data/raw/README.md for instructions."
    )
  }
  readr::read_csv(data_path, show_col_types = FALSE, progress = FALSE)
}

clean_salary_data <- function(data) {
  # Drop missing rows and then remove fully identical records. The duplicate count is
  # reported separately before cleaning; review this assumption for any real-world use.
  data |>
    tidyr::drop_na() |>
    dplyr::distinct()
}

save_project_plot <- function(plot, filename, width = 10, height = 6) {
  ensure_output_dirs()
  ggplot2::ggsave(
    filename = file.path("outputs", "figures", filename),
    plot = plot,
    width = width,
    height = height,
    dpi = 160,
    bg = "white"
  )
}

ensure_output_dirs()
