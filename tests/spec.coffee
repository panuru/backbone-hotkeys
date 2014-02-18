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

      handleA: -> 
      handleB: ->
    
    press = (keys) ->
      keys = Array::splice.call arguments, 0 unless _.isArray keys
      _.each keys, (key) ->
        keyCode = KeyManager.getKeycode key
        $(document).trigger $.Event 'keyup', which: keyCode, keyCode: keyCode

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

    it 'should suspend and resume hotkeys', ->
      press 'up'
      view.suspendHotkeys()
      press 'up'
      view.resumeHotkeys()
      press 'down'
      expect(keystrokes).toEqual ['up', 'down']

    it 'should suspend and resume specific keys', ->
      view.suspendHotkeys 'up', 'down'
      press 'up', 'down', 'left'
      view.resumeHotkeys 'up'
      press 'up', 'down'
      expect(keystrokes).toEqual ['left', 'up']

    it 'should suspend hotkeys when view is disposed', ->
      view.remove()
      press 'up', 'a'
      expect(view.handleA).not.toHaveBeenCalled()
      expect(keystrokes).toEqual []

