# Functions to aid plotting the Media Framing dataset

library(ggplot2)


getSurges = function(df, threshold)
{
    by(df, list(df$top_frame, df$tone), function(x, threshold){
        x = x[order(x$interval),]
        d = abs(x$Count) >= threshold
        # browser()
        x[d,]
        }, threshold = threshold)
}


byInterval = function(df, interval)
    # Interval is just a vector of the time you want to collapse by
{
    byX = aggregate(Pro ~ interval + tone + top_frame, data = df, length)
    byX = byX[order(byX$interval),]
    
    colnames(byX)[4] = "Count"
    
    byX$Count[byX$tone == "Anti"] = byX$Count[byX$tone == "Anti"] * -1
    byX
}

plot_frames = function(df, df_polls, frame_names, main, interval = df$Week_start,
                       polls = TRUE, span = 0.1, events = NULL,
                       eventLab = NULL)
{

    byWeek = byInterval(df, interval)

    pro = byWeek$tone == "Pro"
    con = byWeek$tone == "Anti"
    
    a = ggplot(byWeek[pro,],
               aes(x = interval, y = Count, color = top_frame)) +
        geom_line() +
        geom_line(data = byWeek[con,])+ 
        theme_bw() +
        xlab("Date (week start)") +
        xlim(as.Date(c(min(byWeek$interval), "2017-01-01"))) + 
        scale_y_continuous(sec.axis = sec_axis(~., name = "Public polling"))+
        ggtitle(main) +
        theme_bw()

    a = ggplotly(a, dynamicTicks = TRUE)
    
    if(!is.null(events)){
        a = a %>% add_segments(x = ~events, y = max(byWeek$Count),
                               xend = ~events, yend = min(byWeek$Count),
                               inherit = FALSE, name = "Events",
                               hoverinfo = "text", text = ~eventLab,
                               line = list(dash = "dot", width = 1,
                                           color = "rgba(67,67,67,1)"))
    }
        if(polls){
        b = ggplot(df_polls, aes(x = Date, y = Index, color = House, size = N)) +
            geom_point() +
            geom_smooth(color = "gray", se = FALSE, span = 0.5) +
            geom_hline(yintercept=50, show.legend = FALSE,
                       linetype = "dashed", color = "black") +
            theme_bw() +
            guides(color = guide_legend(title="Polls"),
                   size = FALSE)
        # browser()
        b = ggplotly(b, dynamicTicks = TRUE)
        subplot(a, b, nrows = 2, shareX = TRUE, heights = c(0.8, 0.2))
    } else {
        ggplotly(a, dynamicTicks = TRUE)
    }
    #     geom_point(data = df_polls, aes(x = Date, y = Index, color = House, size = N),
    #                    alpha = 0.5) +
    #         geom_smooth(data = df_polls, aes(x = Date, y = Index), method = "loess",
    #                     span = span, color = "gray", se = FALSE) +
    #         geom_hline(yintercept = 50, linetype = "dashed")

    # b = ggplotly(a, dynamicTicks = TRUE) 
    # #%>% layout(xaxis = list(rangeslider = list(type = "date"))) 

    # b
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
