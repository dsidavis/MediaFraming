This discusses the structure of the Plotly plots Matt created.
We are examining the HTML after the plotly code has dynamically generated
the SVG nodes.

**Note**  We cannot use these files to post-process the nodes.
When we reload the HTML files, they render fine, but the interactivity 
is gone.

We get the SVG nodes with:
```
ns = h = htmlParse("ssm.html")
svg = getNodeSet(s, "//svg")
```


The attributes on each of the top-level SVG nodes are not very interesting or
suggestive:
```
sapply(svg, xmlAttrs)
```

The first SVG node in the node-set contains the axes.



Plotly plots, like ggplots, are arranged as layers.
Within each <SVG> node, we have a <defs> for reusable components
and then  layers.

We can see the layers with
```
sapply(svg[[1]][-1], xmlGetAttr, "class")
```
```
               g                g                g                g 
       "bglayer"      "draglayer"    "layer-below" "cartesianlayer" 
               g                g                g                g 
  "ternarylayer"       "geolayer"    "layer-above"       "pielayer" 
               g 
      "glimages"
```

Five of the 9 <g> layers in this <SVG> node have children.
```
sapply(svg[[1]][-1], xmlGetAttr, "class")[sapply(svg[[1]][-1], xmlSize) > 0]
```
```
               g                g                g                g 
       "bglayer"      "draglayer"    "layer-below" "cartesianlayer" 
               g 
   "layer-above" 
```

The second <SVG> has
```
sapply(svg[[2]][-1], xmlGetAttr, "class")
```
```
 "infolayer"  "zoomlayer" "hoverlayer"
```

The labels for the legend are in the 2nd SVG element under the infolayer.
The top_frame and N labels are in the 2nd child of the 2nd SVG under @class='annotation'.



## Traces
There are 98 nodes whose @class contains trace followed by a space:
```
length(getNodeSet(s, "//*[contains(@class, 'trace ')]"))
```
These look like
`trace scatter trace01a6c7`

There are 36 nodes with a class value of 'traces'.
These correspond to all of the labels in the legend.

Are there other places where a label in the legend occurs:
```
getNodeSet(s, "//text[. = 'SRBI']")
```
What about attributes
```
getNodeSet(s, "//*[@* = 'SRBI']")
```
These give the same node.
