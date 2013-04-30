# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


console.log 'started listening'
window.source = new EventSource("/barcode/stream")
source.addEventListener "new", (e) ->
  data = JSON.parse(e.data)
  console.log data

$ ->
  $(window).onbeforeunload = ->
    console.log 'unloading'
    source.close()