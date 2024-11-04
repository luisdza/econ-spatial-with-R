library(fs)
library(archive)
library(readr)
library(progress)

# Define directories
raw_data_dir <- "raw-data/datasets"
processed_data_dir <- "processed-data"

# Create processed data directory if it doesn't exist
dir_create(processed_data_dir)

# List all .7z files in the raw-data/datasets directory
archive_files <- dir_ls(raw_data_dir, glob = "*.7z")

# Initialize progress bar
total_files <- length(archive_files)
pb <- progress_bar$new(
    format = "  Processing [:bar] :percent in :elapsed",
    total = total_files, clear = FALSE, width = 60
)

# Process each .7z file
for (archive_file in archive_files) {
    # Create a directory for the extracted files
    extract_dir <- path_ext_remove(archive_file)
    dir_create(extract_dir)
    
    # Extract the .7z file
    archive_extract(archive_file, dir = extract_dir)
    
    # List all CSV files in the extracted directory
    csv_files <- dir_ls(extract_dir, glob = "*.csv")
    
    # Read each CSV file and save it as an RDS file
    for (csv_file in csv_files) {
        data <- read_csv(csv_file)
        rds_file <- path(processed_data_dir, path_file(path_ext_set(csv_file, "rds")))
        saveRDS(data, rds_file)
        
        # Delete the CSV file after processing
        file_delete(csv_file)
    }
    
    # Update progress bar
    pb$tick()
}