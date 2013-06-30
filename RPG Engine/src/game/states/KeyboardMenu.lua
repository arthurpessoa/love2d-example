local Menu     = require 'lib.menu'
local Game     = require 'src.game.Game'
local MainMenu = require 'src.game.states.MainMenu'

local KeyboardMenu = Game:addState('KeyboardMenu', MainMenu)

local keyNames = {
  [' ']= 'space'
}

local function getKeyName(key)
  return keyNames[key] or key
end

function KeyboardMenu:enteredState()
  self:log('Entering KeyboardMenu')

  local menuOptions = {}

  local actions = { 'up', 'down', 'left', 'right', 'action' }

  for i=1,#actions do
    local action  = actions[i]
    local key     = self.config.keys[action]
    local keyName = getKeyName(key)
    menuOptions[#menuOptions + 1] = {
      ("%s (%s)"):format(action, keyName),
      function()
        self.modifiedAction = action
        self:gotoState("ChoosingKey")
      end
    }
  end
  menuOptions[#menuOptions + 1] = { 'Back', function() self:gotoState('OptionsMenu') end }

  self.menu = Menu:new(menuOptions)
end

function KeyboardMenu:escape()
  self:gotoState('OptionsMenu')
end

return KeyboardMenu
