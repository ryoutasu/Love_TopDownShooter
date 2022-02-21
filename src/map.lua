local gamera = require 'lib.gamera'
local bump = require 'lib.bump'

local Player = require 'src.objects.player'
local Block = require 'src.objects.block'

local Map = Class{}

function Map.updateOrder(a, b)
    return a:getUpdateOrder() < b:getUpdateOrder()
end

function Map.drawOrder(a, b)
    return a:getDrawOrder() > b:getDrawOrder()
end

function Map:init(width, height)
    self.width = width
    self.height = height
    self.objects = {}

    -- new
    local world = bump.newWorld()
    local camera = gamera.new(0,0,width,height)

    self.player = Player(world, 200, 200, camera)

    Block(world, 0, 0, width, 10)
    Block(world, 0, 0, 10, height)
    Block(world, 0, height-10, width, 10)
    Block(world, width-10, 0, 10, height)

    self.world = world
    self.camera = camera
    self.width, self.height = width, height
end

function Map:addObject(object)
    self.objects[#self.objects+1] = object
end

function Map:update(dt)
    local items, len = self.world:getItems()

    table.sort(items, self.updateOrder)

    for _, item in ipairs(items) do
        item:update(dt)
    end

    for _, item in ipairs(items) do
        if item.toDestroy then
            -- self.world:remove(item)
            item:destroy()
        end
    end
    self.camera:setPosition(self.player:getCenter():unpack())
end

local tileWidth = 100
local tileHeight = 100
local function drawWorld(map, alpha)
    alpha = alpha or 1
    love.graphics.setColor(0.11, 0.57, 0.87, alpha)
    for i = 0, map.height-tileHeight, tileHeight*2 do
        for j = 0, map.width-tileWidth, tileWidth*2 do
            love.graphics.rectangle('fill', j, i, tileWidth, tileHeight)
        end
    end
    love.graphics.setColor(0.21, 0.70, 0.70, alpha)
    for i = tileHeight, map.height-tileHeight, tileHeight*2 do
        for j = tileWidth, map.width-tileWidth, tileWidth*2 do
            love.graphics.rectangle('fill', j, i, tileWidth, tileHeight)
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function Map:draw()
    self.camera:draw(function (x,y,w,h)
        drawWorld(self)
        local items, len = self.world:queryRect(x, y, w, h)
        table.sort(items, self.drawOrder)

        for _, item in ipairs(items) do
            item:draw()
        end
    end)

    -- local player = self.player
    -- local weapon = player.weaponList[player.weapon]
    -- love.graphics.setColor(0, 0, 0, 1)
    -- love.graphics.print('Wep rot: '..weapon.r, 0, 0, 0, 1, 1)
end

function Map:mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        self.player:startFire(true)
    end
end

function Map:mousereleased( x, y, button, istouch, presses )
    if button == 1 then
        self.player:startFire(false)
    end
end

function Map:wheelmoved( x, y )
    if y > 0 then
        self.player:nextWeapon(false)
    elseif y < 0 then
        self.player:nextWeapon(true)
    end
end

function Map:keypressed( key )
    local numkey = tonumber(key)
    if numkey and numkey >= 1 and numkey <= 9 then
        self.player:changeWeapon(numkey)
    elseif key == 'r' then
        self.player:reload()
    elseif key == 'tab' then
        self.UI.showMinimap = not self.UI.showMinimap
    elseif key == 'escape' then
        Gamestate.switch(mainmenu)
    end
end

return Map