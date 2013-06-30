local Each = require 'lib.each'

local Body = class(..., nil):include(Each)

function Body:initialize(map, mx, my, width, height)
  self.senses = {}
  self.x, self.y = map:toWorldCentered(mx, my)

  self.width = width
  self.height = height
  self.halfWidth = width/2
  self.halfHeight = height/2

  self.solid  = true
  self.walker = true

  self.map = map
  self.cell = self.map:add(self)
  self.class:add(self)
end

function Body:destroy()
  self.class:remove(self)
  self.map:remove(self)
end

function Body:getPosition()
  return self.x, self.y
end

function Body:update(wishes, dt)
  self:sense()
end

function Body:sense()
  self.senses.x = self.x
  self.senses.y = self.y
  self.senses.sight = {}
  Body:each('getPerceivedBy', self)
end

function Body:getPerceivedBy(perceiver)
  local x0,y0 = self.map:toGrid(perceiver.x, perceiver.y)
  local x1,y1 = self.map:toGrid(self.x, self.y)

  if self.map:los(x0,y0,x1,y1) then
    perceiver.senses.sight[self] = {x=self.x, y=self.y}
  end
end


return Body
