
function NSResolver (nsPrefix)
{
    if (nsPrefix == "svg") {
        return "http://www.w3.org/2000/svg"
    }
    return null;
}

function toggleHouse (house)
{
    // /following-sibling::svg:rect
    var el = document.evaluate("//svg:text[. = '" + house + "']", document, NSResolver, XPathResult.ANY_TYPE, null);
    var tmp = el.iterateNext();
    alert("event: " + house + ' ' + tmp + ' ' + tmp.textContent + ' ');
    if(tmp) {
	tmp =  tmp.nextSibling;
	var ev = new Event('plotly_event');
	tmp.dispatchEvent(ev);
    }
}

var pollingOn = true;

function togglePolling()
{
//    for(i=0; i < HouseNames.length; i++)
//	toggleHouse(HouseNames[i]);

    // now toggle the dashed line.
    var el = document.evaluate("//svg:path[@class='js-line' and contains(@style, 'rgb(0, 0, 0)')]", document, NSResolver, XPathResult.ANY_TYPE, null);
    el = el.iterateNext();
    alert("line: " + el + ' pollingOn = ' + pollingOn);
    el.setAttribute('visibility', pollingOn ? 'hidden' : 'visible');
    pollingOn = !pollingOn;
}