function toggleHouse (house)
{
    var el = document.evaluate("//text[. = '" + house + "']/following-sibling::rect", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
    var ev = new Event('click');
    el.dispatchEvent(ev);
}

function togglePolling()
{
    for(i in HouseNames)
	toggleHouse(i);
}