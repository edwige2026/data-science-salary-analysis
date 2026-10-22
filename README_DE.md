# Gehaltsanalyse für Data-Science-Berufe (R)

Dieses R-Projekt untersucht Gehaltsmuster in den Bereichen Data Science, Analytics und Machine Learning. Der Ablauf orientiert sich an **CRISP-DM**: Fragestellung verstehen, Daten prüfen und vorbereiten, explorativ analysieren und ein einfaches Basismodell evaluieren.

**Leitfrage:** Welche Gehaltsmuster zeigen sich nach Berufsbezeichnung, Erfahrungsniveau und Jahr im verfügbaren Datensatz?

> Das Projekt dient Lern- und Portfoliozwecken. Es ist keine Gehaltsgarantie und ersetzt keine aktuelle, standortbezogene Gehaltsrecherche.

[English README](README.md) · [Daten und Lizenz](docs/DATA_AND_LICENSE.md) · [Data Dictionary](docs/DATA_DICTIONARY.md)

## Projektüberblick

| Kennzahl | Wert |
|---|---:|
| Datensätze vor Bereinigung | 14.838 |
| Variablen | 11 |
| Fehlende Zellen in der Quelldatei | 0 |
| Erkannte vollständig identische Duplikate | 5.711 |
| Zeilen nach Entfernung fehlender Werte und exakter Duplikate | 9.127 |
| Abgedeckte Jahre | 2020–2024 |
| Technologien | R, tidyverse, ggplot2, lineare Regression |

Für die primäre explorative Analyse werden vollständig identische Zeilen entfernt. Da identische Zeilen in der Quelldatei theoretisch unterschiedliche Stellen repräsentieren können, wird die Anzahl transparent dokumentiert und die Entscheidung sollte vor geschäftlichen Schlussfolgerungen überprüft werden.

## Erste Ergebnisse

- **Das Erfahrungsniveau hängt in diesem Datensatz mit Gehaltsunterschieden zusammen.** Der Median liegt nach Entfernen exakter Duplikate bei etwa 80.000 USD für Entry-Level-, 154.000 USD für Senior- und 190.250 USD für Executive-Level-Datensätze.
- **Die Berufsbezeichnung ist relevant.** Unter Berufen mit mindestens 30 bereinigten Datensätzen zählen *Head of Data*, *Director of Data Science* und *Applied Scientist* zu den Titeln mit hohen Medianwerten. Dies sind deskriptive Vergleiche, keine Kausalaussagen.
- **Der Zeittrend verläuft nicht einfach linear.** Der Median steigt von 2020 bis 2023 und liegt 2024 in diesem bereinigten Ausschnitt niedriger. Die Pearson-Korrelation zwischen `work_year` und `salary_in_usd` ist mit rund **0,114** schwach.
- **Die Datenqualität muss beachtet werden.** Die Quelle enthält 5.711 vollständig identische Zeilen und einen hohen Anteil von US-basierten Stellen.

## Starten

1. R 4.1 oder neuer und optional RStudio installieren.
2. In RStudio `Assignment.Rproj` öffnen.
3. Abhängigkeit installieren:

```r
install.packages("tidyverse")
```

4. Den Datensatz **Latest Data Science Job Salaries 2020–2024** von [Kaggle](https://www.kaggle.com/datasets/saurabhbadole/latest-data-science-job-salaries-2024) herunterladen und unter `data/raw/DataScience_salaries_2024.csv` ablegen.
5. Im Projektverzeichnis ausführen:

```r
source("R/run_all.R")
```

Die Skripte erzeugen bereinigte Daten, Tabellen, Grafiken und die Auswertung eines einfachen Regressionsmodells. Die Quelldatei ist aus Lizenzgründen nicht im Repository enthalten; bitte die Hinweise in `docs/DATA_AND_LICENSE.md` beachten.

## Ordnerstruktur

```text
R/                 # Datenprüfung, EDA, Modellierung, Workflow
 data/raw/         # lokale Quelldatei (nicht eingecheckt)
 data/processed/   # automatisch erzeugte bereinigte Daten
 docs/              # Datenwörterbuch, Projektbeschreibung, Lizenzhinweise
 outputs/figures/   # Grafiken
 outputs/tables/    # Ergebnistabellen
```

## Einschränkungen

Die Daten sind beobachtend, geografisch unausgewogen und stammen aus den Jahren 2020–2024. Sie enthalten nicht alle gehaltsrelevanten Merkmale. Eine einzelne zufällige Train-Test-Aufteilung reicht nicht für eine produktive Vorhersagelösung aus. Korrelation ist keine Kausalität.

