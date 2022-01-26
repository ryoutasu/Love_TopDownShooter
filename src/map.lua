local Map = Class{}

function Map:init(width, height)
    self.width = width
    self.height = height
    self.objects = {}
end

function Map:addObject(object)
    self.objects[#self.objects+1] = object
end

return Map