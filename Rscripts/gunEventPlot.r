library(ggplot2)
library(plotly)
library(readxl)

source("setup.R")
source("gunEvents.r")
source("../R/plot_funs.R")

gg = plot_frames(frames[["guncontrol"]], polls[["guncontrol"]], frame_names,
                    main = "Gun Control",
                events = as.Date(gunEvents$date),
                eventLab = paste("</br> Location: ", gunEvents$location,
                                 "</br> Date: ", as.character(gunEvents$date),
                                 "</br> Num. Killed: ", gunEvents$numKilled,
                                 "</br> Num. Injured: ", gunEvents$numInjured))
gg    
htmlwidgets::saveWidget(gg, file = "guncontrol-w-events.html")
