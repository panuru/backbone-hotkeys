backbone-hotkeys
================

Views with hotkey events for Backbone.js

# Example:

    var View = Backbone.View.extend({
      hotkeys: {
        // events hash works just like Backbone ui events
        events: {
          // .. accepting method names
          'q': 'quit'
          // .. or inline functions
          'x': function() { .. }
        },
        // triggers is similar to Marionette triggers:
        triggers: {
          // .. this will trigger 'hotkey:escape' event on the view when escape
          // key is pressed
          'esc': 'hotkey:escape' 
        }
      }
    });
