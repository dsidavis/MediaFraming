# Functions to aid plotting the Media Framing dataset

library(ggplot2)

plot_frames = function(df, df_polls, frame_names, main)
{
    ps = grep("^p[0-9]{1,2}$", colnames(df))

    df$top_frame =  factor(apply(df[,ps], 1, which.max),
                       levels = 0:14, labels = frame_names$X__3)

    df$tone = cut(df$Pro, 3, labels = c("Con", "Neutral","Pro"))
    byWeek = aggregate(Pro ~ Week_start + tone + top_frame, data = df, length)
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
        geom_line(data = df_polls, aes(x = Date, y = Index), color = "black") +
        geom_smooth(data = df_polls, aes(x = Date, y = Index), color = "gray", se = FALSE) +
        xlab("Date (week start)") +
        xlim(as.Date(c("1980-01-01", "2013-01-01"))) + 
        scale_y_continuous(sec.axis = sec_axis(~., name = "Public polling"))+
        ggtitle(main) +
        geom_hline(yintercept = 50, linetype = "dashed")

    b = ggplotly(a) %>% layout(xaxis = list(rangeslider = list(type = "date"))) 

    b
}
