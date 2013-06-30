local Menu     = require 'lib.menu'

local Game     = require 'src.game.Game'
local MainMenu = require 'src.game.states.MainMenu'

local OptionsMenu = Game:addState('OptionsMenu', MainMenu)

function OptionsMenu:enteredState()
  self:log('Entering OptionsMenu')

  self.menu = Menu:new({
    { 'Keyboard', function() self:gotoState('KeyboardMenu')   end },
    { 'Sound',    function() self:pushState('NotImplemented') end },
    { 'Back',     function() self:gotoState('MainMenu')       end },
  })
end

function OptionsMenu:escape()
  self:gotoState('MainMenu')
end

return OptionsMenu
