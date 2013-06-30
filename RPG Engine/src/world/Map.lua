local bresenham = require 'lib.bresenham'

local Grid  = require 'src.world.Grid'
local tiles = require_tree 'src.world.tiles'
local Tile  = tiles.Tile

local str = [[
###############################################################
#      #      v               vvvvv       vvvvv       vvvvv   #
#      #      v              vvvvvvv     vvvvvvv     vvvvvvv  #
#      $      v              vvvvvvv     vvvvvvv     vvvvvvv  #
#      #      v               vvvvv       vvvvv       vvvvv   #
#      $      vvvvvvvvv             vvvvv       vvvvv         #
#      #                #          vvvvvvv     vvvvvvv        #
#      #                           vvvvvvv     vvvvvvv        #
#      #                            vvvvv       vvvvv         #
#              ##########                                     #
#              #        #              vvvvvvvvvvv            #
#              #        #             vvvvvvvvvvvvv           #
#              $                     vvvv    vvvvvvv          #
#          v   $                     vvv      vvvvvv          #
#          v   $                     vvv      ######          #
#          v   #        #            vvv  $$                  #
#          v   #####    #            vvv  $$                  #
#          v            #            vvv      ######          #
###### ##################            vvv      vvvvvv          #
#                                    vvvv    vvvvvvv          #
#                                     vvvvvvvvvvvvv           #
#                                      vvvvvvvvvvv            #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#       $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$                 #
#       $                                   $                 #
#       $                                   $                 #
#       $              vvvvv                $                 #
#       $             vvvvvvv               $                 #
#       $              vvvvv                $                 #
#       $                                   $                 #
#       $                                   $                 #
#       $                                   $                 #
#       $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$                 #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
#                                                             #
###############################################################
]]

local legend = {
  [' '] = tiles.Grass,
  ['#'] = tiles.Wall,
  ['v'] = tiles.Hole,
  ['$'] = tiles.Glass
}

local Map = class(..., Grid)

function Map:initialize()
  local width = #(str:match("[^\n]+"))
  local _, height = str:gsub("\n", "")
  Grid.initialize(self, width, height, Tile.TILEW, Tile.TILEH)

  local x,y,cell = 1,1
  for row in str:gmatch("[^\n]+") do
    assert(#row == width, ("row %d has length %d instead of %d"):format(y, #row, width))
    x = 1
    for character in row:gmatch(".") do
      cell      = self.cells[y][x]
      cell.tile = legend[character]:new(cell)
      x         = x + 1
    end
    y = y + 1
  end
end

local function drawRow(row, l, r)
  for x = l,r do row[x].tile:draw() end
  for x = l,r do
    for item, _ in pairs(row[x].items) do
      item:draw()
    end
  end
end

function Map:draw(wl, wt, ww, wh)
  self:eachRow(drawRow, wl, wt, ww, wh)
end

function Map:los(x0,y0, x1,y1)
  return bresenham.los(x0,y0,x1,y1, function(x,y)
    return not self.cells[y][x].tile.opaque
  end)
end

return Map
