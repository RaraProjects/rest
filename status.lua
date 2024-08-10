Status = T{}

Status.Resting = false

-- ------------------------------------------------------------------------------------------------------
-- This is the primary resting loop.
-- ------------------------------------------------------------------------------------------------------
Status.Check_Rest = function()
    -- Just started a fresh rest.
    if Ashita.Is_Resting() and not Status.Is_Resting() then
        Status.Rest_Start()

    -- Stopped resting.
    elseif not Ashita.Is_Resting() and Status.Is_Resting() then
        Status.Rest_End()
        MP.TTF_Max = 0
        HP.TTF_Max = 0

    -- Currently resting and have been resting.
    elseif Status.Is_Resting() then
        Status.Rest_Active()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets initial resting flags.
-- ------------------------------------------------------------------------------------------------------
Status.Rest_Start = function()
    Status.Resting = true
    Ticks.Rest_Start()
    Ticks.Loop()
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
    Ticks.Loop()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether we are resting or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Status.Is_Resting = function()
    return Status.Resting
end