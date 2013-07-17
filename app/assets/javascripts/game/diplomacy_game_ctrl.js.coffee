'use strict'

window.DiplomacyGameCtrl = [
  '$scope'
  '$http'
  'MapService'
  'StateService'
  ($scope, $http, MapService, StateService) ->
    $scope.paper = Raphael "map", "100%", 700
    $scope.paper.setViewBox(0, 0, 610, 560, false)

    MapService.query (data) ->
      $scope.map = new Map(data, $scope.paper)

      # map initialized, get state
      # perhaps could be parallelized
      StateService.query( (data) ->
        $scope.map.apply_state data.state
      , (err) ->
        console.error err
      )
]
