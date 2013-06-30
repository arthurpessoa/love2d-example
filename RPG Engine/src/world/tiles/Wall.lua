local Tile = require 'src.world.tiles.Tile'

local Wall = class(..., Tile)

function Wall:initialize(cell)
  Tile.initialize(self,cell,2,1)
  self.solid = true
  self.opaque = true
end

return Wall
