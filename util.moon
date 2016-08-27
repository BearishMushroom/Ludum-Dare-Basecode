export Clamp = (x, a, b) ->
  x < a and a or (x > b and b or x)

export IsInRect = (r, x, y) ->
  x > r[1] and x < r[3] and
  y > r[2] and y < r[4]

export SLerp = (x0, x1, t) ->
  t = Clamp t, 0, 1
  m = t * t * (3 - 2 * t)
  x0 + (x1 - x0) * m

export Length = (x, y) ->
  math.sqrt x * x + y * y

export Norm = (x, y) ->
  l = Length x, y
  x / l, y / l

export Distance = (x1, y1, x2, y2) ->
  Length x2 - x1, y2 - y1

export Remove = (t, item) ->
  index = 0
  for i, v in ipairs t
    if v == item
      index = i
      break

  table.remove t, index

export CCW = (ax, ay, bx, by, cx, cy) ->
  (cy-ay) * (bx-ax) > (by-ay) * (cx-ax)

export LineIntersect = (ax, ay, bx, by, cx, cy, dx, dy) ->
  CCW(ax, ay, cx, cy, dx, dy) != CCW(bx, by, cx, cy, dx, dy) and CCW(ax, ay, bx, by, cx, cy) != CCW(ax, ay, bx, by, dx, dy)

export LineRectangle = (lx1, ly1, lx2, ly2, r) ->
  (LineIntersect lx1, ly1, lx2, ly2, r[1], r[2], r[3], r[2]) or
  (LineIntersect lx1, ly1, lx2, ly2, r[1], r[2], r[1], r[4]) or
  (LineIntersect lx1, ly1, lx2, ly2, r[3], r[2], r[3], r[4]) or
  (LineIntersect lx1, ly1, lx2, ly2, r[1], r[4], r[3], r[4])
