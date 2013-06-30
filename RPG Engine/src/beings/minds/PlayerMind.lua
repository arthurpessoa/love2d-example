local beholder    = require 'lib.beholder'
local Mind        = require 'src.beings.minds.Mind'

local PlayerMind = class(..., Mind)

function PlayerMind:initialize()
  Mind.initialize(self)

  beholder.group(self, function()
    for _,action in ipairs({'up','down','right','left'}) do
      beholder.observe('start_player_action', action, function() self.wishes[action] = true end)
      beholder.observe('stop_player_action',  action, function() self.wishes[action] = false end)
    end
  end)
end

function PlayerMind:destroy()
  beholder.stopObserving(self)
end

return PlayerMind
