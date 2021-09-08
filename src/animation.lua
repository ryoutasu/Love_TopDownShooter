local Animation = Class{}

---@param spritesheet table
---@param width number frame width
---@param height number frame width
function Animation:init(spritesheet, frames, x, y, width, height)
    self.frames = {}
    self.speed = 0.5
    self.time = 0
    self.currentFrame = 1

    self.spritesheet = spritesheet
    self.w = width
    self.h = height

    for i = 1, frames do
        self.frames[#self.frames+1] = love.graphics.newQuad(x, y, width, height, spritesheet.w, spritesheet.h)

        x = x + width
    end
end

function Animation:update(dt)
    if self.speed > 0 then
        self.time = self.time + dt
        if self.time > self.speed then
            self.time = self.time - self.speed
            if self.currentFrame >= #self.frames then
                self.currentFrame = 1
            else
                self.currentFrame = self.currentFrame + 1
            end
        end
    end
end

function Animation:draw(x, y, r, sx, sy, ox, oy, ...)
    self.spritesheet.flippedH = self.flippedH or false
    self.spritesheet.flippedV = self.flippedV or false
    local frame = self.frames[self.currentFrame]
    self.spritesheet:draw(frame, x, y, r, sx, sy, ox, oy, ...)
end

return Animation