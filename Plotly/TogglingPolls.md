
There are various different strategies we can use to toggle the polling
data on and off.


One is to add a button to the HTML as a child of the 
   <div class="htmlwidget_container">
node. Then we add an event handler to this that 
toggles the polling information.

We could add this to the plotly control panel in the top-right.

1. One "hack" to toggle the polling information is 
+ find the "elements" in the legend corresponding to the polling houses
+ send a synthetic event to each of these 

1. Another approach is to do what that event handler on each polling house legend item
does.

1. Another is to group all the elements in the plot corresponding to the polling
 data and then toggle the visibility of that SVG <g> element with our button.
 
 


For synthetic events, see dispatchEvent.html for an example of creating and dispatching
the event.
What remains is finding the elements corresponding to the polling
