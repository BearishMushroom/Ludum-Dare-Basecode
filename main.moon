require "keyboard"
require "particles"
require "statemanager"
require "settings"
require "mouse"
require "menustate"
require "gamestate"
require "sprite"

love.load = ->
  LoadSettings!
  export MainMenu
  MainMenu = MenuState!
  StateManager\SetState "MainMenu", MainMenu

love.update = (dt) ->
  (require "lib.lurker").update dt
  Particles\Update dt
  StateManager\Update dt
  Keyboard\Update!
  Mouse\Update!

love.draw = ->
  StateManager\Draw!
