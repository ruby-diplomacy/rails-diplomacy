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
          $(path.node).attr( fill: '#F7F4C3' )
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
      try
        area = @areas[abbrv]
        if area_state.owner
          colour = @power_color area_state.owner
          area.path.attr( fill: colour )
        if area_state.unit
          unit = area_state.unit

          if area_state.coast
            area = @areas["#{abbrv}(#{area_state.coast})"]
          else
            area = @areas[abbrv]

          if unit.type == 1
            paperUnit = @paper.circle area.coords[0], area.coords[1], 5
          else
            height = 10
            width = 20
            paperUnit = @paper.rect( area.coords[0] - width/2, area.coords[1] - height/2, width, height)

          paperUnit.attr( fill: @power_color unit.nationality )
      catch error
        console.error error

  power_color: (power) ->
    return @powers[power].colour

window.Map = Map
