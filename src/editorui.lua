local gamera = require 'lib.gamera'

local UI = Class{}

local minimapScale = 0.2
function UI:init(state)
    self.state = state

    local windowW, windowH = love.graphics.getWidth(), love.graphics.getHeight()
    local w, h = 200, 200
    self.minimap = gamera.new(0,0,state.width, state.height)
    self.minimap:setWindow(windowW - w - 25, 25, w, h)
    self.minimap:setScale(minimapScale)

    -- self.UI = Urutora:new()
end

function UI:update(dt)
    local state = self.state
    local _, _, cw, ch = self.minimap:getWorld()
    if state.width ~= cw or state.height ~= ch then
        self.minimap:setWorld(0, 0, state.width, state.height)
    end

    self.minimap:setPosition(state.viewpoint:unpack())
end

function UI:draw()
    local state = self.state
    
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('Map editor state', 0, 0)
    love.graphics.print('Width = '..self.state.width, 0, 15)
    love.graphics.print('Height = '..self.state.height, 0, 30)

    -- MINIMAP
    local l,r,t,d = state.camera:getVisible()
    self.minimap:draw(function (x,y,w,h)
        love.graphics.setColor(0.5,0.5,0.5,0.8)
        love.graphics.rectangle('fill',x,y,w,h)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('line',l,r,t,d)

        local items, len = state.world:queryRect(x, y, w, h)
        table.sort(items, drawOrder)

        for _, item in ipairs(items) do
            item:drawOnMinimap(0.8)
        end
    end)
end


-- function UI:keypressed(key, scancode, isrepeat) self.UI:keypressed(key, scancode, isrepeat) end
-- function UI:mousepressed(x, y, button) self.UI:pressed(x, y) end
-- function UI:mousereleased(x, y, button) self.UI:released(x, y) end
-- function UI:mousemoved(x, y, dx, dy) self.UI:moved(x, y, dx, dy) end
-- function UI:textinput(text) self.UI:textinput(text) end
-- function UI:wheelmoved(x, y) self.UI:wheelmoved(x, y) end

return UI