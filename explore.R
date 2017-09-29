library(RJSONIO)
im = fromJSON("immigration.json")
co = fromJSON("codes.json")

# table(unlist(sapply(im, names)))
varNames = c("annotations", "byline", "csi", "day", "irrelevant", "month", 
              "page", "section", "source", "text", "title", "year")
sort(table(sapply(im, `[[`, "source")))
plot(table(sapply(im, `[[`, "day")))
plot(table(sapply(im, `[[`, "year")))
table(sapply(im, `[[`, "section"))
