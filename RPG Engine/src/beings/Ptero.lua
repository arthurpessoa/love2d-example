local Being  = require 'src.beings.Being'
local minds  = require_tree 'src.beings.minds'
local bodies = require_tree 'src.beings.bodies'

local Ptero = class('Ptero', Being)

function Ptero:initialize(map, subject, x,y)
  Being.initialize(self, minds.ScaredMind:new(subject), bodies.PteroBody:new(map,x,y,40))
end

return Ptero
