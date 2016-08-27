-- Particles are tables
--   x, y
--   life
--   sx, sy (default = 1, 1)
--   alpha (default = 1)
--   (vx, vy) (optional)
--   fn update (optional)
--   sprite (optional)
--   fn draw (optional)
--   die ("fade" | "shrink" | "dissapear" | "fadeshrink" | fn) (default = "fade")
--   diePct (default = 1)

class _Particles
  new: =>
    @particles = {}

  Add: (particle) =>
    if not particle.sx
      particle.sx = 1

    if not particle.sy
      particle.sy = 1

    if not particle.alpha
      particle.alpha = 1

    if not particle.die
      particle.die = "fade"

    if not particle.diePct
      particle.diePct = 1

    particle.maxLife = particle.life

    @particles[#@particles+1] = particle

  Update: (dt) =>
    for i, v in ipairs @particles
      v.life -= dt

      if v.life <= 0
        table.remove @particles, i
        continue
      elseif v.life / v.maxLife < v.diePct
        factor = v.life / v.maxLife / v.diePct

        if (type v.die) == 'string'
          switch v.die
            when "fade"
              v.alpha = factor
            when "shrink"
              v.sx, v.sy = factor, factor
            when "fadeshrink"
              v.alpha, v.sx, v.sy = factor, factor, factor
        elseif (type v.die) == 'function'
          v.die factor

      if v.Update
        v\Update dt
      else if v.vx
        v.x += v.vx * dt
        v.y += v.vy * dt

  Draw: =>
    for i, v in ipairs @particles
      if v.Draw
        v\Draw!
      else if v.sprite
        love.graphics.draw v.sprite, v.x, v.y, v.sx, v.sy

export Particles = _Particles!
