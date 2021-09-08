require 'utils'
local vector = require 'lib.vector'
local Object = require 'src.objects.object'

local MoveableObject = Class{}
MoveableObject:include(Object)

function MoveableObject:init(world, x, y, w, h)
    Object.init(self, world, x, y, w, h)

    self.speed = self.speed or 50
    self.acceleration = self.acceleration or 0.5
    self.friction = self.friction or 0.5
    self.vel = self.vel or vector()
    self.direction = self.direction or vector()
end

function MoveableObject:changeVelocityByCollisionNormal(nx, ny)
    local vx, vy = self.vel:unpack()

    if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
        vx = 0
    end

    if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
        vy = 0
    end

    self.vel = vector(vx, vy)
end

function MoveableObject:update(dt)
    local pos = self.pos
    local vel = self.vel
    local speed = self.speed
    local acceleration = self.acceleration
    local friction = self.friction
    local direction = self.direction

    if direction.x ~= 0 then
        vel.x = math.lerp(vel.x, direction.x * speed, acceleration)
    else
        vel.x = math.lerp(vel.x, direction.x * speed, friction)
    end
    if direction.y ~= 0 then
        vel.y = math.lerp(vel.y, direction.y * speed, acceleration)
    else
        vel.y = math.lerp(vel.y, direction.y * speed, friction)
    end

    local cols, len
    pos.x, pos.y, cols, len = self.world:move(self, pos.x + vel.x * dt, pos.y + vel.y * dt, self.filter)

    for _, col in ipairs(cols) do
        if col.type ~= 'cross' then
            self:changeVelocityByCollisionNormal(col.normal.x, col.normal.y)
        end
    end

    if self.onCollision then
        self:onCollision(cols, len)
    end
end

function MoveableObject:draw()
    Object.draw(self)
end

return MoveableObject