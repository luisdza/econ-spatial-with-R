# econ-spatial-with-r

This project processes economic spatial data using R. The data is downloaded, extracted, and converted from CSV to RDS format for further analysis.

## Prerequisites

- R (version 4.0 or higher)
- R packages: `fs`, `archive`, `readr`, `progress`

You can install the required R packages using the following command:
```r
install.packages(c("fs", "archive", "readr", "progress"))

## Setup
1. Download the data files from spatialtaxdata.org.za and place them in the raw-data/datasets directory.
2. Ensure the directory structure is as follows:
processed-data/
    ...
raw-data/
    datasets/
    shape-files/
    supplementary/

## Running the Script
To process the data, run the app.R script. This script will:
1. Create the processed-data directory if it doesn''t exist.
2. List all .7z files in the raw-data/datasets directory.
3. Extract each .7z file to a directory.
4. Convert each CSV file in the extracted directories to RDS format.
5. Delete the original CSV files after processing.

You can run the script using the following command in your R console or RStudio:

```
source("app.R")
```

## Output
The processed RDS files will be saved in the processed-data directory.

## License
This project is licensed under the MIT License.