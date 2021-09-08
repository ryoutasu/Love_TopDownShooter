local game = require 'src.states.game'
local editor = require 'src.states.mapeditor'

local MainMenuState = {}

function MainMenuState:init()
    
end

function MainMenuState:enter()
    love.graphics.setBackgroundColor(0.6, 0.6, 0.6, 1)
end

function MainMenuState:update(dt)
    
end

function MainMenuState:draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('THE GAME ABOUT GUNS', 100, 100, 0, 2)
    love.graphics.print('Press space to start game', 100, 200, 0, 1.5)
    love.graphics.print('Press backspace to start map editor', 100, 300, 0, 1.5)
end

function MainMenuState:keypressed(key)
    if key == 'space' then
        Gamestate.switch(game)
    elseif key == 'backspace' then
        Gamestate.switch(editor)
    end
end

return MainMenuState