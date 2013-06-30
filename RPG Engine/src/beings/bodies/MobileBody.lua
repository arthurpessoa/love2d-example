local Body       = require('src.beings.bodies.Body')

local MobileBody = class(..., Body)

local deltasByDirection = {
  up   =  { 0, -1 },
  down =  { 0,  1 },
  left =  {-1,  0 },
  right = { 1,  0 }
}

local diagonalCoefficient = math.sin(1)

function MobileBody:initialize(map,x,y,width,height,speed)
  Body.initialize(self,map,x,y,width,height)
  self.speed = speed
  self.facing = "up"
end

function MobileBody:prepareMove(wishes)
  local dx, dy = 0,0
  for dir,delta in pairs(deltasByDirection) do
    if wishes[dir] then
      dx = dx + delta[1]
      dy = dy + delta[2]
      self.facing = dir
    end
  end
  self.vx, self.vy = self.speed * dx, self.speed * dy
  if dx ~= 0 and dy ~= 0 then
    self.vx, self.vy = self.vx * diagonalCoefficient, self.vy * diagonalCoefficient
  end
end

function MobileBody:getBoundingBox()
  return self.x - self.halfWidth,
         self.y - self.halfHeight,
         self.width,
         self.height
end

local function canPass(self,x,y)
  return self.map:getCell(x,y).tile:isPassableBy(self)
end

function MobileBody:move(dt)

  local vx, vy = self.vx, self.vy

  if vx == 0 and vy == 0 then return end

  local dx, dy = vx * dt, vy * dt
  local w2,h2 = self.halfWidth, self.halfHeight
  local cell = self.cell
  local x,y,w,h = self:getBoundingBox()

  if vx ~= 0 then -- moving left or right
    local futureX = x + dx + (vx > 0 and w or 0)
    if canPass(self, futureX, y) and canPass(self, futureX, y + h) then
      self.x = self.x + dx
    else
      self.x = vx > 0 and (cell.right - w2 - 1) or (cell.left + w2)
    end
  end

  if vy ~= 0 then -- moving up or down
    local futureY = y + dy + (vy > 0 and h or 0)
    if canPass(self, x, futureY) and canPass(self, x + w, futureY) then
      self.y = self.y + dy
    else
      cell = cell or self:getContainingCell()
      self.y = vy > 0 and (cell.bottom - h2 - 1) or (cell.top + h2)
    end
  end
  -- TODO: this might not work when impacting one diagonal precisely through its corner

  self.cell = self.map:update(self)
end

function MobileBody:isMoving()
  return self.vx ~= 0 or self.vy ~= 0
end


return MobileBody
