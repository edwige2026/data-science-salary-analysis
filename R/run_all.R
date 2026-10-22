# Run all steps from the project root in RStudio.
cat("[1/3] Data quality checks...\n")
source("R/01_data_quality.R")
cat("[2/3] Exploratory analysis...\n")
source("R/02_exploratory_analysis.R")
cat("[3/3] Baseline salary model...\n")
source("R/03_salary_model.R")
cat("Done. See outputs/figures and outputs/tables.\n")
