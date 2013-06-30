local Cell = class(..., nil)

local weakMt = {__mode = "k"}

function Cell:initialize(width, height, left, top)
  self.left, self.top, self.width, self.height = left, top, width, height
  self.right, self.bottom = left + width, top + height
  self.items = setmetatable({}, weakMt)
end

function Cell:getBoundingBox()
  return self.left, self.top, self.width, self.height
end

return Cell
