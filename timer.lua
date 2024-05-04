Timer = T{}

-- ------------------------------------------------------------------------------------------------------
-- Formats the display timer.
-- ------------------------------------------------------------------------------------------------------
---@param time? number duration in seconds.
---@return string
-- ------------------------------------------------------------------------------------------------------
Timer.Format = function(time)
    if not time then return "00:00" end
    local minute, second
    minute = string.format("%02.f", math.floor((time / 60)))
    second = string.format("%02.f", math.floor(time % 60))
    return minute .. ":" .. second
end