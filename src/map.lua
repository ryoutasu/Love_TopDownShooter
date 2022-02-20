local gamera = require 'lib.gamera'
local bump = require 'lib.bump'

local Player = require 'src.objects.player'
local Block = require 'src.objects.block'

local Map = Class{}

function Map:init(width, height)
    self.width = width
    self.height = height
    self.objects = {}

    -- new
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

    --self.UI = UI(self, self.player)
end

function Map:addObject(object)
    self.objects[#self.objects+1] = object
end

function Map:update(dt)
    
end

return Map