#$ ->
#  $.getJSON '/assets/map.json', (data) ->
#    paper = Raphael "map", 900, 800
#    paper.setViewBox(0, 0, 610, 560, true)
#
#    for area of data
#      path = paper.path(data[area]['path'])
#      $(path.node).attr( fill: '#FFC' )
#      path.hover (e) ->
#        if not @gl
#          @gl = @glow({ color: "#CCCCCC", width: 5 }).toFront()
#      , (e) ->
#        @gl.remove()
#        @gl = false