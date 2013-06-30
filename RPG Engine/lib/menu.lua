local beholder = require 'lib.beholder'

local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()


-- BUTTON (internal class)
local Button = class('Button')


-- settings for all buttons
local buttonWidth   = 200
local buttonHeight  =  50
local buttonSpacing =  20 -- vertical spacing


-- private methods
local function getBoundingBox(self)
  local x = screenWidth / 2 - width / 2
  local y = 200 + (self.position - 1) * (height + spacing)
end

local function getFontY(self)
  local font = love.graphics.getFont()
  if font then return self.y + (buttonHeight / 2) - (font:getHeight() / 2) end
  return 0
end

local function isInside(self, x, y)
  return self.x <= x and x <= self.x + buttonWidth and
         self.y <= y and y <= self.y + buttonHeight
end

-- public methods
function Button:initialize(label,x,y,callback)
  self.x = x
  self.y = y
  self.label = label
  self.callback = callback
  self:activate()
end

function Button:draw()
  love.graphics.rectangle('line', self.x, self.y, buttonWidth, buttonHeight)
  love.graphics.printf(self.label, self.x, getFontY(self), buttonWidth, 'center')
end

function Button:drawMarker()
  love.graphics.rectangle('line', self.x - 4, self.y -4, buttonWidth + 8, buttonHeight + 8)
end

function Button:action()
  self.callback()
end

function Button:activate()
  if self.active then return end
  beholder.group(self, function()
    beholder.observe('mousepressed', 'l', function(x,y)
      if isInside(self, x, y) then self:action() end
    end)
  end)
  self.active = true
end

function Button:deactivate()
  beholder.stopObserving(self)
  self.active = false
end

function Button:destroy()
  self:deactivate()
end


-- MENU
local Menu = class('Menu')

local function getMenuHeight(numberOfButtons)
  return numberOfButtons * buttonHeight + (numberOfButtons - 1) * buttonSpacing
end

local function getMenuY(numberOfButtons)
  return screenHeight/2 - getMenuHeight(numberOfButtons)/2
end

local function getMenuX()
  return screenWidth/2 - buttonWidth/2
end

-- private methods
local function parseButtonOptions(self, buttonOptions)
  local options, label, callback

  local menux, menuy = getMenuX(), getMenuY(#buttonOptions)
  local y

  for i=1, #buttonOptions do
    options = buttonOptions[i]
    label = options[1]
    callback = options[2]
    y = menuy + (i-1)*(buttonHeight + buttonSpacing)
    table.insert(self.buttons, Button:new(label,menux,y,callback))
  end
end

local function eachButton(self, methodName)
  local button
  for i=1, #self.buttons do
    button = self.buttons[i]
    button[methodName](button)
  end
end

local function limit(x, min, max)
  if x < min then return min end
  if x > max then return max end
  return x
end

local function moveSelected(self, increment)
  self.selected = limit( self.selected + increment, 1, #self.buttons)
end


-- public methods

function Menu:initialize(buttonOptions)
  self.buttons = {}
  parseButtonOptions(self, buttonOptions)
  self.selected = 1
  self:activate()
end

function Menu:draw()
  eachButton(self, 'draw')
  self.buttons[self.selected]:drawMarker()
end

function Menu:deactivate()
  eachButton(self, 'deactivate')
  beholder.stopObserving(self)
end

function Menu:activate()
  eachButton(self, 'activate')
  beholder.group(self, function()
    beholder.observe('keypressed', 'up',     function() moveSelected(self,-1) end)
    beholder.observe('keypressed', 'down',   function() moveSelected(self, 1) end)
    beholder.observe('keypressed', 'return', function() self.buttons[self.selected]:action() end)
  end)
end

function Menu:destroy()
  self:deactivate()
end

return Menu
