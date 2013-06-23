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

      for own area of data.areas
        path = paper.path(data.areas[area]['path'])
        type = data.areas[area]['type']
        data.areas[area]['path'] = path

        switch type
          when "sea"
            $(path.node).attr( fill: '#488BB8' )
          when "impassable"
            $(path.node).attr( fill: '#B6B6B6' )
          when "land"
            $(path.node).attr( fill: '#E9E390' )
          else
            console.log data.areas[area]['type']
            $(path.node).attr( fill: '#FFF' )

        unless type == "impassable"
          path.hover (e) ->
            if not @gl
              @gl = @glow({ color: "#008080", width: 7 }).toFront()
          , (e) ->
            @gl.remove()
            @gl = false

      StateService.query( (data) ->
        for abbrv, area_state of data.state
          if area_state.owner
            colour = $scope.map.powers[area_state.owner].colour
            try
              $scope.map.areas[abbrv].path.attr( fill: colour )
            catch error
              console.error error

      , (err) ->
        console.error err
      )
]
