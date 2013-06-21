'use strict'

window.DiplomacyGameCtrl = [
  '$scope'
  '$http'
  ($scope, $http) ->
    $http.get("/assets/map.json").success (data) ->
      console.log "What is this trickery?"
      paper = Raphael "map", 900, 800
      paper.setViewBox(0, 0, 610, 560, true)

      for area of data
        path = paper.path(data[area]['path'])
        $(path.node).attr( fill: '#FFC' )
        path.hover (e) ->
          if not @gl
            @gl = @glow({ color: "#CCCCCC", width: 5 }).toFront()
        , (e) ->
          @gl.remove()
          @gl = false
]
