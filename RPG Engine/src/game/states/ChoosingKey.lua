local beholder = require('lib.beholder')
local Game = require('src.game.Game')

local ChoosingKey = Game:addState('ChoosingKey')

local id

function ChoosingKey:enteredState()
  id = beholder.observe('keypressed', function(key)
    if key ~= 'escape' then
      self.config.keys[self.modifiedAction] = key
      self:gotoState('KeyboardMenu')
    end
  end)
end

function ChoosingKey:exitedState()
  beholder.stopObserving(id)
  self.config:save()
end

function ChoosingKey:draw()
  love.graphics.rectangle('line', 250, 250, 300, 100)
  love.graphics.printf("Press key for " .. self.modifiedAction, 250, 295, 300, 'center')
end

function ChoosingKey:escape()
  self:gotoState('KeyboardMenu')
end

return ChoosingKey
