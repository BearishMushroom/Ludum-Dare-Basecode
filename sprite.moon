export class Sprite
  new: (image, width, height, rows, cols, animationtime) =>
    @image = image
    @image\setFilter "nearest", "nearest"
    @frameWidth = width or @image\getWidth!
    @frameHeight = height or @image\getHeight!
    @width = @image\getWidth!
    @height = @image\getHeight!
    @rows = rows or @height / @frameHeight
    @cols = cols or @width / @frameWidth
    @frames = @rows * @cols

    if type animationtime == 'number'
      @animated = true
      @variedTime = false
      @frameTime = animationtime
    elseif type animationtime == 'table'
      @animated = true
      @variedTime = true
      @frameTime = animationtime
      @frames = #animationtime
    else
      @animated = false

    @currentFrame = 1
    @currentTime = 0
    @loops = 0

    currentFrameX = 0
    currentFrameY = 0
    @quads = {}
    for i = 1, @frames 
      @quads[#@quads + 1] = love.graphics.newQuad currentFrameX * @frameWidth, currentFrameY * @frameHeight, @frameWidth, @frameHeight, @width, @height
      currentFrameX = currentFrameX + 1
      if currentFrameX > @cols - 1 then
        currentFrameX = 0
        currentFrameY = currentFrameY + 1

  Update: (dt) =>
    self.currentTime += dt

    if @animated and @variedTime
      if @currentTime >= @frameTime[@currentFrame]
        @currentFrame = @currentFrame + 1
        @currentTime = 0
    elseif @animated
      if @currentTime >= @frameTime
        @currentFrame = @currentFrame + 1
        @currentTime = 0

    if @currentFrame > @frames
      @currentFrame = 1
      @loops = @loops + 1

  Draw: (x, y, rot, sx, sy, frame) =>
    scx = sx or 1
    scy = sy or scx
    r = rot or 0
    f = frame or @currentFrame
    if @animated or frame
      love.graphics.draw @image, @quads[f], x, y, r, scx, scy, @frameWidth / 2, @frameHeight / 2
    else
      love.graphics.draw @image, x, y, r, scx, scy, @frameWidth / 2, @frameHeight / 2
