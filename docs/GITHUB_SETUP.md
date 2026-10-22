# GitHub repository setup

## Suggested repository metadata

- **Repository name:** `data-science-salary-analysis`
- **Description:** `Exploratory analysis of Data Science salary patterns using R, tidyverse, ggplot2, and a baseline regression model.`
- **Visibility:** Public, after reviewing the files and the source-data license.
- **Topics:** `r`, `data-science`, `exploratory-data-analysis`, `ggplot2`, `salary-analysis`, `statistics`, `machine-learning`, `portfolio-project`

## First publication

1. Create an empty repository on GitHub with the name above. Do not add a second README or license on GitHub because this project already contains them.
2. Extract the project ZIP and open the extracted `data-science-salary-analysis` folder.
3. Open `Assignment.Rproj` in RStudio and download the source CSV as described in `data/raw/README.md`. Do not commit the CSV unless the dataset license explicitly permits redistribution.
4. From a terminal in the project root, run:

```bash
git init
git add .
git commit -m "Add reproducible R salary analysis project"
git branch -M main
git remote add origin https://github.com/<YOUR-USERNAME>/data-science-salary-analysis.git
git push -u origin main
```

Replace `<YOUR-USERNAME>` with your GitHub username. If the repository already exists locally, do not run `git init` a second time.

## Final review before publishing

- Run `source("R/run_all.R")` and confirm that the result tables and figures are regenerated.
- Make sure `data/raw/DataScience_salaries_2024.csv` is not staged. It is excluded by `.gitignore`.
- Do not add the original academic PDF to the public repository without first removing its address, student number, and student email.
- Confirm the current dataset license and cite the source.
- Check that the rendered README preview on GitHub displays the charts correctly.
