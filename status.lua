Status = T{}

Status.Resting = false

-- ------------------------------------------------------------------------------------------------------
-- Sets initial resting flags.
-- ------------------------------------------------------------------------------------------------------
Status.Rest_Start = function()
    Status.Resting = true
    Ticks.Rest_Start()
    MP.MP_To_Full()
end

-- ------------------------------------------------------------------------------------------------------
-- Clears resting flags.
-- ------------------------------------------------------------------------------------------------------
Status.Rest_End = function()
    Status.Resting = false
    MP.Reset_Time_To_Full()
    MP.Set_MP_Needed(0)
    Ticks.Rest_End()
end

-- ------------------------------------------------------------------------------------------------------
-- Handles active resting.
-- ------------------------------------------------------------------------------------------------------
Status.Rest_Active = function()
    Ticks.Active()
    MP.MP_To_Full()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether we are resting or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Status.Is_Resting = function()
    return Status.Resting
end