local Object = require 'src.objects.object'

local Block = Class{}
Block:include(Object)

function Block:init(world, x, y, w, h)
    self.isBlock = true
    Object.init(self, world, x, y, w, h)
end

-- function Block:filter(other)
--     return 'touch'
-- end

function Block:draw(alpha)
    love.graphics.setColor(0.3, 0.3, 0.3, alpha)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
    Object.draw(self)
end

function Block:drawOnMinimap(alpha)
    love.graphics.setColor(0.3, 0.3, 0.3, alpha)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return Block