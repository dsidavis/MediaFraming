# Simple script to do some operations needed before analyzing the data

library(readxl)


week_start = function(x){
    as.Date(format(x, "%Y-%W-1"), format = "%Y-%W-%u")
}

# Symlink to github data
data_dir = "../MediaFramingData/public_opinion_analysis/data"

frame_names = as.data.frame(read_excel(paste0(data_dir, "/frames.xlsx"), col_names = FALSE))

frameFiles = list.files(data_dir, pattern = "csv$", full.names = TRUE)

polls = lapply(frameFiles[grep("_polls\\.csv$", frameFiles)], read.csv, stringsAsFactors = FALSE)

frames = lapply(frameFiles[grep("_with_metadata", frameFiles)], read.csv, stringsAsFactors = FALSE)

names(frames) = gsub("_with_metadata.*$", "",
                     basename(frameFiles[grep("with_metadata", frameFiles)]))


names(polls) = gsub("_polls.csv$", "",
                    basename(frameFiles[grep("_polls\\.csv$", frameFiles)]))

# Quick checks
sapply(polls, ncol) # All different

sapply(frames, ncol) # All different


# All frames have FullDate - it is just pasted %Y%m%d
# Convert date
frames = lapply(frames, function(x, frame_names) {
    x$date = as.Date(as.character(x$FullDate), format = "%Y%m%d")
    x$Week_start = week_start(x$date)
    # Get top frame
    ps = grep("^p[0-9]{1,2}$", colnames(x))

    x$top_frame =  factor(apply(x[,ps], 1, which.max),
                          levels = 0:14, labels = frame_names)
    x$tone = factor(apply(x[,c("Pro","Neutral","Anti")], 1, which.max),
                    labels = c("Pro","Neutral","Anti"))

    x
},
frame_names = frame_names$X__3)


polls = lapply(polls, function(x) {
    x$Date = as.Date(x$Date, format = "%m/%d/%y")
    if(is.null(x$House))
        x$House = ""
    x
})

# Fix the Source names in gun control
x = frames[["guncontrol"]]$Source
frames[["guncontrol"]]$Source.orig = x
frames[["guncontrol"]]$Source = gsub(" blogs.*$| \\(.*\\)$", "", x)
