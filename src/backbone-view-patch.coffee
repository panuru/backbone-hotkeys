# Patches Backbone.View to handle hotkeys.
#
# You can do it yourself with your custom views, calling
# hotkeys.mixinTo MyView
# (i.e. when using Marionette, or if you want to apply hotkeys only to specific
# views)
define ['backbone', 'hotkeys'], (Backbone, hotkeys) ->
  Backbone.View = hotkeys.mixinTo class extends Backbone.View
