local vector = require 'lib.vector'

local Tile = Class{}

local TILE_SIZE = 100

function Tile:init(color, x, y)
    self.color = color
    self.pos = vector(x, y)
end

function Tile:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y)
end

return Tile