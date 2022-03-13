require 'utils'
local gamera = require 'lib.gamera'
local bump = require 'lib.bump'
local vector = require 'lib.vector'

local UI = require 'src.editorui'

local objectListPath = 'resources/objectList.lua'

local MapEditor = {}

local mouseMoveMode = false
local insidenode = false
local widthText = nil
local heightText = nil

local fgColor = {0,0,0,1}


function MapEditor:init()
    local width, height = 1000, 1000
    local world = bump.newWorld()
    local camera = gamera.new(0,0,1000,1000)

    self.camera = camera
    self.width, self.height = width, height

    self.world = world
    self.viewpoint = vector(400, 300)

    self.UI = UI(self)
    self.urutora = Urutora:new()

    widthText = Urutora.text({
        text = tostring(width)
    }):setStyle({fgColor = fgColor})
    heightText = Urutora.text({
        text = tostring(height)
    }):setStyle({fgColor = fgColor})

    local panel = Urutora.panel({
        x = 110, y = 0,
        w = 150, h = 45,
        rows = 2, cols = 5,
        outline = true
    })
    :colspanAt(1, 1, 2):colspanAt(1, 4, 2)
    :colspanAt(2, 1, 2):colspanAt(2, 4, 2)
    :addAt(1, 1, Urutora.label({ text = 'Width'}):setStyle({fgColor = fgColor}))
    :addAt(1, 4, Urutora.label({ text = 'Height'}):setStyle({fgColor = fgColor}))
    :addAt(2, 1, widthText)
    :addAt(2, 3, Urutora.button({
        text = 'X'
    }):action(function()
        self:resize(tonumber(widthText.text), tonumber(heightText.text))
    end))
    :addAt(2, 4, heightText)
    :setStyle({outlineColor = fgColor})

    self.urutora:add(panel)
end

function MapEditor:resize(width, height)
    if type(width) ~= 'number' or type(height) ~= 'number' then return end
    if width < 100 then width = 100 end
    if height < 100 then height = 100 end
    self.width = width
    self.height = height
    widthText.text = tostring(width)
    heightText.text = tostring(height)
end

function MapEditor:deselect()
    if self.selected then
        self.selected:enable()
        self.selected = nil
    end
end

function MapEditor:loadObjectList()
    if self.panel then
        self.urutora:remove(self.panel)
        self.urutora:remove(self.slider)
        self.urutora:remove(self.refreshBtn)
        self.urutora:remove(self.deselectBtn)
    end
    local list = love.filesystem.load(objectListPath)()

    local w = list.w/2-5
    local refresh = Urutora.button({
        text = 'Refresh',
        x = list.x, y = list.y,
        w = w, h = 40
    }):action(function()
        MapEditor:loadObjectList()
    end)
    local deselect = Urutora.button({
        text = 'Deselect',
        x = list.x+w+10, y = list.y,
        w = w, h = 40
    }):action(function()
        self:deselect()
    end)

    local x = list.x
    local y = list.y+50
    local panel = Urutora.panel({
        x = x, y = y,
        w = list.w, h = list.h,
        rows = list.rows, cols = 1, csy = list.csy
    })
    
    local i = 1
    for key, value in ipairs(list) do
        local result, errmsg = love.filesystem.load(value.path)
        if errmsg then
            print('The following error happened: ' .. tostring(result))
        else
            local item = Urutora.button({
                text = value.name,
                w = 200, h = 30
            })
            
            item.call = result()
            item:action(function(e)
                if self.selected then
                    self.selected:enable()
                end
                item:disable()
                self.selected = item
            end)
            panel:addAt(i, 1, item)
            i = i + 1
        end
    end

    x = x + list.w + 10
    local slider = Urutora.slider({
        x = x, y = y,
        w = 20, h = list.h,
        value = 0, axis = 'y'
    }):action(function(e)
        panel:setScrollY(e.target.value)
    end)

    self.urutora:add(refresh)
    self.urutora:add(deselect)
    self.urutora:add(panel)
    self.urutora:add(slider)

    self.refreshBtn = refresh
    self.deselectBtn = deselect
    self.panel = panel
    self.slider = slider
    self.selected = nil
    self.mouseOver = nil
