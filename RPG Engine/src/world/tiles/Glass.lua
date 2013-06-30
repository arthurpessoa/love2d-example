local Tile = require 'src.world.tiles.Tile'

local Glass = class(..., Tile)

function Glass:initialize(cell)
  Tile.initialize(self,cell,4,1)
  self.solid = true
end

return Glass
