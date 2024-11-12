# write code to import the shape files in the raw-data\shape-files folder
# and save them as R objects in the processed-data folder

library(fs)
library(archive)
library(readr)
library(progress)
library(sf)

# Define directories
district_municipal_dir <- "raw-data/shape-files/District_Municipal_Shapefiles"
hexagonal_dir <- "raw-data/shape-files/Hexagonal_Shapefiles"
local_municipal_dir <- "raw-data/shape-files/Local_Municipal_Shapefiles"
province_dir <- "raw-data/shape-files/Province_Shapefiles"
processed_shapes_dir <- "processed-shapes"

# Create processed data directory if it doesn't exist
dir_create(processed_shapes_dir)

# Function to import shape files
import_shape_files <- function(input_dir, processed_shapes_dir) {
    # List all shape files in the input directory
    shape_files <- dir_ls(input_dir, glob = "*.shp")
    
    # Initialize progress bar
    total_files <- length(shape_files)
    pb <- progress_bar$new(
        format = "  Importing [:bar] :percent in :elapsed",
        total = total_files, clear = FALSE, width = 60
    )
    
    # Import each shape file
    for (shape_file in shape_files) {
        # Read the shape file
        shape_data <- st_read(shape_file)
        
        # Save the shape data as an RDS file
        rds_file <- path(processed_shapes_dir, path_file(path_ext_set(shape_file, "rds")))
        saveRDS(shape_data, rds_file)
        
        # Update progress bar
        pb$tick()
    }
}

# Import shape files in raw-data/shape-files
import_shape_files(district_municipal_dir, processed_shapes_dir)
import_shape_files(local_municipal_dir, processed_shapes_dir)
import_shape_files(province_dir, processed_shapes_dir)
import_shape_files(hexagonal_dir, processed_shapes_dir)