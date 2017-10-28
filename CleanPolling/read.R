#gc = read.csv("guncontrol.csv", stringsAsFactors = FALSE)
gc = read_excel("Mood2014_by_issue.xlsx", "guncontrol")  #, stringsAsFactors = FALSE)

gc$Date = as.Date(gc$Date)      # , "%m/%d/%Y")
# Check the dates are reasonable.
# What should the range be.
range(gc$Date)

# Look at the gaps between the sorted dates
summary(as.numeric(diff(sort(gc$Date))))
plot(density(as.numeric(diff(sort(gc$Date)))))
rug(as.numeric(diff(sort(gc$Date))))

# Or just plot the dates
plot(gc$Date, rep(1, nrow(gc)))

# How many in each year.
table(as.POSIXlt(gc$Date)$year + 1900)
dotchart(table(as.POSIXlt(gc$Date)$year + 1900))


# Look at the sample size.
# Any NAs
any(is.na(gc$N))

range(gc$N)
# 0 is the NA
table(gc$N == 0)



# Duplicate surveys.  By date and house
gc$excelRow = 1:nrow(gc) + 1L
dup = split( gc, list(gc$Date, gc$House) )
table(sapply(dup, nrow) > 1)
# 49 have more than on

ddup = dup[ sapply(dup, nrow) > 1 ]
sapply(ddup, nrow)
table(sapply(ddup, nrow))
# 41 have 2, 8 have 3

ddup[sapply(ddup, nrow) == 3 ]
# Check the Varname and the L1, .., L4, C2, .. C5 are all the same.
# And what about the Added column.


# Look at all columns in each element of ddup and look for how many
# unique values. Where there is only one, the rows are the same
# and if all columns are the same for all rows, then an exact duplicate
# The ID column will be different across rows.
z = lapply(ddup, function(x) sapply(x, function(x) length(unique(x))))


# Missing C1 and L5
lcVars = c( paste0("L", 1:4), paste0("C", 2:5), "Other")
isNumeric = sapply(gc[, lcVars], is.numeric)
stopifnot(all(isNumeric))

# For the CSV, we get ,'s in some of the cells. But that is just formatting that is no in the xlsx.
if(FALSE) {
tmp = lapply(gc[, lcVars[!isNumeric], drop = FALSE],
            function(x)
               as.numeric(gsub(",", "", x)))
gc[, lcVars[!isNumeric]] = tmp
}

# Number of NAs in each column.
sapply(gc[, lcVars], function(x) sum(is.na(x)))

# Number of NAs in each row.
rs = apply(gc[, lcVars], 1, function(x) sum(is.na(x)))
sum(rs > 0)
which(rs > 0)
 # Should these be 0s.  Check to sum of the totals without the NAs.
 
rs = apply(gc[, lcVars], 1, sum, na.rm = TRUE)



# Should all of these be 100% or between 0 and 100%
#  < 100 may be okay (check with Amber) if allow for non-respondents.
#
table(rs == 100)

table(rs > 100)


# Check the values > 100, as these are probably counts and not percents.
# Do these rows add up to N.
#

w = apply(gc[rs > 100, lcVars], 1, sum) == gc[rs > 100, "N"]
table(w)
# Only the NA's don't.

apply(gc[rs > 100, c("N", lcVars)], 1, function(x) sum(x[-1]/x[1]) )



