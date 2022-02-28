local tab = '    '

local function write_key(key)
    local t = type(key)
    if t == "number" then return ('[%s] = '):format(key)
    elseif t == "string" then return key..' = ' end
    return ''
end

local function write_table(t, name, str, spaces)
    str = str .. spaces .. name .. '{\n'

    local s = spaces .. tab
    local parts = {}
    for key, value in pairs(t) do
        if type(value) == "table" then
            table.insert(parts, write_table(value, write_key(key), '', s))
        elseif type(value) == "number" then
            table.insert(parts, ('%s%s%s'):format(s, write_key(key), value))
        elseif type(value) == "string" then
            table.insert(parts, ('%s%s\'%s\''):format(s, write_key(key), value))
        elseif type(value) == "boolean" then
            table.insert(parts, ('%s%s%s'):format(s, write_key(key), value))
        end
    end
    str = str .. table.concat(parts, ',\n') .. '\n'

    str = str .. spaces .. '}'
    return str
end

return function(t)
    return write_table(t, '', '', '')
end