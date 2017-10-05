# Functions for EDA

findPeaks = function(date_vect, thrsh = 3, ...){
    # Uses a smooth kernel, then looks at cases that are X
    # outside of range
    # browser()
    tmp = table(date_vect)
    mm = smooth.spline(time(as.Date(names(tmp))), tmp, ...)
    plot(tmp, type = "p")
    lines(mm, col = "red")
    peaks = resid(mm) > (thrsh * sd(resid(mm)))
    points(as.integer(tmp), pch = 16, col = peaks + 1)
    return(names(tmp)[peaks])
}

# There has got to be a better way to do this
# But my brain is not working today
getTopFrames = function(df, index, N = 3,
                            pCols = grep("^p[0-9]{1,2}", colnames(df))){
    lapply(seq(nrow(df)),function(i, df, N){
        j = order(df[i,], decreasing = TRUE)[1:N]
        structure(df[i,j], names = j)

    }, df = df[,pCols], N = N)
}


extractFrameNum = function(topFrame, rank){
    sapply(topFrame, "[", rank)
}

frameByTime = function(topFrame, time, rank){
    frame = extractFrameNum(topFrame, rank)
    aggregate(names(frame), list(time), table)
}

plotTopFrames = function(frame){
    matplot(x = frame[,1], frame[,-1], type = "l")
    legend("topleft", legend = colnames(frame$x)[-1],
           col = seq(ncol(frame$x)))
}

byTimeLong = function(var, time)
{
    
}
