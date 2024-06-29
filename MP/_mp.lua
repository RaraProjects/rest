MP = T{}

require("MP.enum")
require("MP.clear_mind")
require("MP.equipment")
require("MP.food")
require("MP.config")
require("MP.util")

MP.Breakdown = T{
    Base = MP.Enum.BASE_HMP,
    Increment = 0,
    Bonus = 0,
    Gear = 0,
    CM = 0,
    Food = 0,
}

MP.Needed = 0       -- Missing MP
MP.TTF = 0          -- Current Time to Full
MP.Next = 0         -- How much MP we will have after the next tick
MP.TTF_Max = 0      -- Used for the denominator in the MP progress bar.

-- Horizon HMP Documentation
-- https://horizonffxi.wiki/MP_Recovered_While_Healing
-- https://horizonffxi.wiki/Clear_Mind

-- Retail HMP Documentation
-- https://www.bg-wiki.com/ffxi/Clear_Mind

-- ------------------------------------------------------------------------------------------------------
-- This is the primary resting loop.
-- ------------------------------------------------------------------------------------------------------
MP.Check_Resting_Status = function()
    if Ashita.Is_Resting() and not Status.Is_Resting() then
        Status.Rest_Start()
    elseif not Ashita.Is_Resting() and Status.Is_Resting() then
        Status.Rest_End()
        MP.TTF_Max = 0
    elseif Status.Is_Resting() then
        Status.Rest_Active()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Calcualtes how much MP is needed to get to full MP.
-- The progress bar will not be reset for refresh ticks.
-- ------------------------------------------------------------------------------------------------------
MP.MP_To_Full = function()
    local new_mp_needed = MP.Util.Missing_MP()

    if new_mp_needed ~= MP.Needed then
        -- If we only gained a small amount of MP then it was probably from refresh and shouldn't count as a tick.
        if (MP.Needed - new_mp_needed) > MP.Enum.BASE_HMP then
            Ticks.New()
        end
        MP.Time_To_Full(new_mp_needed)
    end

    MP.Needed = new_mp_needed
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much time remains until full MP. This gets called every time there is an MP change.
-- ------------------------------------------------------------------------------------------------------
---@param mp_needed integer
-- ------------------------------------------------------------------------------------------------------
MP.Time_To_Full = function(mp_needed)
    local total_time = 0

    -- Only during first tick.
    if not Ticks.Is_First_Tick() then
        total_time = total_time + 20
        mp_needed = mp_needed - MP.Clear_Mind.Base_HMP()
    end

    -- Subsequent ticks if more MP needs to be recovered.
    if mp_needed < 0 then mp_needed = 0 end
    local ticks = Ticks.Get_Current_Tick()
    while mp_needed > 0 do
        ticks = ticks + 1
        total_time = total_time + 10
        mp_needed = mp_needed
                    - MP.Clear_Mind.Base_HMP()
                    - MP.Clear_Mind.Inc_HMP() * ticks
                    - MP.Equipment.MP()
                    - MP.Clear_Mind.MP()
                    - MP.Food.Get_HMP()
    end

    MP.TTF = total_time
    if MP.TTF_Max == 0 then MP.TTF_Max = total_time end
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much the player should get on the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
MP.Next_Tick = function()
    MP.Breakdown.Base = MP.Clear_Mind.Base_HMP()
    MP.Breakdown.Increment = (MP.Clear_Mind.Inc_HMP() * Ticks.Get_Current_Tick()) or 0
    MP.Breakdown.Gear = MP.Equipment.MP() or 0
    MP.Breakdown.CM = MP.Clear_Mind.MP() or 0
    MP.Breakdown.Food = MP.Food.Get_HMP() or 0

    local tick_amount = MP.Breakdown.Base + MP.Breakdown.Increment + MP.Breakdown.Gear + MP.Breakdown.CM + MP.Breakdown.Food
    MP.Next = Ashita.Current_MP() + tick_amount

    return tick_amount
end

-- ------------------------------------------------------------------------------------------------------
-- Sets MP needed to a new value.
-- ------------------------------------------------------------------------------------------------------
---@param mp_needed integer
-- ------------------------------------------------------------------------------------------------------
MP.Set_MP_Needed = function(mp_needed)
    if not mp_needed then mp_needed = 0 end
    MP.Needed = mp_needed
end

-- ------------------------------------------------------------------------------------------------------
-- Resets time to full MP.
-- ------------------------------------------------------------------------------------------------------
MP.Reset_Time_To_Full = function()
    MP.TTF = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much time is left until we have full MP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
MP.Get_Time_To_Full = function()
    return MP.TTF
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much MP we will have after the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
MP.Get_Next_MP = function()
    local next_mp = MP.Next
    local max_mp = Ashita.Max_MP()
    if next_mp > max_mp then next_mp = max_mp end
    return next_mp
end

-- ------------------------------------------------------------------------------------------------------
-- Creates display string to show current MP.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
MP.Display_MP = function()
    local header = "MP: "
    local current_mp = Ashita.Current_MP()
    local next_string = ""
    if Status.Is_Resting() and Rest.MP.Show_Next_Tick then
        local next_mp = MP.Get_Next_MP()
        local max_mp = Ashita.Max_MP()
        local next_mpp = math.ceil((next_mp / max_mp) * 100)
        next_string = " -> " .. tostring(next_mp) .. " (" .. tostring(next_mpp) .. "%)"
    end
    return  header .. tostring(current_mp) .. next_string
end

-- ------------------------------------------------------------------------------------------------------
-- Show the breakdown of the tick.
-- ------------------------------------------------------------------------------------------------------
MP.Tick_Breakdown = function()
    local tick_bonus = " (" .. tostring(MP.Clear_Mind.Inc_HMP()) .. "*" .. tostring(Ticks.Get_Current_Tick()) .. ")"
    local cm_rank = MP.Clear_Mind.Rank()

    UI.Text("Base HMP   : " .. tostring(MP.Breakdown.Base))
    UI.Text("Tick Bonus : " .. tostring(MP.Breakdown.Increment) .. tick_bonus)
    UI.Text("Clear Mind : " .. tostring(MP.Breakdown.CM) .. " (" .. MP.Clear_Mind.Display_Rank(cm_rank) .. ")")
    UI.Text("Gear Bonus : " .. tostring(MP.Breakdown.Gear))
    UI.Text("Food Bonus : " .. tostring(MP.Breakdown.Food) .. " (" .. MP.Food.Get_Name() .. ")")
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
MP.Bar_MP_Line = function()
    if MP.Config.Show_Next_Tick() then UI.Text("Next: MP+" .. tostring(MP.Next_Tick())) end
    if MP.Config.Show_Breakdown() then MP.Tick_Breakdown() end
end

-- ------------------------------------------------------------------------------------------------------
-- Show the Time to Full timer.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
MP.TTF_Timer = function()
    local time_remaining = MP.Get_Time_To_Full() - Ticks.Get_Duration()
    if time_remaining < 0 then time_remaining = 0 end
    local time_string = Timer.Format(time_remaining)
    if time_remaining == 0 then time_string = "---" end
    return "MP: " .. time_string
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
MP.Progress = function()
    if MP.TTF_Max == 0 then return 0 end
    return 1 - ((MP.Get_Time_To_Full() - Ticks.Get_Duration()) / MP.TTF_Max)
end