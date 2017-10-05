# Simple script to do some operations needed before analyzing the data

# Symlink to github data
data_dir = "../MediaFramingData/public_opinion_analysis/data"
frameFiles = list.files(data_dir, pattern = "csv$", full.names = TRUE)

polls = lapply(frameFiles[grep("_polls\\.csv$", frameFiles)], read.csv, stringsAsFactors = FALSE)
frames = lapply(frameFiles[grep("_with_metadata", frameFiles)], read.csv, stringsAsFactors = FALSE)
names(frames) = frameFiles[grep("_with_metadata", frameFiles)]
# Quick checks
sapply(polls, ncol) # All different

sapply(frames, ncol) # All different

sapply(frames, head)

# All frames have FullDate - it is just pasted %Y%m%d
# Convert date
frames = lapply(frames, function(x){
    x$FullDate = as.Date(as.character(x$FullDate), format = "%Y%m%d")
    # Add a week column
    x$Week = as.integer(format(x$FullDate, "%U"))
    x
    })

