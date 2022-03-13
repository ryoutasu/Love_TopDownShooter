function math.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function math.lerp(v0, v1, t)
    return (1 - t) * v0 + t * v1;
end

function updateOrder(a, b)
    return a:getUpdateOrder() < b:getUpdateOrder()
end

function drawOrder(a, b)
    return a:getDrawOrder() > b:getDrawOrder()
end

function isPointInside(x, y, x2, y2, w, h)
    return (x > x2 and y > y2)
        and (x < x2+w and y < y2+h)
end