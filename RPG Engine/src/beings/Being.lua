local Each     = require 'lib.each'
local beholder = require 'lib.beholder'

local Being = class('Entity'):include(Each)

function Being.static:drawAll()
  self:each('draw')
end

function Being.static:updateAll(dt)
  self:safeEach('update', dt)
end

function Being.static:destroyAll()
  self:safeEach('destroy')
end

--------------------------------------

function Being:initialize(mind, body)
  self.mind = mind
  self.body = body
  self.class:add(self)
end

function Being:destroy()
  self.class:remove(self)
  self.body:destroy()
  self.mind:destroy()
end

function Being:draw()
  self.body:draw()
end

function Being:update(dt)
  self.body:update(self.mind.wishes, dt)
  self.mind:update(self.body.senses, dt)
end

return Being
