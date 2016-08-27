class _Keyboard
  new: =>
    @keys = {}
    @pressed = {}
    @released = {}
    @cbs = {}

  Register: (key, name, cb) =>
    if type(key) == "table"
      for i in *key
        @Register i, name, cb

      return

    if not @cbs[key]
      @cbs[key] = {}

    if not cb
      cb = name
      name = tostring cb

    @cbs[key][name] = cb

  Unregister: (key, name) =>
    if type(key) == "table"
      for i in *key
        @Unregister i, name

      return

    if not @cbs[key]
      return

    if not cb
      cb = name
      name = tostring cb

    if not @cbs[key][name]
      return

    @cbs[key][name] = nil

  Press: (key) =>
    @keys[key] = true
    if @cbs[key]
      for i, v in pairs(@cbs[key]) do v true

  Release: (key) =>
    @keys[key] = false
    if @cbs[key]
      for i, v in pairs(@cbs[key]) do v false

  IsDown: (key) =>
    @keys[key] or false

  IsUp: (key) =>
    not @keys[key] or true

  IsPressed: (key) =>
    @pressed[key] or false
 
  IsReleased: (key) =>
    @released[key] or false

  Update: =>
    @pressed = {}
    @released = {}

export Keyboard = _Keyboard!

love.keypressed = (key, scan, rep) ->
  Keyboard\Press key
  Keyboard.pressed[key] = true

love.keyreleased = (key, scan, rep) ->
  Keyboard\Release key
  Keyboard.released[key] = true
