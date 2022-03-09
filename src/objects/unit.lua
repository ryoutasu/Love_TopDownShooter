local MoveableObject = require 'src.objects.moveableObject'

local Unit = Class{}
Unit:include(MoveableObject)

function Unit:init(world, x, y, w, h)
    self.isUnit = true
    MoveableObject.init(self, world, x, y, w, h)

    self.facing = 'r'
    self.helath = self.health or 100
    self.maxHealth = self.health
end

function Unit:takeDamage(damage)
    self.health = math.max(self.health - damage, 0)
end

function Unit:update(dt)
    MoveableObject.update(self, dt)
    
    if self.animation then
        self.animation:update(dt)
    end
end

function Unit:draw()
    if self.animation then
        local pos = self.pos
        local r, sx, sy, ox, oy = self.r or 0, self.sx or 1, self.sy or 1, self.ox or 0, self.oy or 0
        self.animation.flippedH = self.facing == 'l' or false
        self.animation:draw(pos.x, pos.y, r, sx, sy, ox, oy)
    end
    MoveableObject.draw(self)
end

return Unit