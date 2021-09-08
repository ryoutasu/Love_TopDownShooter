local vector = require 'lib.vector'
local path = 'resources/'

local Weapons = {
    ['PISTOL'] = {
        type = 'pistol',
        imagePath = path..'desert_hawk.png',
        scale = 2,
        holding_point = vector(2, 6),
        muzzle_offset = vector(11, 0),

        damage = 25,
        timeToCooldown = 0.08,
        clipSize = 8,
        timeToReload = 1.5,
        spread = 0       -- degrees
    },
    ['AR'] = {
        type = 'automatic',
        imagePath = path..'milit.png',
        scale = 3,
        holding_point = vector(4, 4),
        muzzle_offset = vector(14, 0),

        damage = 25,
        timeToCooldown = 0.1,
        clipSize = 100,
        timeToReload = 1.5,
        spread = 0       -- degrees
    },
    ['MAG'] = {
        type = 'automatic',
        imagePath = path..'mag.png',
        scale = 2,
        holding_point = vector(5, 6),
        muzzle_offset = vector(14, 2),

        damage = 25,
        timeToCooldown = 0.1,
        clipSize = 100,
        timeToReload = 1.5,
        spread = 5       -- degrees
    },
    ['SHOTGUN'] = {
        type = 'shotgun',
        -- type = 'automatic',
        imagePath = path..'milit.png',
        scale = 3,
        holding_point = vector(4, 4),
        muzzle_offset = vector(14, 0),

        damage = 25,
        timeToCooldown = 0.15,
        clipSize = 2,
        timeToReload = 1.5,
        spread = 20,      -- degrees
        shotsPerFire = 10,
        onFire = function (self)
            for i = 1, 5 do
                self:createBullet()
            end
        end,
    },
}

return Weapons