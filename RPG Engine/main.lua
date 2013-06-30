require 'lib.middleclass'
local cron     = require 'lib.cron'
local beholder = require 'lib.beholder'
require_tree   = require 'lib.require_tree'

-- game & gamestate requires
local Game = require 'src.game'

local game

function love.load()
  game = Game:new('z')
end

function love.draw()
  game:draw()
end

function love.update(dt)
  cron.update(dt)
  game:update(dt)
end

function love.keypressed(key, code)
  beholder.trigger('keypressed', key, code)
end

function love.keyreleased(key, code)
  beholder.trigger('keyreleased', key, code)
end

function love.mousepressed(x,y,button)
  beholder.trigger('mousepressed', button, x, y) -- warning: button goes first here!
end

function love.mousereleased(x,y,button)
  beholder.trigger('mousereleased', button, x, y) -- warning: button goes first here!
end
