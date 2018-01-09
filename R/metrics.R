#
# How dominant is the most dominant frame
#
# Identify intervals of interest.
#
# surge - x articles over a period.

#
# Run Rscripts/setup.R to get data frames with dates expanded and also pro/con in the tone variable, and the top frame in top_frame.
# If we are interested in Pro, use
#  gc = frames[[1]]
#  pro.gc = gc[gc$tone == "Pro", ]
#
# Each row is an article, and we have its frame and date.
# So for a surge
# r = range(pro.gc$date)
# wks = seq(r[1], r[2], by = "week")
#

surgeInfo =
function(ts, r = range(ts$date), bw = 2, timeUnit = "weeks")
{
    d = cut(ts$date, "weeks")
    counts = table(d)
    ans = sapply(seq(along = counts), function(i)  sum(counts[ min(i +bw, length(counts)) ]))
    data.frame(counts = ans, dates = as.Date(names(counts)))
}
