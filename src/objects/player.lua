local vector = require 'lib.vector'
local Unit = require 'src.objects.unit'
local Animation = require 'src.animation'
local Sprite = require 'src.sprite'
local Weapon = require 'src.objects.weapon'

local hand_point = vector(53, 46)

local Player = Class{}
Player:include(Unit)

function Player:init(world, x, y, camera)
    self.isUnit = true
    self.drawOrder = 2
    Unit.init(self, world, x, y, 60, 70)
    self.camera = camera
    self.animation = Animation(Sprite('resources/character.png'), 1, 0, 0, 60, 70)

    self.hand_point = hand_point:clone()
    -- self.weaponNum = 1
    self.weaponList = {
        [1] = Weapon(self, 'PISTOL', camera),
        [2] = Weapon(self, 'AR', camera),
        [3] = Weapon(self, 'MAG', camera),
        [4] = Weapon(self, 'SHOTGUN', camera),
    }
    self.weapon = 1
end

function Player:filter(other)
    if other.isBullet then
        return 'cross'
    elseif other.isBlock then
        return 'slide'
    end
end

function Player:startFire(start)
    self.weaponList[self.weapon].isFiring = start
end

function Player:reload()
    self.weaponList[self.weapon]:reload()
end


function Player:changeWeapon(w)
    local weapon = self.weaponList[self.weapon]

    if self.weaponList[w] and self.weapon ~= w then
        weapon.reloadTime = 0
        weapon.isFiring = false
        self.weapon = w
    end
end

function Player:nextWeapon(next)
    local w = self.weapon
    if next then
        if w+1 > #self.weaponList then
            self:changeWeapon(1)
        else
            self:changeWeapon(w+1)
        end
    else
        if w-1 < 1 then
            self:changeWeapon(#self.weaponList)
        else
            self:changeWeapon(w-1)
        end
    end
end

function Player:updateVelocityByInput(dt)
    local dv = vector()
    
    if love.keyboard.isDown("w") then
        dv.y = dv.y - 1
    end
    if love.keyboard.isDown("s") then
        dv.y = dv.y + 1
    end
    
    if love.keyboard.isDown("a") then
        dv.x = dv.x - 1
    end
    if love.keyboard.isDown("d") then
        dv.x = dv.x + 1
    end
    self.direction = dv:normalized()
    
    -- if dv.x < 0 then
    --     m.facing = 'l'
    -- elseif dv.x > 0 then
    --     m.facing = 'r'
    -- end
    
    local mouseX = self.camera:toWorld(love.mouse.getPosition())
    local pos = self:getCenter()
    if mouseX - pos.x > 0 then
        self.facing = 'r'
        self.hand_point = hand_point:clone()
    else
        self.facing = 'l'
        self.hand_point.x = self.w - hand_point.x
    end
end

function Player:updateInput()
    local i = Input

    if i.pressed('r') then
        self.weaponList[self.weapon]:reload()
    end

    for k = 1, 9 do
        if i.pressed(tostring(k)) then
            self:changeWeapon(k)
        end
    end

    if i.pressed('mouse1') then
        self:startFire(true)
    end
    if i.released('mouse1') then
        self:startFire(false)
    end

    local is_down, wy = i.pressed('wheely')
    if is_down then
        if wy > 0 then
            self:nextWeapon(false)
        elseif wy < 0 then
            self:nextWeapon(true)
        end
    end
end

function Player:update(dt)
    self:updateVelocityByInput(dt)
    Unit.update(self, dt)
    self:updateInput()
    self.weaponList[self.weapon]:update(dt)
end

function Player:draw()
    local weapon = self.weaponList[self.weapon]
    if weapon.r < 0 then
        weapon:draw()
        love.graphics.setColor(1, 1, 1, 1)
        Unit.draw(self)
    else
        love.graphics.setColor(1, 1, 1, 1)
        Unit.draw(self)
        weapon:draw()
    end
end

function Player:keypressed(key)
    local numkey = tonumber(key)
    if numkey and numkey >=1 and numkey <= 9 then
        self:changeWeapon(numkey)
    elseif key == 'r' then
        self.weaponList[self.weapon]:reload()
    end
end

return Player