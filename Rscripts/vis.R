library(ggplot2)
library(plotly)
library(readxl)

source("setup.R")



im = frames$immigration
im_polls = polls$immigration

framePlots = lapply(names(frames), function(name) plot_frames(frames[[name]], polls[[name]], frame_names, main = name))


htmlwidgets::saveWidget(b, file = "immigration.html")

# Sources
# by week is too many points

# Remove the Chapel Hill - Only one post
chapel = im$Source == "chapel hill herald"
bySource =  aggregate(Pro ~ paste(Month, Year) + Source, data = im[!chapel,], mean)
bySource$start_date = as.Date(paste("1", bySource$'paste(Month, Year)'),
                              format = "%d %m %Y")

bias = tapply(bySource$Pro, bySource$Source, median)
bySource$Source = factor(bySource$Source, levels = names(bias)[order(bias)])

c = ggplot(bySource, aes(x = start_date, y = Pro, color = Source)) +
    geom_point(size = 0.5) +
    geom_smooth(se = FALSE) +
    theme_bw() +
    geom_hline(yintercept = 0.5, color = "black", linetype = "dashed") + 
    facet_wrap(~Source) +
    ggtitle("Median position over time")

ggplotly(c) %>%  layout(xaxis = list(rangeslider = list(type = "date"))) 












