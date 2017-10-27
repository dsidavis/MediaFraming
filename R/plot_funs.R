# Functions to aid plotting the Media Framing dataset

library(ggplot2)


byInterval = function(df, interval)
    # Interval is just a vector of the time you want to collapse by
{
    byX = aggregate(Pro ~ interval + tone + top_frame, data = df, length)
    byX = byX[order(byX$interval),]
    
    colnames(byX)[4] = "Count"
    
    byX$Count[byX$tone == "Anti"] = byX$Count[byX$tone == "Anti"] * -1
    byX
}

plot_frames = function(df, df_polls, frame_names, main)
{

    byWeek = byInterval(df, df$Week_start)

    pro = byWeek$tone == "Pro"
    con = byWeek$tone == "Anti"
    
    a = ggplot(byWeek[pro,],
               aes(x = interval, y = Count, color = top_frame)) +
        geom_line() +
        geom_line(data = byWeek[con,])+ 
        theme_bw() +
        geom_point(data = df_polls, aes(x = Date, y = Index, color = House, size = N),
                   alpha = 0.5) +
        geom_smooth(data = df_polls, aes(x = Date, y = Index), method = "loess",
                    span = 0.1, color = "gray", se = FALSE) +
        xlab("Date (week start)") +
        xlim(as.Date(c("1980-01-01", "2013-01-01"))) + 
        scale_y_continuous(sec.axis = sec_axis(~., name = "Public polling"))+
        ggtitle(main) +
        geom_hline(yintercept = 50, linetype = "dashed")
    
    b = ggplotly(a) %>% layout(xaxis = list(rangeslider = list(type = "date"))) 

    b
}

plot_sources = function(df, main)
{
    # bySource =  aggregate(Pro ~ paste(Month, Year) + Source, data = df, mean)
    # bySource$start_date = as.Date(paste("1", bySource$'paste(Month, Year)'),
                                  # format = "%d %m %Y")
    bySource =  aggregate(Pro ~ Week_start + Source, data = df, mean)
    
    bias = tapply(bySource$Pro, bySource$Source, median)
    bySource$Source = factor(bySource$Source, levels = names(bias)[order(bias)])
    
    c = ggplot(bySource, aes(x = Week_start, y = Pro, color = Source)) +
        geom_point(size = 0.5, alpha = 0.35) +
        geom_smooth(se = FALSE, span = 0.5) +
        theme_bw() +
        geom_hline(yintercept = 0.5, color = "black", linetype = "dashed") + 
        facet_wrap(~Source) +
        ggtitle(paste0("Median position over time: ", main))
    
    ggplotly(c)

}
