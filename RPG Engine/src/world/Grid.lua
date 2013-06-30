local floor = math.floor

local Cell = require 'src.world.Cell'

local Grid = class(..., nil)

function Grid:initialize(width, height, cellWidth, cellHeight)
  self.width, self.height          = width, height
  self.cellWidth, self.cellHeight  = cellWidth, cellHeight
  self.cellsByItem = setmetatable({}, {__mode = "k"})

  self.cells = {}

  for y = 1, height do
    self.cells[y] = {}
    for x = 1, width do
      self.cells[y][x] = Cell:new(cellWidth, cellHeight, self:toWorld(x,y))
    end
  end
end

local function padNumber(x,min,max)
  return x < min and min or (x > max and max or x)
end

function Grid:pad(gx,gy)
  return padNumber(gx, 1, self.width), padNumber(gy, 1, self.height)
end

function Grid:eachCell(f, wl, wt, ww, wh)
  local l, t, r, b = self:boxToGrid(wl, wt, ww, wh)

  for y = t, b do
    for x = l, r do
      f(self.cells[y][x])
    end
  end
end

function Grid:eachRow(f, wl, wt, ww, wh)
  local l, t, r, b = self:boxToGrid(wl, wt, ww, wh)

  for y = t, b do
    f(self.cells[y], l, r)
  end
end

function Grid:getCell(wx,wy)
  local gx,gy = self:toGrid(wx,wy)
  return self.cells[gy][gx]
end

function Grid:toWorld(gx,gy)
  return (gx-1) * self.cellWidth, (gy-1) * self.cellHeight
end

function Grid:toWorldCentered(gx,gy)
  return (gx-0.5) * self.cellWidth, (gy-0.5) * self.cellHeight
end

function Grid:toGrid(wx, wy)
  return floor(wx / self.cellWidth) + 1, floor(wy / self.cellHeight) + 1
end

function Grid:boxToGrid(wl, wt, ww, wh)
  if wl and wt and ww and wh then
    local l, t = self:pad(self:toGrid(wl, wt))
    local r, b = self:pad(self:toGrid(wl + ww, wt + wh))
    return l, t, r, b
  else
    return 1, 1, self.width, self.height
  end
end

function Grid:getBoundary()
  local w, h = self:toWorld(self.width + 1, self.height + 1)
  return 0, 0, w - 1, h - 1
end

function Grid:add(item)
  local cell = self:getCell(item.x, item.y)
  cell.items[item]       = true
  self.cellsByItem[item] = cell
  return cell
end

function Grid:remove(item)
  local cell = self:getCell(item.x, item.y)
  cell.items[item]       = nil
  self.cellsByItem[item] = nil
  return cell
end

function Grid:update(item)
  local cell = self.cellsByItem[item]
  local newCell = self:getCell(item.x, item.y)
  if cell ~= newCell then
    cell.items[item]       = nil
    newCell.items[item]    = true
    self.cellsByItem[item] = newCell
    return newCell
  end
  return cell
end

return Grid
