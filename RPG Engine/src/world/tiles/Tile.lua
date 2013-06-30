local anim8 = require 'lib.anim8'
local media = require 'src.media'

local Tile = class(..., nil)

Tile.static.TILEW = 16
Tile.static.TILEH = 16

local grid = anim8.newGrid(Tile.TILEW, Tile.TILEH*3, 1024, 1024)

function Tile:initialize(cell, quadX, quadY)
  self.cell = cell
  self.quad = grid(quadX, quadY)[1]
end

function Tile:isPassableBy(body)
  if (body.solid  and self.solid) or
     (body.walker and self.hole)  then
    return false
  end
  return true
end

function Tile:draw()
  love.graphics.drawq(media.images.tiles, self.quad, self.cell.left, self.cell.top - Tile.TILEH)
end

return Tile
