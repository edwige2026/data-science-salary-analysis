# Data dictionary

The Kaggle CSV is expected to contain 11 fields. The descriptions below summarize the schema used by this project.

| Column | Meaning | Role in this project |
|---|---|---|
| `work_year` | Year associated with the reported salary | Descriptive variable and model feature |
| `experience_level` | Experience category (`EN`, `MI`, `SE`, `EX`) | Descriptive variable and model feature |
| `employment_type` | Employment type (`FT`, `PT`, `CT`, `FL`) | Model feature; rare categories are grouped |
| `job_title` | Job title | Descriptive variable and model feature; rare titles are grouped for modeling |
| `salary` | Original reported salary amount in local currency | Excluded from model to avoid currency-scale issues |
| `salary_currency` | Currency of the original salary | Not used as a model feature |
| `salary_in_usd` | Salary converted to USD in the source dataset | Main outcome variable |
| `employee_residence` | Employee residence country code | Not used in the baseline regression |
| `remote_ratio` | Remote-work ratio reported by the source (0, 50, or 100) | Descriptive variable and model feature |
| `company_location` | Company location country code | Not used in the baseline regression |
| `company_size` | Company size category (`S`, `M`, `L`) | Descriptive variable and model feature |

## Important notes

- The project treats `salary_in_usd` as the comparable salary measure; it does not attempt to recreate the source's currency conversion.
- The `remote_ratio` values are discrete categories in this file, so the analysis treats them as factors in the regression.
- Country codes are not fully expanded into country names in the current version.
- Check the original Kaggle dataset page for source notes and licensing terms before reusing or redistributing the data.
