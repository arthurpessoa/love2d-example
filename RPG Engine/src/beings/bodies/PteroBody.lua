local anim8  = require 'lib.anim8'

local media  = require 'src.media'
local MobileBody = require 'src.beings.bodies.MobileBody'

local PteroBody  = class('Ptero', MobileBody)

local spriteW, spriteH = 32, 32

function PteroBody:loadAnimations()
  self.image  = media.images.ptero
  local g = anim8.newGrid(spriteW, spriteH, self.image:getWidth(), self.image:getHeight())
  self.animations = {
    fly = {
      up    = anim8.newAnimation('loop', g('1-4,1'), 0.1),
      right = anim8.newAnimation('loop', g('1-4,2'), 0.1),
      down  = anim8.newAnimation('loop', g('1-4,3'), 0.1),
      left  = anim8.newAnimation('loop', g('1-4,4'), 0.1)
    }
  }
end

function PteroBody:initialize(map,x,y,speed)
  MobileBody.initialize(self, map,x,y,12,6,speed)
  self.walker = false

  self:loadAnimations()
end

function PteroBody:draw()
  local x, y = math.floor(self.x), math.floor(self.y)
  self:getCurrentAnimation():draw(self.image, x-spriteW/2, y-26)
end

function PteroBody:getCurrentAnimation()
  return self.animations.fly[self.facing]
end

function PteroBody:update(wishes, dt)
  MobileBody.update(self, wishes, dt)

  local prevFacing = self.facing

  self:prepareMove(wishes)

  local anim = self:getCurrentAnimation()
  if prevFacing == self.facing then
    anim:update(dt)
  else
    anim:gotoFrame(1)
  end

  self:move(dt)
end

return PteroBody
