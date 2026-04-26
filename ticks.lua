Ticks = { }

Ticks.Enum =
{
    FIRST = 20,
    SUBSEQUENT = 10,
}

Ticks.Start_Time = nil
Ticks.First      = false
Ticks.Current    = 0
Ticks.Mod        = Ticks.Enum.FIRST
Ticks.Duration   = 0

-- ------------------------------------------------------------------------------------------------------
-- Change the length of the resting window.
-- ------------------------------------------------------------------------------------------------------
---@param mod integer 10 or 20 seconds
-- ------------------------------------------------------------------------------------------------------
local setMod = function(mod)
    if mod then
        Ticks.Mod = mod
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Moves to the next tick within an active resting session.
-- ------------------------------------------------------------------------------------------------------
local newTick = function()
    Ticks.Start_Time = os.time()
    Ticks.Duration   = 0
    Ticks.First      = true

    setMod(Ticks.Enum.SUBSEQUENT)

    Ticks.Current = Ticks.Current + 1
end

-- ------------------------------------------------------------------------------------------------------
-- Creates a new tick based on time since last tick.
-- ------------------------------------------------------------------------------------------------------
local timerFallback = function()
    if not Ticks.First and (Ticks.Duration >= (Ticks.Enum.FIRST + 1)) then
        newTick()
    elseif Ticks.First and (Ticks.Duration >= (Ticks.Enum.SUBSEQUENT + 1)) then
        newTick()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Calcualtes how much HP/MP is needed to get to full HP/MP.
-- Updates how much time it will take to get to full HP/MP.
-- The progress bar will not be reset for refresh ticks.
-- ------------------------------------------------------------------------------------------------------
Ticks.Loop = function()
    -- Max HP doesn't get updated right away so it can throw off HPMP needed when gear swapping upon resting.
    local newHP     = Ashita.CurrentHP()
    local newMP     = Ashita.CurrentMP()
    local hpp       = Ashita.HPP()
    local mpp       = Ashita.MPP()
    local maxMP     = Ashita.MaxMP()
    local resetTime = false

    -- HPMP is full. Just need to use timer based ticks.
    if hpp == 100 and (mpp == 100 or maxMP == 0) then
        timerFallback()
        resetTime = true

    -- MP changed.
    elseif newMP ~= MP.Current then
        if (newMP - MP.Current) > HPMP.Enum.BASE_HMP then
            newTick()
        end

        resetTime = true

    -- There are too many large sources of external healing that can trigger an inappropriate tick (cures, regen etc.)
    -- For that reason HP ticks will rely on timer only.
    elseif newHP ~= HP.Current then
        timerFallback()
        resetTime = true
    end

    -- Sets the HP and MP TTF globals.
    if resetTime then
        HPMP.TimeToFull()
    end

    MP.Current = newMP
    HP.Current = newHP
end

-- ------------------------------------------------------------------------------------------------------
-- Begin resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.RestStart = function()
    Ticks.Start_Time = os.time()
    Ticks.Duration   = 0
    Ticks.First      = false
    Ticks.Mod        = Ticks.Enum.FIRST
    Ticks.Current    = 0
    HP.Current       = Ashita.CurrentHP()
    MP.Current       = Ashita.CurrentMP()

    HPMP.TimeToFull()
end

-- ------------------------------------------------------------------------------------------------------
-- End resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.RestEnd = function()
    Ticks.Start_Time = nil
    Ticks.Current    = 0
    Ticks.Duration   = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Active resting.
-- ------------------------------------------------------------------------------------------------------
Ticks.Active = function()
    Ticks.Duration = os.time() - Ticks.Start_Time

    if Ticks.Duration >= 20 then
        Ticks.First = true

        setMod(Ticks.Enum.SUBSEQUENT)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the current tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ticks.GetCurrentTick = function()
    return Ticks.Current
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the elapsed time of the current tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ticks.GetDuration = function()
    return Ticks.Duration
end

-- ------------------------------------------------------------------------------------------------------
-- Returns a countdown in seconds until the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
Ticks.GetCountdown = function()
    local retValue = ''

    if Config.Bar.ShowCountdown() then
        if Status.IsResting() and Rest.Bar.Height >= 20 then
            local countdown = Ticks.Mod - Ticks.Duration

            if countdown < 0 then
                countdown = 0
            end

            retValue = tostring(countdown)
        end
    end

    return retValue
end

-- ------------------------------------------------------------------------------------------------------
-- Returns whether or not we are on the first tick or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ticks.IsFirstTick = function()
    return Ticks.First
end

-- ------------------------------------------------------------------------------------------------------
-- Returns total progress through the tick.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
Ticks.Progress = function()
    if not Ticks.Duration then
        Ticks.Duration = 0
    end

    if not Ticks.Mod then
        Ticks.Mod = Ticks.Enum.FIRST
    end

    return Ticks.Duration / Ticks.Mod
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
    local inc  = ClearMind.IncHMP()
    local tick = math.floor(diff / inc)
end
