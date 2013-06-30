local Game = require 'src.game.Game'

local NotImplemented = Game:addState('NotImplemented')

function NotImplemented:enteredState()
  self:log('Entering NotImplemented')
end

function NotImplemented:exitedState()
  self:log('Exiting NotImplemented')
end

function NotImplemented:draw()
  love.graphics.print("This state is not implemented. Press ESC to go back", 250, 280)
end

function NotImplemented:escape()
  self:popState()
end

return NotImplemented
