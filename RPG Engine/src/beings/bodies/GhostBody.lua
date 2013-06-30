local anim8  = require 'lib.anim8'

local media  = require 'src.media'
local PteroBody = require 'src.beings.bodies.PteroBody'

local GhostBody  = class(..., PteroBody)

local spriteW, spriteH = 32, 32

function GhostBody:loadAnimations()
  self.image  = media.images.ghost
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

function GhostBody:initialize(map,x,y,speed)
  PteroBody.initialize(self, map,x,y,speed)
  self.solid = false

  self:loadAnimations()
end

return GhostBody
