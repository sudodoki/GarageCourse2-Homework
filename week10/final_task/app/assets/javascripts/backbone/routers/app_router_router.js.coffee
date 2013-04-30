class FinalTask.Routers.AppRoutersRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    '/*':  index

  index: () ->
    console.log 'lol'
