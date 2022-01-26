local gamera = require 'lib.gamera'

local UI = Class{}

local PX_TO_ROW = 20
local ACTIVE_OBJECT_TEXT_COLOR = { 0, 0, 0, 1 }
local INACTIVE_OBJECT_TEXT_COLOR = { 0.5, 0.5, 0.5, 1 }

local minimapScale = 0.2
function UI:init(state)
    self.state = state

    self.minimap = gamera.new(0,0,state.width, state.height)
    self.minimap:setWindow(575, 25, 200, 200)
    self.minimap:setScale(minimapScale)

    self.UI = Urutora:new()
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

    -- OBJECT LIST
    local objList = state.objectList
    local x = love.graphics.getWidth() - 100
    local y = love.graphics.getHeight() - PX_TO_ROW*#objList
    local textColor
    for i, obj in ipairs(objList) do
        if state.selectedObject == i then
            textColor = ACTIVE_OBJECT_TEXT_COLOR
        else
            textColor = INACTIVE_OBJECT_TEXT_COLOR
        end
        love.graphics.setColor(textColor)
        love.graphics.print(obj.name, x, y, 0, 1.5)
        y = y + PX_TO_ROW
    end

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


function UI:keypressed(key, scancode, isrepeat) self.UI:keypressed(key, scancode, isrepeat) end
function UI:mousepressed(x, y, button) self.UI:pressed(x, y) end
function UI:mousemoved(x, y, dx, dy) self.UI:moved(x, y, dx, dy) end
function UI:mousereleased(x, y, button) self.UI:released(x, y) end
function UI:textinput(text) self.UI:textinput(text) end
function UI:wheelmoved(x, y) self.UI:wheelmoved(x, y) end

return UI