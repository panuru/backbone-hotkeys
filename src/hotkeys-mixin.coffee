# A mixin to extend Backbone.View with hotkey event handlers
# 
# Usage: require ['hotkeys'], (hotkeys) -> hotkeys.mixinTo View

define ['keymanager'], (KeyManager) ->

  keyManager = new KeyManager

  mixinTo: (View) ->

    class HotkeysView extends View

    _.extend HotkeysView::, 

      delegateEvents:  ->
        do @configureHotkeys
        View::delegateEvents.apply @, arguments

      undelegateEvents: ->
        do @unbindHotkeys
        View::undelegateEvents.apply @, arguments

      remove: ->
        do @unbindHotkeys
        View::remove.apply @, arguments

      # prepare handlers for hotkeys (only single keystrokes for now)
      configureHotkeys: ->
        @_suspendedHotkeys = []
        do @addKeyHandlers

      addKeyHandlers: (keys) ->
        if not @hotkeys? then return 

        addHandler = (key, handler) =>
          if not keys? or _.contains keys, key
            keyManager.on key, handler, @

        if @hotkeys.events?
          _.each @hotkeys.events, (handler, key) =>
            addHandler key, if _.isString handler then @[handler] else handler
        if @hotkeys.triggers?
          _.each @hotkeys.triggers, (eventName, key) =>
            addHandler key, => @.trigger eventName

      # unbinds all hotkeys of the view
      unbindHotkeys: ->
        keyManager.off @

      # suspend the hotkeys, to be resumed later
      suspendHotkeys: (keys) ->
        if not _.isArray keys then keys = Array::splice.call arguments, 0
        if !keys.length then keys = _.union _.keys(@hotkeys.events), _.keys(@hotkeys.triggers)
        Array::push.apply @_suspendedHotkeys, keys
        keyManager.off @, keys

      # resume suspended hotkeys
      resumeHotkeys: (keys) ->
        if not _.isArray keys then keys = Array::splice.call arguments, 0
        if !keys.length then keys = _.union _.keys(@hotkeys.events), _.keys(@hotkeys.triggers)
        resumingKeys = []; k = null
        while k = @_suspendedHotkeys.pop()
          if _.contains keys, k then resumingKeys.push k
        if resumingKeys.length then @addKeyHandlers resumingKeys

    HotkeysView
