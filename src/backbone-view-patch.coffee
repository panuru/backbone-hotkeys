define ['backbone', 'hotkeys'], (Backbone, hotkeys) ->
  View = Backbone.View
  Backbone.View = class extends View
  _.extend Backbone.View::, hotkeys(View)
  Backbone.View
