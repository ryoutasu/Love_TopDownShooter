local vector = require 'lib.vector'
local Object = Class{}

function Object:init(world, x, y, w, h)
    world:add(self, x, y, w, h)
    self.world = world
    self.pos = vector(x, y)
    self.w, self.h = w, h
end

function Object:update(dt)
    
end

function Object:draw()
    if DEBUG then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h)
    end
end

function Object:drawOnMinimap(alpha)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

function Object:getCenter()
    return vector(self.pos.x + self.w / 2, self.pos.y + self.h / 2)
end

function Object:getUpdateOrder()
    return self.updateOrder or 10000
end

function Object:getDrawOrder()
    return self.drawOrder or 10000
end

function Object:destroy()
    if self.onDetroy then
        self:onDestroy()
    end
    self.world:remove(self)
    -- self.toDestroy = true
end

return Object