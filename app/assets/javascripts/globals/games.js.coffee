# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('div#orders form').on('ajax:success', (e, data, status, xhr) ->
    $('div.submit-status').hide()
    $('div#success.submit-status').css('display', 'inline')
  ).on('ajax:error', (e, data, status, error) ->
    $('div.submit-status').hide()
    $('div#failure.submit-status > span').text(data.responseJSON.orders)
    $('div#failure.submit-status').css('display', 'inline')
  )
