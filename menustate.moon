require "util"

Particle = -> {
    x: _SETTINGS["width"] * math.random!
    y: _SETTINGS["height"] + 30
    life: 4
    vx: 0
    vy: -200
    rad: 12 + 20 * math.random!
    col: 20 * math.random!
    Update: (dt) =>
      @x += @vx * dt
      @y += @vy * dt
      @rad *= 0.975
      if @rad <= 0.1 then @rad = 0
    Draw: =>
      love.graphics.setColor  150 + @col, 200, 200 + @col, 255 * @alpha
      love.graphics.circle 'fill', @x, @y, @rad, 16
      love.graphics.setColor  255, 255, 255
  }

export MenuState
MenuState = -> {
  font: love.graphics.newFont 48
  titleFont: love.graphics.newFont 96
  creditsFont: love.graphics.newFont 24
  mainMenu: {
    {"Play", {0, 300, _SETTINGS["width"], 350}, -> MainMenu\SwitchContent {}}
    {"Options", {0, 350, _SETTINGS["width"], 400}, -> MainMenu\SwitchContent {}}
    {"Credits", {0, 400, _SETTINGS["width"], 450}, -> MainMenu\SwitchContent MainMenu.content_credits}
    {"Exit", {0, 450, _SETTINGS["width"], 500}, -> love.event.quit!}
  }

  hover: 0
  nextcontent: nil
  content: nil
  content_credits: {
    Update: =>
    Draw: =>
      love.graphics.setFont MainMenu.creditsFont
      love.graphics.setColor 0, 0, 0
      love.graphics.print "The guy who did the things:", 400, 50
      love.graphics.print "BearishMushroom", 400, 80
      love.graphics.print "Nobody helped me.", 400, 250
      love.graphics.print "I literally did everything.", 400, 280
      love.graphics.print "Every. Single. Thing.", 400, 380

      love.graphics.print "Except for the engine,", 400, 500
      love.graphics.print "I guess.", 400, 530
  }

  contentoff: {x:0,y:0}
  menuoff: {x:0,y:0}

  menu: nil
  nextmenu: nil
  SwitchMenu: (newmenu) =>
    @nextmenu = newmenu
    @menuoff.x = 0
    @menuoff.y = 0
  SwitchContent: (newcontent) =>
    @nextcontent = newcontent
    @contentoff.x = 0
    @contentoff.y = 0
  Update: (dt) =>
    if not @menu
      @menu = @mainMenu

    if math.random! > 0.5
      Particles\Add Particle!

    found = false
    for i, v in ipairs @menu
      x, y = love.mouse.getPosition!

      if IsInRect v[2], x, y
        @hover = i
        found = true
        break

    if not found
      @hover = 0

    if (Mouse\IsPressed 1) and @contentoff.x == 0 and @contentoff.y == 0
      if @menu[@hover]
        @menu[@hover][3]!
      @hover = 1000

    if @content
      if @content.Update
        @content\Update dt

    if @nextcontent
      @contentoff.y -= _SETTINGS["height"] * dt * 2
      if @menuoff.x < 0 then @menuoff.x += _SETTINGS["width"] * 0.6 * dt
      if @contentoff.y <= -_SETTINGS["height"]
        @contentoff.y = 0
        @contentoff.x = _SETTINGS["width"]
        @content = @nextcontent
        @nextcontent = nil
        if @content.Load
          @content\Load!
    elseif @contentoff.x != 0
      @contentoff.x -= _SETTINGS["width"] * dt * 2
      @menuoff.x -= _SETTINGS["width"] * 0.6 * dt
      if @contentoff.x <= 0
        @contentoff.x = 0

  Draw: =>
    love.graphics.setColor 200, 200, 200
    love.graphics.rectangle 'fill', 0, 0, _SETTINGS["width"], _SETTINGS["height"]

    Particles\Draw!

    love.graphics.setFont @font
    love.graphics.setColor 0, 0, 0

    if @menu
      love.graphics.push!
      love.graphics.translate @menuoff.x, @menuoff.y, 0
      for i, v in ipairs @menu
        love.graphics.printf v[1], v[2][1], v[2][2], v[2][3] / (if @hover == i then 1.3 else 1), "center", 0, if @hover == i then 1.3 else 1
      love.graphics.pop!

    if @content
      if @content.Draw
        love.graphics.push!
        love.graphics.translate @contentoff.x, @contentoff.y, 0
        @content\Draw!
        love.graphics.pop!

    love.graphics.setColor 0, 0, 0
    love.graphics.setFont @titleFont
    love.graphics.printf "LD36", @menuoff.x, 50, _SETTINGS["width"], "center"

}
