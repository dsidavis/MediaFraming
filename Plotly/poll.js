
function NSResolver (nsPrefix)
{
    if (nsPrefix == "svg") {
        return "http://www.w3.org/2000/svg"
    }
    return null;
}


// Not being used now as synthetic events needs more discovery for plotly.
function toggleHouse (house)
{
    // Should find the /following-sibling::svg:rect and don't use nextSibling.
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

function findPollingPoints()
{
    xp = "//svg:g[contains(@class, 'trace ')]//svg:g[@class='points' and count(./svg:path) > 0]";
    var nodes = document.evaluate(xp, document, NSResolver, XPathResult.ANY_TYPE, null);
    return(nodes);
}

function togglePolling()
{
//    for(i=0; i < HouseNames.length; i++)
//	toggleHouse(HouseNames[i]);

    var nodes = findPollingPoints();
    var el;
    el = nodes.iterateNext();
    var els = [];
    while(el) {
	els.push(el);
	el = nodes.iterateNext();
    }
    // alert("number of nodes: " + els.length);
    for(i=0; i < els.length; i++) {
	els[i].setAttribute('visibility', pollingOn ? 'hidden' : 'visible');	
    }

    
    // toggle the smooth line if it is there.
    // relies on knowing its gray.
    var xp = "//svg:g[contains(svg:path/@style, 'rgb(190, 190, 190)')]";
    var el = document.evaluate(xp, document, NSResolver, XPathResult.ANY_TYPE, null);
    var sm = el.iterateNext();
    if(sm) {
	sm.setAttribute('visibility', pollingOn ? 'hidden' : 'visible');
    }
    
    // now toggle the dashed line.
    toggleLine();
    pollingOn = !pollingOn;    
}

function toggleLine()
{
    /*
     Expecting a black line.
     */
    var el = document.evaluate("//svg:path[@class='js-line' and contains(@style, 'rgb(0, 0, 0)')]", document, NSResolver, XPathResult.ANY_TYPE, null);
    el = el.iterateNext();
    //    alert("line: " + el + ' pollingOn = ' + pollingOn);
    if(el)
	el.setAttribute('visibility', pollingOn ? 'hidden' : 'visible');
}