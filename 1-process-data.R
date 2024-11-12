library(fs)
library(archive)
library(readr)
library(progress)

# Define directories
raw_data_dir <- "raw-data/datasets"
shape_files_dir <- "raw-data/shape-files"
processed_data_dir <- "processed-data"

# Create processed data directory if it doesn't exist
dir_create(processed_data_dir)

# Function to process .7z files
process_7z_files <- function(input_dir, processed_data_dir) {
    # List all .7z files in the input directory
    archive_files <- dir_ls(input_dir, glob = "*.7z")
    
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
            rds_file <- path(processed_data_dir, path_file(path_ext_set(csv_file, "rds")))
            
            # Check if the RDS file already exists
            if (!file_exists(rds_file)) {
                data <- read_csv(csv_file)
                
                # Check for parsing problems
                parsing_problems <- problems(data)
                if (nrow(parsing_problems) > 0) {
                    warning(sprintf("Parsing issues in file %s:\n%s", csv_file, capture.output(print(parsing_problems))))
                }
                
                saveRDS(data, rds_file)
            }
            
            # Delete the CSV file after processing or if it already exists
            file_delete(csv_file)
        }
        
        # Update progress bar
        pb$tick()
    }
}

# Process .7z files in raw-data/datasets
process_7z_files(raw_data_dir, processed_data_dir)

# Process .7z files in raw-data/shape-files
process_7z_files(shape_files_dir, processed_data_dir)