'use strict'

angular.module('diplomacyServices', ['ngResource'])
  .factory('MapService', ($resource) ->
    return $resource('/assets/map.json', {}, {
      query:
        method: "GET"
        isArray: false
    })
  )
  .factory('StateService', ($resource) ->
    return $resource('state.json', {}, {
      query:
        method: "GET"
        isArray: false
    })
  )
