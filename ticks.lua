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
-- Calcualtes how much HP/MP is needed to get to full HP/MP.
-- Updates how much time it will take to get to full HP/MP.
-- The progress bar will not be reset for refresh ticks.
-- ------------------------------------------------------------------------------------------------------
Ticks.Loop = function()
    -- Max HP doesn't get updated right away so it can throw off HPMP needed when gear swapping upon resting.
    local new_hp = Ashita.Current_HP()
    local new_mp = Ashita.Current_MP()
    local hpp = Ashita.HPP()
    local mpp = Ashita.MPP()
    local max_mp = Ashita.Max_MP()
    local reset_time = false

    -- HPMP is full. Just need to use timer based ticks.
    if hpp == 100 and (mpp == 100 or max_mp == 0) then
        Ticks.Timer_Fallback()
        reset_time = true

    -- MP changed.
    elseif new_mp ~= MP.Current then
        if (new_mp - MP.Current) > HPMP.Enum.BASE_HMP then
            Ticks.New()
        end
        reset_time = true

    -- There are too many large sources of external healing that can trigger an inappropriate tick (cures, regen etc.)
    -- For that reason HP ticks will rely on timer only.
    elseif new_hp ~= HP.Current then
        Ticks.Timer_Fallback()
        reset_time = true
    end

    -- Sets the HP and MP TTF globals.
    if reset_time then HPMP.Time_To_Full() end

    MP.Current = new_mp
    HP.Current = new_hp
end

-- ------------------------------------------------------------------------------------------------------
-- Creates a new tick based on time since last tick.
-- ------------------------------------------------------------------------------------------------------
Ticks.Timer_Fallback = function()
    if not Ticks.First and (Ticks.Duration >= (Ticks.Enum.FIRST + 1)) then
        Ticks.New()
    elseif Ticks.First and (Ticks.Duration >= (Ticks.Enum.SUBSEQUENT + 1)) then
        Ticks.New()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Begin resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.Rest_Start = function()
    Ticks.Start_Time = os.time()
    Ticks.Duration = 0
    Ticks.First = false
    Ticks.Mod = Ticks.Enum.FIRST
    Ticks.Current = 0
    HP.Current = Ashita.Current_HP()
    MP.Current = Ashita.Current_MP()
    HPMP.Time_To_Full()
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
-- NOT USED YET
-- If you loaded Rest mid-rest or were getting ticks while weakened then you won't know what tick your on.
-- This function calculates what your current tick is.
-- ------------------------------------------------------------------------------------------------------
---@param mp_gained integer
-- ------------------------------------------------------------------------------------------------------
Ticks.Backfill = function(mp_gained)
    local base = MP.Breakdown.Base + MP.Breakdown.Gear + MP.Breakdown.CM + MP.Breakdown.Food
    local diff = mp_gained - base   -- Get the incremental tick amount.
    local inc = Clear_Mind.Inc_HMP()
    local tick = math.floor(diff / inc)
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
    if Config.Bar.Show_Countdown() then
        if Status.Is_Resting() and Rest.Bar.Height >= 20 then
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