local Tile = require 'src.world.tiles.Tile'

local Grass = class(..., Tile)

function Grass:initialize(cell)
  Tile.initialize(self,cell,1,1)
end

return Grass
