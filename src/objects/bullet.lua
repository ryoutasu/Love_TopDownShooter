local vector = require 'lib.vector'
local MoveableObject = require 'src.objects.moveableObject'

local size = 5
local maxRange = 500

local Bullet = Class{}
Bullet:include(MoveableObject)

function Bullet:init(world, owner, x, y, r, damage)
    self.isBullet = true
    self.drawOrder = 1
    MoveableObject.init(self, world, x, y, size, size)
    self.owner = owner
    self.start = vector(x, y)
    self.r = r

    self.speed = 500
    self.direction = vector(1, 0):rotated(r)
    self.acceleration = 1
    self.friction = 0

    self.damage = damage or 0
end

function Bullet:filter(other)
    if other.isPlayer then
        return 'cross'
    elseif other.isBlock then
        return 'touch'
    end
end

function Bullet:onCollision(cols, len)
    for i = 1, len do
        local col = cols[i]
        if col.other.isBlock then
            self.toDestroy = true
        end
    end
end

function Bullet:update(dt)
    MoveableObject.update(self, dt)

    if (self.start - self.pos):len() >= maxRange then
        self.toDestroy = true
        return
    end
end

function Bullet:draw()
    local cx, cy = self:getCenter():unpack()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('fill', cx, cy, size/2)
    love.graphics.setColor(1, 1, 1, 1)
end

function Bullet:drawOnMinimap(alpha)
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return Bullet