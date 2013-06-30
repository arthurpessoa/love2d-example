local Being  = require 'src.beings.Being'
local minds  = require_tree 'src.beings.minds'
local bodies = require_tree 'src.beings.bodies'

local Ghost = class(..., Being)

function Ghost:initialize(map, subject, x,y)
  Being.initialize(self, minds.FollowerMind:new(subject), bodies.GhostBody:new(map,x,y,40))
end

return Ghost
