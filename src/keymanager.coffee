define ['jquery'], ($) ->

  class KeyManager
    @getKeycode = (key) ->
      code = parseInt(key)
      if not isNaN(code) then return code

      switch key
        when "<-", "<=", "left", "arrowleft" then 37
        when "up", "arrowup" then 38
        when "->", "=>", "right", "arrowright" then 39
        when "down", "arrowdown" then 40
        when "space", " " then 32
        when "esc" then 27
        when "enter" then 13
        when "backspace" then 8
        when "tab" then 9
        when "pageup" then 33
        when "pagedown" then 34
        when "end" then 35
        when "home" then 36
        when "delete" then 46
        else key.toUpperCase().charCodeAt(0)

    constructor: ->
      if KeyManager.instance? then return KeyManager.instance
      else
        KeyManager.instance = @
        do @_init

    _init: ->
      @_handlers = {}
      $(document).keyup (ev) =>
        _.each @_handlers, (handlers, key) ->
          if ev.which is parseInt(key)
            _.each handlers, (handlerObj) ->
              handlerObj.handler.call handlerObj.owner, ev

    # Adds a handler for a key.
    # @param key - the key: character, alias or ASCII code 
    # @param handler - handler function
    # @param owner - who has attached the handler
    bind: (key, handler, owner) ->
      key = KeyManager.getKeycode key
      # store an array of handlers for each keycode
      if not @_handlers[key]? then @_handlers[key] = []
      @_handlers[key].push { handler, owner }

    # Unbinds key handlers for given owner and keys.
    # @param owner - who has attached the handler
    # @param keys - array of keys, removes all handlers if no keys are specified
    unbind: (owner, keys) ->
      if not _.isArray(keys) then keys = Array.prototype.splice.call arguments, 1
      keys = _.map keys, (key) -> KeyManager.getKeycode(key).toString()
      _.each @_handlers, (handlers, key) =>
        i = 0
        while i < handlers.length
          handler = handlers[i++]
          if handler.owner is owner 
            if not keys.length or _.contains keys, key
              handlers.splice --i, 1
        if handlers.length is 0 then delete @_handlers[key]
