local vector = require 'lib.vector'
local weapons = require 'data.weapons'
local Sprite = require 'src.sprite'
local Object = require 'src.objects.object'
local Bullet = require 'src.objects.bullet'

local Weapon = Class{}
Weapon:include(Object)

function Weapon:init(player, name, camera)
    self.player = player
    self.camera = camera

    local wep = weapons[name]
    assert(wep, 'No weapon '..name)
    self.name = name
    self:include(wep)
    self.sprite = self.imagePath and Sprite(self.imagePath) or nil

    -- self.pos = player.pos + player.hand_point
    self.pos = player:getCenter()
    self.w = self.sprite.w
    self.h = self.sprite.h
    -- self.ox = self.holding_point.x
    -- self.oy = self.holding_point.y
    self.ox = -5
    self.oy = self.h/2
    self.r = 0
    self.isFiring = false

    self.cooldownTime = 0
    self.reloadTime = 0
    self.bulletsInClip = self.clipSize
    self.totalAmmo = 100
end

function Weapon:getShootingPoint()
    local offset = vector(self.ox, self.oy)
    local point = (self.muzzle_offset - offset)*self.scale
    if self.flippedV then
        point.y = -(self.muzzle_offset.y - offset.y)*self.scale
    end
    return self.pos + point:rotated(self.r), self.r
end

function Weapon:reload()
    if self.reloadTime == 0 and self.bulletsInClip < self.clipSize and self.totalAmmo > 0 then
        self.reloadTime = self.timeToReload
    end
end

function Weapon:createBullet()
    local p, r  = self:getShootingPoint()
    local spread = self.spread
    local rand = math.random(-spread, spread)
    r = r + math.rad(rand)
    Bullet(self.player.world, self.player, p.x, p.y, r, self.damage)
end

function Weapon:fire()
    if self.bulletsInClip > 0 then
        if self.cooldownTime == 0 and self.reloadTime == 0 then
            if self.onFire then
                self:onFire()
            else
                self:createBullet()
            end
            
            self.cooldownTime = self.timeToCooldown
            self.bulletsInClip = self.bulletsInClip - 1

            if self.bulletsInClip == 0 then
                self:reload()
            end
        end
    else
        self:reload()
    end
end

function Weapon:updateTiming(dt)
    if self.cooldownTime > 0 then
        self.cooldownTime = math.max(0, self.cooldownTime - dt)
    end
    if self.reloadTime > 0 then
        self.reloadTime = math.max(0, self.reloadTime - dt)
        if self.reloadTime == 0 then
            local amount = math.min(self.totalAmmo, self.clipSize - self.bulletsInClip)
            self.bulletsInClip = self.bulletsInClip + amount
            self.totalAmmo = self.totalAmmo - amount
        end
    end
end

function Weapon:updateFiring(dt)
    if self.isFiring then
        self:fire()
        if self.type ~= 'automatic' then
            self.isFiring = false
        end
    end
end

function Weapon:update(dt)
    local player = self.player
    
    -- WEAPON POSITION
    -- self.pos = player.pos + player.hand_point
    self.pos = player:getCenter()
    if player.facing == 'r' then
        -- self.oy = self.holding_point.y
        self.flippedV = false
    else
        -- self.oy = self.h - self.holding_point.y
        self.flippedV = true
    end

    -- WEAPON ROTATION
    local mx, my = self.camera:toWorld(love.mouse.getX(), love.mouse.getY())
    local dx, dy = mx - self.pos.x, my - self.pos.y
    self.r = math.atan2(dy, dx)

    self:updateTiming(dt)
    self:updateFiring(dt)
end

function Weapon:draw(alpha)
    if self.sprite then
        local pos, r, sx, sy, ox, oy = self.pos, self.r or 0, self.scale, self.scale, self.ox, self.oy
        self.sprite.flippedV = self.flippedV
        love.graphics.setColor(1, 1, 1, alpha)
        self.sprite:draw(nil, pos.x, pos.y, r, sx, sy, ox, oy)
    end

    if DEBUG then
        local pos = self:getShootingPoint()
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle('fill', pos.x, pos.y, 2)
    end
end

function Weapon:setPosition(pos)
    self.pos = self.player:getCenter()
end

return Weapon