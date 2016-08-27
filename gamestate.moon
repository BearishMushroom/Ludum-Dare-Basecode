require "keyboard"

export GameState
GameState = (levelname) -> {
  data: dofile levelname
  Build: =>
    @width = @data.width
    @height = @data.height
    @tileWidth = @data.tilewidth
    @tileHeight = @data.tileheight
    @entities = {}

    if @width < 1280
      @offX = (1280 - @width*@tileWidth) / 2

    @layers = {}
    for i, v in pairs @data.layers
      @layers[i] = {}
      @layers[i].name = v.name

      if v.type == "tilelayer"
        @layers[i].type = "tile"
        @layers[i].tiles = {}
        @layers[i].name = v.name
        for j, k in ipairs v.data
          if k != 0
            ins = {}
            ins.x = 0.5 + (j-1) % @width
            ins.y = 0.5 + math.floor (j-1) / @width
            ins.tileID = k
            @layers[i].tiles[#@layers[i].tiles + 1] = ins
      elseif v.type == "objectgroup"
        @layers[i].type = "object"
        @layers[i].objects = {}
        @layers[i].name = v.name
        for j, k in ipairs v.objects
          ins = {}
          ins.x = math.floor k.x
          ins.y = math.floor k.y
          ins.width = math.floor k.width
          ins.height = math.floor k.height
          ins.name = k.name
          @layers[i].objects[#@layers[i].objects + 1] = ins

    for i, v in ipairs @layers
      if v.type == "object"
        if v.name == "entities"
          for j, k in ipairs v.objects
            if string.match k.name, "%("
              -- If the string contains a (, run the name as code.
              f = loadstring "return " .. k.name
              @entities[#@entities + 1] = f!
              @entities[#@entities].x = k.x + k.width / 2
              @entities[#@entities].y = k.y + k.height / 2
              @entities[#@entities].map = @
              @entities[#@entities]\Init!

  Reset: =>
    @entities = {}
    @layers = {}
    @Build!

  GetLayer: (name) =>
    for i, v in ipairs @layers
      if v.name == name
        return v

    return nil

  Turn: =>
    for i, v in ipairs @entities
      v\Turn!

  Update: (dt) =>
    for i, v in ipairs @entities
      v\Update dt

    if Keyboard\IsPressed 'r'
      @\Reset!

    if Keyboard\IsPressed 'a'
      @\Turn!

  Draw: =>
    love.graphics.setColor 160, 160, 160
    love.graphics.rectangle 'fill', 0, 0, 1280, 720
    love.graphics.setColor 255, 255, 255

    x = @offX or 0
    y = @offY or 0
    for i, v in ipairs @layers
      if v.type == "tile"
        for j, k in ipairs v.tiles
          @spritesheet\Draw x + k.x * @tileWidth, y + k.y * @tileHeight, 0, 1, 1, k.tileID

    for i, v in ipairs @entities
      v\Draw x, y
}
