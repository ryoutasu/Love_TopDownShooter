function math.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function math.lerp(v0, v1, t)
    return (1 - t) * v0 + t * v1;
end