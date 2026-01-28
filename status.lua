Status = { }

Status.Resting = false

-- ------------------------------------------------------------------------------------------------------
-- Sets initial resting flags.
-- ------------------------------------------------------------------------------------------------------
local restStart = function()
    Status.Resting = true
    Ticks.RestStart()
    Ticks.Loop()
end

-- ------------------------------------------------------------------------------------------------------
-- Clears resting flags.
-- ------------------------------------------------------------------------------------------------------
local restEnd = function()
    Status.Resting = false

    MP.ResetTimeToFull()
    MP.SetMPNeeded(0)
    Ticks.RestEnd()
end

-- ------------------------------------------------------------------------------------------------------
-- Handles active resting.
-- ------------------------------------------------------------------------------------------------------
local restActive = function()
    Ticks.Active()
    Ticks.Loop()
end

-- ------------------------------------------------------------------------------------------------------
-- This is the primary resting loop.
-- ------------------------------------------------------------------------------------------------------
Status.CheckRest = function()
    -- Just started a fresh rest.
    if Ashita.IsResting() and not Status.IsResting() then
        restStart()

    -- Stopped resting.
    elseif not Ashita.IsResting() and Status.IsResting() then
        restEnd()
        MP.TTF_Max = 0
        HP.TTF_Max = 0

    -- Currently resting and have been resting.
    elseif Status.IsResting() then
        restActive()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether we are resting or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Status.IsResting = function()
    return Status.Resting
end
