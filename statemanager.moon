class _StateManager
  new: =>
    @states = {}
    @currentName = ""
    @currentState = nil
    @transFactor = 0
    @nextState = nil

  SetState: (name, state) =>
    if state
      @states[name] = state

    @transFactor = 0
    @nextState = @states[name]
    @currentName = name

  GetState: =>
    @currentName

  Update: (dt) =>
    if @nextState
      @transFactor += dt
      if @transFactor >= 1
        @currentState = @nextState
        @nextState = nil
    elseif @transFactor > 0
      @transFactor -= dt
    elseif @currentState
      @currentState\Update dt

  Draw: =>
    if @currentState
      @currentState\Draw!

    if @transFactor > 0
      love.graphics.setColor 0, 0, 0, 255 * @transFactor
      love.graphics.rectangle 'fill', 0, 0, _SETTINGS['width'], _SETTINGS["height"]
      love.graphics.setColor 255, 255, 255

export StateManager = _StateManager!
