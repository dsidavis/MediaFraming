library(ggplot2)
library(plotly)
library(readxl)

source("setup.R")


im = frames$immigration
im_polls = polls$immigration

ps = grep("^p[0-9]{1,2}$", colnames(im))

im$top_frame =  factor(apply(im[,ps], 1, which.max),
                       levels = 0:14, labels = frame_names$X__3)

im$tone = cut(im$Pro, 3, labels = c("Con", "Neutral","Pro"))
byWeek = aggregate(Pro ~ Week_start + tone + top_frame, data = im, length)
byWeek = byWeek[order(byWeek$Week_start),]

colnames(byWeek)[4] = "Count"

byWeek$Count[byWeek$tone == "Con"] = byWeek$Count[byWeek$tone == "Con"] * -1

pro = byWeek$tone == "Pro"
con = byWeek$tone == "Con"

a = ggplot(byWeek[pro,],
           aes(x = Week_start, y = Count, color = top_frame)) +
    geom_line() +
    geom_line(data = byWeek[con,])+ 
    theme_bw() +
    geom_line(data = im_polls, aes(x = Date, y = Index), color = "black") +
    geom_smooth(data = im_polls, aes(x = Date, y = Index), color = "gray", se = FALSE) +
    xlab("Date (week start)") +
    xlim(as.Date(c("1980-01-01", "2013-01-01"))) + 
    scale_y_continuous(sec.axis = sec_axis(~., name = "Public polling"))
a

a2 = ggplot(data = im_polls, aes(x = Date, y = Index)) +
    geom_point() +
    geom_smooth(se = FALSE)
   
subplot(ggplotly(a), ggplotly(a2), nrow = 2, shareX = TRUE)

b = ggplotly(a)


b %>% layout(xaxis = list(rangeslider = list(type = "date"))) 

# Sources
# by week is too many points
bySource =  aggregate(Pro ~ paste(Month, Year) + Source, data = im, median)
bySource$start_date = as.Date(paste("1", bySource$'paste(Month, Year)'),
                              format = "%d %m %Y")

c = ggplot(bySource, aes(x = start_date, y = Pro, color = Source)) +
    geom_point(size = 0.5) +
    geom_smooth(se = FALSE) +
    theme_bw() +
    geom_hline(yintercept = 0.5, color = "black", linetype = "dashed") + 
    facet_wrap(~Source)

ggplotly(c) %>%  layout(xaxis = list(rangeslider = list(type = "date"))) 












