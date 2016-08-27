export LoadSettings, PushSettings
LoadSettings = ->
  filepath = "conf/settings.lua"

  if not love.filesystem.exists "conf"
    love.filesystem.createDirectory "conf"

  if not love.filesystem.exists filepath
    love.filesystem.write filepath, [[
return {
  width = 800,
  height = 600,
}
      ]]

  file = love.filesystem.load filepath
  export _SETTINGS
  _SETTINGS = file!

  love.window.setMode _SETTINGS["width"], _SETTINGS["height"]

PushSettings = ->
  filepath = "conf/settings.lua"
  love.filesystem.remove filepath
  string = "return {"

  for i, v in pairs _SETTINGS
    string ..= "\n  " .. i .. " = " .. tostring(v) .. ","

  string ..= "\n}"

  love.filesystem.write filepath, string
