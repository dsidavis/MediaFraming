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

# Monthly
framePlots.m = lapply(names(frames), function(name)
    plot_frames(frames[[name]], polls[[name]], frame_names, main = name,
                interval = as.Date(format(frames[[name]]$date, "%Y-%m-01")),
                polls = TRUE))

names(framePlots.m) = names(frames)
framePlots.m

lapply(names(framePlots), function(name)
    htmlwidgets::saveWidget(framePlots.m[[name]], file = paste0(name, "-monthly.html")))

# Yearly
framePlots.y = lapply(names(frames), function(name)
    plot_frames(frames[[name]], polls[[name]], frame_names, main = name,
                interval = as.Date(format(frames[[name]]$date, "%Y-01-01")),
                polls = TRUE))

names(framePlots.y) = names(frames)
framePlots.y
lapply(names(framePlots), function(name)
    htmlwidgets::saveWidget(framePlots.y[[name]], file = paste0(name, "-yearly.html")))


# Sources
# by week is too many points

# Remove the Chapel Hill - Only one post
# chapel = im$Source == "chapel hill herald

sourcePlots = lapply(names(frames), function(name)
    plot_sources(frames[[name]], name))

names(sourcePlots) = names(frames)
sourcePlots

lapply(names(sourcePlots), function(name)
    htmlwidgets::saveWidget(sourcePlots[[name]], file = paste0(name, "-source.html")))

# Playing with plotly directly
p = plot_ly(data = frames[[1]], x = ~Week_start, y = ~Pro, color = ~top_frame) %>%
    add_trace()
p

# Look at the intervals where frames are surging across topics

byWeeks = lapply(seq_along(frames), function(i) {
    ans = byInterval(frames[[i]], frames[[i]]$Week_start)
    ans$topic = names(frames)[i]
    ans
})

ff = lapply(byWeeks, getSurges, threshold = 5)
ff = do.call(rbind, lapply(ff, function(x) do.call(rbind, x)))
ff = ff[order(ff$interval),]
c = ggplot(ff, aes(x = interval, y = Count, color = top_frame, shape = topic))+
    geom_point(alpha = 0.5) +
    theme_bw() +
    xlab("Date")

ggplotly(c) %>% layout(xaxis = list(rangeslider = list(type = "date"))) 
