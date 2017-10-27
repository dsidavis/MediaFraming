library(ggplot2)
library(plotly)
library(readxl)

source("setup.R")
source("../R/plot_funs.R")

framePlots = lapply(names(frames), function(name)
    plot_frames(frames[[name]], polls[[name]], frame_names, main = name))
names(framePlots) = names(frames)
framePlots

lapply(names(framePlots), function(name)
    htmlwidgets::saveWidget(framePlots[[name]], file = paste0(name, ".html")))

# Sources
# by week is too many points

# Remove the Chapel Hill - Only one post
# chapel = im$Source == "chapel hill herald

sourcePlots = lapply(names(frames), function(name)
    plot_sources(frames[[name]], name))

names(sourcePlots) = names(frames)

lapply(names(sourcePlots), function(name)
    htmlwidgets::saveWidget(sourcePlots[[name]], file = paste0(name, "-source.html")))

# Playing with plotly directly
p = plot_ly(data = frames[[1]], x = ~Week_start, y = ~Pro, color = ~top_frame) %>%
    add_trace()
p
