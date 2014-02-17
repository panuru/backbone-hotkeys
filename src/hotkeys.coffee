define ['keymanager'], (KeyManager) ->

  keyManager = new KeyManager

  (View) ->

    delegateEvents:  ->
      do @configureHotkeys
      View::delegateEvents.apply @, arguments

    undelegateEvents: ->
      do @unbindHotkeys
      View::undelegateEvents.apply @, arguments

    # prepare handlers for hotkeys (only single keystrokes for now)
    configureHotkeys: ->
      @_suspendedHotkeys = []
      do @addKeyHandlers

    addKeyHandlers: (keys) ->
      if not @hotkeys? then return 

      addHandler = (key, handler) =>
        if not keys? or _.contains keys, key
          keyManager.bind key, handler, @

      if @hotkeys.events?
        _.each @hotkeys.events, (handler, key) =>
          addHandler key, if _.isString handler then @[handler] else handler
      if @hotkeys.triggers?
        _.each @hotkeys.triggers, (eventName, key) =>
          addHandler key, => @.trigger eventName

    # unbinds all hotkeys of the view
    unbindHotkeys: ->
      keyManager.unbind @

    # suspend the hotkeys, to be resumed later
    suspendHotkeys: (keys) ->
      if not _.isArray keys then keys = Array::splice.call arguments, 0
      Array::push.apply @_suspendedHotkeys, keys
      keyManager.unbind @, keys

    # resume suspended hotkeys
    resumeHotkeys: (keys) ->
      if not _.isArray keys then keys = Array::splice.call arguments, 0
      resumingKeys = []; k = null
      while k = @_suspendedHotkeys.pop()
        if _.contains keys, k then resumingKeys.push k
      keys = resumingKeys
      if keys.length then @addKeyHandlers keys
