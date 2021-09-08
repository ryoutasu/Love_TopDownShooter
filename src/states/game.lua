local gamera = require 'lib.gamera'
local bump = require 'lib.bump'

local Player = require 'src.objects.player'
local Block = require 'src.objects.block'
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
    local width, height = worldWidth,worldHeight
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

    self.UI = UI(self, self.player)
end

function GameState:enter()
    love.graphics.setBackgroundColor(0.2, 0.35, 0.6, 1)
end

function GameState:update(dt)
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
    self.UI:update(dt)
end

local tileWidth = 100
local tileHeight = 100
function GameState:drawWorld(alpha)
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

function GameState:draw()
    self.camera:draw(function (x,y,w,h)
        self:drawWorld()
        local items, len = self.world:queryRect(x, y, w, h)
        table.sort(items, self.drawOrder)

        for _, item in ipairs(items) do
            item:draw()
        end
    end)

    local player = self.player
    local weapon = player.weaponList[player.weapon]
    -- love.graphics.setColor(0, 0, 0, 1)
    -- love.graphics.print('Wep rot: '..weapon.r, 0, 0, 0, 1, 1)

    self.UI:draw()
end

function GameState:mousepressed( x, y, button, istouch, presses )
    local cx, cy = self.camera:toWorld(x, y)
    if button == 1 then
        self.player:startFire(true)
    end
end

function GameState:mousereleased( x, y, button, istouch, presses )
    local cx, cy = self.camera:toWorld(x, y)
    if button == 1 then
        self.player:startFire(false)
    end
end

function GameState:wheelmoved( x, y )
    if y > 0 then
        self.player:nextWeapon(false)
    elseif y < 0 then
        self.player:nextWeapon(true)
    end
end

function GameState:keypressed( key )
    local numkey = tonumber(key)
    if numkey and numkey >= 1 and numkey <= 9 then
        self.player:changeWeapon(numkey)
    elseif key == 'r' then
        self.player:reload()
    elseif key == 'tab' then
        self.UI.showMinimap = not self.UI.showMinimap
    -- elseif key == 'escape' then
    --     Gamestate.pop()
    end
end

return GameState