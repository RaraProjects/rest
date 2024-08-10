MP = T{}

-- Horizon HMP Documentation
-- https://horizonffxi.wiki/MP_Recovered_While_Healing
-- https://horizonffxi.wiki/Clear_Mind

-- Retail HMP Documentation
-- https://www.bg-wiki.com/ffxi/Clear_Mind

MP.Breakdown = T{
    Base = HPMP.Enum.BASE_HMP,
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

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP bar.
-- ------------------------------------------------------------------------------------------------------
MP.TTF_Bar = function()
    if Config.MP.Show_Time_To_Full_Bar() then
        UI.PushStyleColor(ImGuiCol_PlotHistogram, {0.0, 0.50, 1.0, 1.0})
        UI.ProgressBar(MP.Progress(), {-1, Rest.Bar.Height}, MP.TTF_Timer())
        UI.PopStyleColor(1)
    end
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
MP.Tick_Breakdown = function(col_flags, width)
    local tick_bonus = " (" .. tostring(Clear_Mind.Inc_HMP()) .. "*" .. tostring(Ticks.Get_Current_Tick()) .. ")"
    local cm_rank = Clear_Mind.Rank()

    UI.Text("MP")
    if UI.BeginTable("MP Breakdown", 2) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)

        UI.TableNextColumn() UI.Text("Base HMP")
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Base))

        UI.TableNextColumn() UI.Text("Tick Bonus")
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Increment) .. tick_bonus)

        UI.TableNextColumn() UI.Text("Clear Mind")
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.CM) .. " (" .. Clear_Mind.Display_Rank(cm_rank) .. ")")

        UI.TableNextColumn() UI.Text("Gear Bonus")
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Gear))

        UI.TableNextColumn() UI.Text("Food Bonus")
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Food))

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Show the Time to Full timer.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
MP.TTF_Timer = function()
    local next_tick = HPMP.Next_Tick()
    if not next_tick then return "MP: ---" end

    local time_remaining = MP.Get_Time_To_Full() - Ticks.Get_Duration()
    if time_remaining < 0 then time_remaining = 0 end
    local time_string = Timer.Format(time_remaining)
    if time_remaining == 0 then time_string = "---" end

    if Config.Bar.Show_Next_Tick() then time_string = time_string .. " (+" .. tostring(next_tick.mp) .. ")" end

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