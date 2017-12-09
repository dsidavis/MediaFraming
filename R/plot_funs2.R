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
                       polls = TRUE, span = 0.1)
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
        xlim(as.Date(c(min(byWeek$interval), "2013-01-01"))) + 
        ggtitle(main)

    b = ggplotly(a, dynamicTicks = TRUE) 

    if(polls)
        b = b %>%
            add_markers(data = df_polls, inherit = FALSE, 
                        x=~Date, y=~Index, color=~House,
                        # size = df_polls$N + 1,
                        legendgroup = "Polls") %>%
            add_lines(data = df_polls, inherit = FALSE, 
                        x=~Date, y=~Index,# color=~House,
                        # size = df_polls$N + 1,
                        legendgroup = "Polls")
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
