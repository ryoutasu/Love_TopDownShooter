Class = require 'lib.class'
Gamestate = require 'lib.gamestate'
Camera = require 'lib.gamera'
Urutora = require 'lib.urutora'
Input = require 'lib.input'

DEBUG = false

mainmenu = require 'src.states.mainmenu'
game = require 'src.states.game'
editor = require 'src.states.mapeditor'

function love.load()
    Input.bind_callbacks()
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