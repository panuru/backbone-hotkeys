Backbone Hotkeys
================

Adds hotkey events support to Backbone views. Uses require.js, written in CoffeeScript.

## Example:

    class MyView extends Backbone.View
      hotkeys: 
        # events hash works just like Backbone ui events
        events: 
          # .. accepting method names
          'q': 'quit'
          # .. or inline functions
          'x': -> ...

        # triggers are similar to Marionette triggers:
        triggers: 
          # .. this will trigger 'hotkey:escape' event on the view when escape key is pressed
          'esc': 'hotkey:escape' 

## Usage:

You can either include backbone-view-patch.js to monkey-patch Backbone.View, or include hotkeys-mixin.js to apply the mixin manually:

    require 'hotkeys-mixin', (hotkeys) ->
      MyViewWithHotkeys = hotkeys.mixinTo class extends Backbone.View
        ...

## Todo:

* Support multi-key hotkeys (e. g. 'ctrl+a', ['up', 'up', 'down', 'down', 'left', 'right', 'left', 'right', 'b', 'a'])
