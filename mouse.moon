class _Mouse
  new: =>
    @x = 0
    @y = 0
    @buttons = {}
    @pressed = {}
    @released = {}
    @cbs = {}

  Register: (button, name, cb) =>
    if type(button) == "table"
      for i in *button
        @Register i, name, cb

      return

    if not @cbs[button]
      @cbs[button] = {}

    if not cb
      cb = name
      name = tostring cb

    @cbs[button][name] = cb

  Unregister: (button, name) =>
    if type(button) == "table"
      for i in *button
        @Unregister i, name

      return

    if not @cbs[button]
      return

    if not cb
      cb = name
      name = tostring cb

    if not @cbs[button][name]
      return

    @cbs[button][name] = nil

  Press: (button) =>
    @buttons[button] = true
    if @cbs[button]
      for i, v in (pairs @cbs[button]) do v true

  Release: (button) =>
    @buttons[button] = false
    if @cbs[button]
      for i, v in (pairs @cbs[button]) do v false

  IsDown: (button) =>
    @buttons[button] or false

  IsUp: (button) =>
    not @buttons[button] or true

  IsPressed: (button) =>
    @pressed[button] or false

  IsReleased: (button) =>
    @released[button] or false

  Update: =>
    @pressed = {}
    @released = {}
    @x, @y = love.mouse.getX!, love.mouse.getY!

export Mouse = _Mouse!

love.mousepressed = (x, y, button, isTouch) ->
  Mouse\Press button
  Mouse.pressed[button] = true

love.mousereleased = (x, y, button, isTouch) ->
  Mouse\Release button
  Mouse.released[button] = true
