# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
#
jQuery  ->
  faye = new Faye.Client('http://192.168.1.200:9292/faye')
  channel = $('#message-list').data('channel')
  faye.subscribe channel, (data) ->
    eval(data)
    $('#message-list').scrollTo('max')

  $('#new_message').live 'ajax:complete', (event, xhr, status) ->
   $('#message_text').val ''




