library(RJSONIO)
library(XML)

fix = 
function(hfile, out = NA, doc = htmlParse(hfile), houses = c("ABC", "FOX"))
{
    h = getNodeSet(doc, "//head")[[1]]

    # may want the type attribute.
    newXMLNode("script", attrs = c(src = "poll.js"), parent = h)


    def = sprintf("var HouseNames = %s;", toJSON(houses))
    newXMLNode("script", def, attrs = c(type = "text/javascript"), parent = h)

    div = getNodeSet(doc, "//div[@id = 'htmlwidget_container']")[[1]]
    newXMLNode("input", attrs = c(type = "button", value = "toggle polling data", onclick = "togglePolling()"), parent = div)

    if(!is.na(out))
        saveXML(doc, out)
    else
        doc
}
