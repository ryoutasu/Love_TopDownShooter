local gamera = require 'lib.gamera'

local minimapScale = 0.2

local UI = Class{}

function UI:init(state)
    self.state = state

    self.minimap = gamera.new(0,0,state.width, state.height)
    self.minimap:setWindow(575, 25, 200, 200)
    self.minimap:setScale(minimapScale)
end

function UI:update(dt)
    local state = self.state
    local _, _, cw, ch = self.minimap:getWorld()
    if state.width ~= cw or state.height ~= ch then
        self.minimap:setWorld(0, 0, state.width, state.height)
    end

    self.minimap:setPosition(state.veiwpoint:unpack())
end

function UI:draw()
    local state = self.state
    
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('Map editor state', 0, 0)
    love.graphics.print('Width = '..self.state.width, 0, 15)
    love.graphics.print('Height = '..self.state.height, 0, 30)

    local l,r,t,d = state.camera:getVisible()

    self.minimap:draw(function (x,y,w,h)
        love.graphics.setColor(0.5,0.5,0.5,0.8)
        love.graphics.rectangle('fill',x,y,w,h)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('line',l,r,t,d)

        local items, len = state.world:queryRect(x, y, w, h)
        table.sort(items, state.drawOrder)

        for _, item in ipairs(items) do
            item:drawOnMinimap(0.8)
        end
    end)
end

return UI