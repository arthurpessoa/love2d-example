local Menu = require 'lib.menu'
local Game = require 'src.game.Game'

local MainMenu = Game:addState('MainMenu')

function MainMenu:enteredState()
  self:log('Entering MainMenu')

  self.menu = Menu:new({
    { 'Start Game', function() self:pushState('Play') end },
    { 'Options',    function() self:gotoState('OptionsMenu')    end },
    { 'Exit',       function() self:exit()                      end }
  })
end

function MainMenu:draw()
  self.menu:draw()
end

function MainMenu:exitedState()
  self.menu:destroy()
  self.menu = nil
end

function MainMenu:pausedState()
  self.menu:deactivate()
end

function MainMenu:continuedState()
  self.menu:activate()
end

function MainMenu:escape()
  self:exit()
end

return MainMenu
