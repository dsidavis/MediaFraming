
doc = htmlParse(hfile)
h = getNodeSet(doc, "//head")

newXMLNode("script", attrs = c(src = "poll.js"), parent = h)

houses = c("QUINN", "SRBI")

def = sprintf("var HouseNames = %s;", toJSON(houses))
newXMLNode("script", def, attrs = c(type = "javascript"), parent = h)


div = getNodeSet(doc, "//div[@class = 'htmlwidget_container']")[[1]]
newXMLNode("input", atts = c(type = "button", value = "toggle polling data", onclick = "togglePolling()"), parent = div) 
