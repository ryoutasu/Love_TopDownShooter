Class = require 'lib.class'
Gamestate = require 'lib.gamestate'
Camera = require 'lib.gamera'

DEBUG = false

local mainmenu = require 'src.states.mainmenu'

function love.load()
    love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    love.window.setTitle('Love Shooter')
    math.randomseed(os.time())

    Gamestate.registerEvents()
    Gamestate.switch(mainmenu)
end

function love.update(dt)
    
end

function love.draw()
    
end

function love.keypressed(key)
    if key == 'f1' then
        DEBUG = not DEBUG
    end
end