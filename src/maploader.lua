local Map = require 'src.map'
local Loader = Class{}

function Loader:init()
    
end

function Loader:loadMap(path)
    local m = require 'resources.maps.maptemplate'
    local objects = {}
    local width, height = m.width, m.height
    local map = Map(width, height)

    return map
end

return Loader