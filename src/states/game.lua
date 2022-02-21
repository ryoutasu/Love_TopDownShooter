local Map = require 'src.map'
local UI = require 'src.gameui'

local GameState = {}
local worldWidth = 1000
local worldHeight = 1000

function GameState.updateOrder(a, b)
    return a:getUpdateOrder() < b:getUpdateOrder()
end

function GameState.drawOrder(a, b)
    return a:getDrawOrder() > b:getDrawOrder()
end

function GameState:init()
    self.map = Map(worldWidth, worldHeight)
    self.UI = UI(self.map)
end

function GameState:enter()
    love.graphics.setBackgroundColor(0.2, 0.35, 0.6, 1)
end

function GameState:update(dt)
    self.map:update(dt)
    self.UI:update(dt)
end

function GameState:draw()
    self.map:draw()
    self.UI:draw()
end

function GameState:mousepressed( x, y, button, istouch, presses )
    self.map:mousepressed(x, y, button, istouch, presses)
    self.UI:mousepressed(x, y, button)
end

function GameState:mousereleased( x, y, button, istouch, presses )
    self.map:mousereleased(x, y, button, istouch, presses)
end

function GameState:wheelmoved( x, y )
    self.map:wheelmoved(x, y)
    self.UI:wheelmoved(x, y)
end

function GameState:keypressed( key )
    self.map:keypressed(key)
    self.UI:keypressed(key)
end

return GameState