'use strict'

class Map
  constructor: (data, paper) ->
    @areas = data.areas
    @powers = data.powers
    @paper = paper
    
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

  apply_state: (state) ->
    for abbrv, area_state of state
      if area_state.owner
        colour = @powers[area_state.owner].colour
        try
          @areas[abbrv].path.attr( fill: colour )
        catch error
          console.error error

window.Map = Map
