local gamera = require 'lib.gamera'

local UI = Class{}

local PX_TO_ROW = 35

local ACTIVE_WEAPON_TEXT_COLOR = { 0, 0, 0, 1 }
local INACTIVE_WEAPON_TEXT_COLOR = { 0.5, 0.5, 0.5, 1 }
local ACTIVE_WEAPON_ICON_COLOR = { 1, 1, 1, 1 }
local INACTIVE_WEAPON_ICON_COLOR = { 0.7, 0.7, 0.7, 0.7 }

local minimapScale = 0.2

function UI:init(gamestate, player)
    self.gamestate = gamestate
    self.player = player

    local minimap = gamera.new(0,0,gamestate.width,gamestate.height)
    minimap:setWindow(575, 25, 200, 200)
    minimap:setScale(minimapScale)

    self.minimap = minimap
    self.showMinimap = true
end

function UI:update(dt)
    self.minimap:setPosition(self.player:getCenter():unpack())
end

function UI:draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('Game state', 0, 0)

    local game = self.gamestate
    local player = self.player
    -- local health, maxHealth
    local weapons = player.weaponList
    
    -- WEAPON LIST
    local x = love.graphics.getWidth() - 100
    local y = love.graphics.getHeight() - PX_TO_ROW*#weapons
    local textColor
    local iconColor
    for i, w in ipairs(weapons) do
        if player.weaponList[player.weapon] == w then
            textColor = ACTIVE_WEAPON_TEXT_COLOR
            iconColor = ACTIVE_WEAPON_ICON_COLOR
        else
            textColor = INACTIVE_WEAPON_TEXT_COLOR
            iconColor = INACTIVE_WEAPON_ICON_COLOR
        end
        local xx, yy = x,y
        love.graphics.setColor(textColor)
        love.graphics.print(w.name, xx, yy)
        yy = yy + 15
        w.sprite.flippedV = false
        love.graphics.setColor(iconColor)
        w.sprite:draw(nil, xx, yy)
        xx = xx + w.sprite.w + 5
        love.graphics.setColor(textColor)
        love.graphics.print(w.bulletsInClip..' / '..w.totalAmmo, xx, yy-2)
        y = y + PX_TO_ROW
    end

    -- MINIMAP
    local l,r,t,d = game.camera:getVisible()
    if self.showMinimap then
        self.minimap:draw(function (x,y,w,h)
            love.graphics.setColor(0.5,0.5,0.5,0.8)
            love.graphics.rectangle('fill',x,y,w,h)
                
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle('line',l,r,t,d)

            -- game.drawWorld(0.8)
            local items, len = game.world:queryRect(x, y, w, h)
            table.sort(items, game.drawOrder)

            for _, item in ipairs(items) do
                item:drawOnMinimap(0.8)
            end
        end)
    end
end

return UI