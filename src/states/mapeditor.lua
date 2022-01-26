local gamera = require 'lib.gamera'
local bump = require 'lib.bump'
local vector = require 'lib.vector'

local Objects = require 'src.objects'
local UI = require 'src.editorui'

local MapEditorState = {}

function MapEditorState:init()
    local width, height = 1000, 1000
    local world = bump.newWorld()
    local camera = gamera.new(0,0,1000,1000)

    self.camera = camera
    self.width, self.height = width, height

    self.world = world
    self.veiwpoint = vector(400, 300)

    self.UI = UI(self)
    self.objectList = Objects
    self.selectedObject = 1
end

function MapEditorState:enter()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function MapEditorState:update(dt)
    local veiwpoint = self.veiwpoint

    local dx, dy = 0, 0
    if love.keyboard.isDown('d') then
        dx = dx + 1
    end
    if love.keyboard.isDown('a') then
        dx = dx - 1
    end

    if love.keyboard.isDown('s') then
        dy = dy + 1
    end
    if love.keyboard.isDown('w') then
        dy = dy - 1
    end
    
    if dx ~= 0 then
        veiwpoint.x = veiwpoint.x + dx*50.0*dt
    end
    if dy ~= 0 then
        veiwpoint.y = veiwpoint.y + dy*50.0*dt
    end

    veiwpoint.x = math.clamp(veiwpoint.x, 400, self.width-400)
    veiwpoint.y = math.clamp(veiwpoint.y, 300, self.height-300)

    local _, _, cw, ch = self.camera:getWorld()
    if self.width ~= cw or self.height ~= ch then
        self.camera:setWorld(0, 0, self.width, self.height)
    end

    self.camera:setPosition(veiwpoint:unpack())
    self.UI:update(dt)
end

local tileWidth = 100
local tileHeight = 100
function MapEditorState:drawWorld(alpha)
    alpha = alpha or 1
    love.graphics.setColor(0.11, 0.57, 0.87, alpha)
    for i = 0, self.height-tileHeight, tileHeight*2 do
        for j = 0, self.width-tileWidth, tileWidth*2 do
            love.graphics.rectangle('fill', j, i, tileWidth, tileHeight)
        end
    end
    love.graphics.setColor(0.21, 0.70, 0.70, alpha)
    for i = tileHeight, self.height-tileHeight, tileHeight*2 do
        for j = tileWidth, self.width-tileWidth, tileWidth*2 do
            love.graphics.rectangle('fill', j, i, tileWidth, tileHeight)
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function MapEditorState:draw()
    self.camera:draw(function (x,y,w,h)
        self:drawWorld()
        local items, len = self.world:queryRect(x, y, w, h)
        table.sort(items, drawOrder)

        for _, item in ipairs(items) do
            item:draw()
        end
    end)

    self.UI:draw()
end

function MapEditorState:mousepressed( x, y, button, istouch, presses )
    local cx, cy = self.camera:toWorld(x, y)
    if button == 1 then
        print('btn clck')
        self.objectList[self.selectedObject].call(self.world, cx, cy, 100, 100)
    end
    self.UI:mousepressed(x, y, button, istouch, presses)
end

function MapEditorState:wheelmoved( x, y )
    if y > 0 then
        self.selectedObject = self.selectedObject - 1
        if self.selectedObject < 1 then
            self.selectedObject = #self.objectList
        end
    elseif y < 0 then
        self.selectedObject = self.selectedObject + 1
        if self.selectedObject > #self.objectList then
            self.selectedObject = 1
        end
    end
    self.UI:wheelmoved(x, y)
end

function MapEditorState:keypressed( key )
    if key == 'kp6' then
        self.width = self.width + 100
    elseif key == 'kp2' then
        self.height = self.height + 100
    elseif key == 'kp4' then
        self.width = self.width - 100
        if self.width < 800 then
            self.width = 800
        end
    elseif key == 'kp8' then
        self.height = self.height - 100
        if self.height < 600 then
            self.height = 600
        end
    -- elseif key == 'escape' then
    --     Gamestate.pop()
    end
    self.UI:keypressed(key)
end

return MapEditorState