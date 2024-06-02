Ticks = T{}

Ticks.Enum = T{
    FIRST = 20,
    SUBSEQUENT = 10,
}

Ticks.Start_Time = nil
Ticks.First = false
Ticks.Current = 0
Ticks.Mod = Ticks.Enum.FIRST
Ticks.Duration = 0

-- ------------------------------------------------------------------------------------------------------
-- Begin resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.Rest_Start = function()
    Ticks.Start_Time = os.time()
    Ticks.Duration = 0
    Ticks.First = false
    Ticks.Mod = Ticks.Enum.FIRST
    Ticks.Current = 0
end

-- ------------------------------------------------------------------------------------------------------
-- End resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.Rest_End = function()
    Ticks.Start_Time = nil
    Ticks.Current = 0
    Ticks.Duration = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Active resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.Active = function()
    Ticks.Duration = os.time() - Ticks.Start_Time
    if Ticks.Duration >= 20 then
        Ticks.First = true
        Ticks.Set_Mod(Ticks.Enum.SUBSEQUENT)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Moves to the next tick within an active resting session.
-- ------------------------------------------------------------------------------------------------------
Ticks.New = function()
    Ticks.Start_Time = os.time()
    Ticks.Duration = 0
    Ticks.First = true
    Ticks.Set_Mod(Ticks.Enum.SUBSEQUENT)
    Ticks.Current = Ticks.Current + 1
end

-- ------------------------------------------------------------------------------------------------------
-- Change the length of the resting window.
-- ------------------------------------------------------------------------------------------------------
---@param mod integer 10 or 20 seconds
-- ------------------------------------------------------------------------------------------------------
Ticks.Set_Mod = function(mod)
    if mod then Ticks.Mod = mod end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the current tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ticks.Get_Current_Tick = function()
    return Ticks.Current
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the elapsed time of the current tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ticks.Get_Duration = function()
    return Ticks.Duration
end

-- ------------------------------------------------------------------------------------------------------
-- Returns a countdown in seconds until the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
Ticks.Get_Countdown = function()
    local ret_value = ""
    if Rest.Settings.Config.Show_Countdown then
        if Status.Is_Resting() and Rest.Settings.Bar.Height >= 20 then
            local countdown = Ticks.Mod - Ticks.Duration
            if countdown < 0 then countdown = 0 end
            ret_value = tostring(countdown)
        end
    end
    return ret_value
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether or not we are on the first tick or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ticks.Is_First_Tick = function()
    return Ticks.First
end

-- ------------------------------------------------------------------------------------------------------
-- Returns total progress through the tick.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
Ticks.Progress = function()
    if not Ticks.Duration then Ticks.Duration = 0 end
    if not Ticks.Mod then Ticks.Mod = Ticks.Enum.FIRST end
    return Ticks.Duration / Ticks.Mod
end