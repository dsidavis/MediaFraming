library(RJSONIO)
library(XML)

fix = 
function(hfile, out = NA, doc = htmlParse(hfile), houses = c("ABC", "FOX"), inline = TRUE, jsFile = "poll.js")
{
    # Dealing with &lt;DOCTYPE in the first line of the HTML that gets written in the html file for the plot by R/plotly
    ll = readLines(hfile)
    if(grepl("^&lt;", ll[1]))
        ll = ll[-1]
    hfile = ll
    
    h = getNodeSet(doc, "//head")[[1]]

    # may want the type attribute.
    if(inline)
       newXMLNode("script", paste(readLines(jsFile), collapse = "\n"), attrs = c(type = "text/javascript"), parent = h)
    else
       newXMLNode("script", attrs = c(src = jsFile), parent = h)        


    def = sprintf("var HouseNames = %s;", toJSON(houses))
    newXMLNode("script", def, attrs = c(type = "text/javascript"), parent = h)

    div = getNodeSet(doc, "//div[@id = 'htmlwidget_container']")[[1]]
    newXMLNode("input", attrs = c(type = "button", value = "toggle polling data", onclick = "togglePolling()"), parent = div)

    if(!is.na(out))
        saveXML(doc, out)
    else
        doc
}
