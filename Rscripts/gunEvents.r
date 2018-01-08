library(RCurl)
library(XML)

u = "http://timelines.latimes.com/deadliest-shooting-rampages/"
doc = htmlParse(u)
#div = getNodeSet(doc, "//div[contains(@class, 'tlog-item-datetime')]")
div = getNodeSet(doc, "//div[@class = 'tlog-item']")


series = sapply(div, xmlGetAttr, "series", NA)
tmp = sapply(div, function(x) xmlValue(x[["div"]], trim = TRUE))
tmp = gsub("Sept\\.", "Sep.", tmp)
date = as.POSIXct(strptime(tmp, "%b. %d, %Y"))
w = is.na(date)
date[w] = as.POSIXct(strptime(tmp[w], "%B %d, %Y"))



info = sapply(div, function(x) xpathSApply(x, "./div[contains(@class, 'tlog-item-body')]//h2", xmlValue, trim = TRUE))

els = strsplit(info, ":")
where = XML:::trim(sapply(els, `[`, 2))

killed = as.integer(gsub("^[[:space:]]*([0-9]+) killed.*", "\\1", sapply(els, `[`, 1)))


injured = as.integer(gsub(".*, ([0-9]+) injured.*", "\\1", sapply(els, `[`, 1)))


gunEvents = data.frame(date = date,
                       location = where,
                       numKilled = killed, numInjured = injured)

