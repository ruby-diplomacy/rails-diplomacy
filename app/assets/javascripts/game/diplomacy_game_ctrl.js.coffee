'use strict'

window.DiplomacyGameCtrl = [
  '$scope'
  '$http'
  'MapService'
  'StateService'
  ($scope, $http, MapService, StateService) ->
    $scope.paper = Raphael "map", 900, 800
    $scope.paper.setViewBox(0, 0, 610, 560, true)

    $scope.map = MapService.query (data) ->
      paper = $scope.paper

      for area of data
        path = paper.path(data[area]['path'])
        $(path.node).attr( fill: '#FFF' )
        path.hover (e) ->
          if not @gl
            @gl = @glow({ color: "#008080", width: 7 }).toFront()
        , (e) ->
          @gl.remove()
          @gl = false
      
      StateService.query (data) ->
        console.log data.state
]
