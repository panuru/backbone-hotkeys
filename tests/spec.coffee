define ['keymanager', 'jquery', 'backbone-view-patch'], (KeyManager, $) ->

  describe 'Hotkeys', ->

    class MyView extends Backbone.View
      hotkeys: 
        events:
          'a': 'handleA'
          'b': 'handleB'
        triggers:
          'up': 'keypress:up'
          'down': 'keypress:down'
          'left': 'keypress:left'
          'right': 'keypress:right'
          'a': 'keypress:a'
          'b': 'keypress:b'

      handleA: -> console.log 'hgjhgjgjjh'
      handleB: ->
    
    press = (keys) ->
      keys = Array::splice.call arguments, 0 unless _.isArray keys
      _.each keys, (key) ->
        key = KeyManager.getKeycode key
        $(document).trigger $.Event 'keyup', which: key, keyCode: key

    view = null
    keystrokes = null

    beforeEach ->

      @spyOn MyView::, 'handleA'
      @spyOn MyView::, 'handleB'

      view = new MyView

      keystrokes = []

      view.on 'keypress:up', -> keystrokes.push 'up'
      view.on 'keypress:down', -> keystrokes.push 'down'
      view.on 'keypress:left', -> keystrokes.push 'left'
      view.on 'keypress:right', -> keystrokes.push 'right'
      view.on 'keypress:a', -> keystrokes.push 'a'
      view.on 'keypress:b', -> keystrokes.push 'b'

    afterEach ->
      view.off()

    it 'should handle single keystroke', ->
      press 'a'
      expect(view.handleA).toHaveBeenCalled()

    it 'should handle keystroke sequence in correct order', ->
      konami = ['up', 'up', 'down', 'down', 'left', 'right', 'left', 'right', 'b', 'a']
      press konami
      expect(keystrokes).toEqual konami