end

function MapEditor:save()
    local m = {
        width = self.width,
        height = self.height,
        objects = {}
    }
    local items, len = self.world:getItems()
    for key, object in ipairs(items) do
        local x, y = object.pos:unpack()
        local o = { x = x, y = y }
        table.insert(m.objects, o)
    end
end

function MapEditor:enter()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    self:loadObjectList()
end

function MapEditor:update(dt)
    local mx, my = love.mouse.getPosition()
    local viewpoint = self.viewpoint

    -- resize the world
    local _, _, cw, ch = self.camera:getWorld()
    if self.width ~= cw or self.height ~= ch then
        self.camera:setWorld(0, 0, self.width, self.height)
    end

    insidenode = false
    for index, node in ipairs(self.urutora.nodes) do
        if node:pointInsideNode(mx, my) then
            insidenode = true
        end
    end
    
    for _, item in ipairs(items) do

    end

    self.camera:setPosition(viewpoint:unpack())
    self.UI:update(dt)
    self.urutora:update(dt)
end

local tileWidth = 50
local tileHeight = 50
function MapEditor:drawWorld(alpha)
    alpha = alpha or 1
    love.graphics.setColor(0.11, 0.57, 0.87, alpha)
    for i = 0, self.height-tileHeight, tileHeight*2 do
        for j = 0, self.width-tileWidth, tileWidth*2 do
            love.graphics.rectangle('fill', j, i, tileWidth, tileHeight)
        end
    end
    love.graphics.setColor(0.21, 0.70, 0.70, alpha)
    for i = tileHeight, self.height-tileHeight, tileHeight*2 do
        for j = tileWidth, self.width-tileWidth, tileWidth*2 do
            love.graphics.rectangle('fill', j, i, tileWidth, tileHeight)
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function MapEditor:draw()
    local mx, my = love.mouse.getPosition()
    local cx, cy = self.camera:toWorld(mx, my)

    self.camera:draw(function (x,y,w,h)
        self:drawWorld()
        local items, len = self.world:queryRect(x, y, w, h)
        table.sort(items, drawOrder)

        local alreadyMouseOver = false -- check if no other object under cursor
        for _, item in ipairs(items) do
            item:draw()
            if not insidenode then
                if not alreadyMouseOver
                and isPointInside(cx, cy, item.pos.x, item.pos.y, item.w, item.h) then
                    alreadyMouseOver = true
                    love.graphics.setColor(0, 0, 1, 1)
                    love.graphics.rectangle('line', item.pos.x, item.pos.y, item.w, item.h)
                end
            end
        end
    end)

    self.UI:draw()
    self.urutora:draw()
end

function MapEditor:mousepressed( x, y, button, istouch, presses )
    local cx, cy = self.camera:toWorld(x, y)
    if button == 1 then
        if self.selected and not insidenode then
            self.selected.call(self.world, cx, cy, 100, 100)
        end

        -- if not self.selected and  then
            
        -- end
    end

    if button == 3 then
        mouseMoveMode = true
    end
    self.urutora:pressed(x, y, button, istouch, presses)
end

function MapEditor:mousereleased(x, y, button)
    if button == 3 then
        mouseMoveMode = false
    end
    self.urutora:released(x, y)
end

function MapEditor:mousemoved(x, y, dx, dy)
    if mouseMoveMode then
        local viewpoint = self.viewpoint+vector(-dx, -dy)

        viewpoint.x = math.clamp(viewpoint.x, 400, self.width-400)
        viewpoint.y = math.clamp(viewpoint.y, 300, self.height-300)

        self.viewpoint = viewpoint
        self.camera:setPosition(viewpoint:unpack())
    end

    self.urutora:moved(x, y, dx, dy)
end

function MapEditor:wheelmoved(x, y) self.urutora:wheelmoved(x, y) end

function MapEditor:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        self:deselect()
        -- Gamestate.pop()
    end
    self.urutora:keypressed(key, scancode, isrepeat)
end

function MapEditor:textinput(text) self.urutora:textinput(text) end

return MapEditor