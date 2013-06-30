local Tile = require 'src.world.tiles.Tile'

local Hole = class(..., Tile)

function Hole:initialize(cell)
  Tile.initialize(self,cell,3,1)
  self.hole = true
end

return Hole
