HP = T{}

HP.Breakdown = T{
    Base = HPMP.Enum.BASE_HHP,
    Increment = 0,
    Bonus = 0,
    Gear = 0,
    CM = 0,
    Food = 0,
}

HP.Needed = 0       -- Missing HP
HP.TTF = 0          -- Current Time to Full
HP.Next = 0         -- How much HP we will have after the next tick
HP.TTF_Max = 0      -- Used for the denominator in the HP progress bar.

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP bar.
-- ------------------------------------------------------------------------------------------------------
HP.TTF_Bar = function()
    if Config.HP.Show_Time_To_Full_Bar() then
        UI.ProgressBar(HP.Progress(), {-1, Rest.Bar.Height}, HP.TTF_Timer())
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets HP needed to a new value.
-- ------------------------------------------------------------------------------------------------------
---@param hp_needed integer
-- ------------------------------------------------------------------------------------------------------
HP.Set_HP_Needed = function(hp_needed)
    if not hp_needed then hp_needed = 0 end
    HP.Needed = hp_needed
end

-- ------------------------------------------------------------------------------------------------------
-- Resets time to full HP.
-- ------------------------------------------------------------------------------------------------------
HP.Reset_Time_To_Full = function()
    HP.TTF = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much time is left until we have full HP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
HP.Get_Time_To_Full = function()
    return HP.TTF
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much HP we will have after the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
HP.Get_Next_HP = function()
    local next_hp = HP.Next
    local max_hp = Ashita.Max_HP()
    if next_hp > max_hp then next_hp = max_hp end
    return next_hp
end

-- ------------------------------------------------------------------------------------------------------
-- Creates display string to show current HP.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
HP.Display_HP = function()
    local header = "HP: "
    local current_hp = Ashita.Current_HP()
    local next_string = ""
    if Status.Is_Resting() and Rest.HP.Show_Next_Tick then
        local next_hp = HP.Get_Next_HP()
        local max_hp = Ashita.Max_HP()
        local next_hpp = math.ceil((next_hp / max_hp) * 100)
        next_string = " -> " .. tostring(next_hp) .. " (" .. tostring(next_hpp) .. "%)"
    end
    return  header .. tostring(current_hp) .. next_string
end

-- ------------------------------------------------------------------------------------------------------
-- Show the breakdown of the tick.
-- ------------------------------------------------------------------------------------------------------
HP.Tick_Breakdown = function(col_flags, width)
    UI.Text("HP")
    if UI.BeginTable("HP Breakdown", 2) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)

        UI.TableNextColumn() UI.Text("Base HHP")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Base))

        UI.TableNextColumn() UI.Text("Tick Bonus")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Increment) .. " (" .. tostring(Ticks.Get_Current_Tick()) .. ")")

        UI.TableNextColumn() UI.Text("Gear Bonus")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Gear))

        UI.TableNextColumn() UI.Text("Food Bonus")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Food))

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the HP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
HP.Bar_HP_Line = function()
    if Config.HP.Show_Breakdown() then HP.Tick_Breakdown() end
end

-- ------------------------------------------------------------------------------------------------------
-- Show the Time to Full timer.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
HP.TTF_Timer = function()
    local next_tick = HPMP.Next_Tick()
    if not next_tick then return "HP: ---" end

    local time_remaining = HP.Get_Time_To_Full() - Ticks.Get_Duration()
    if time_remaining < 0 then time_remaining = 0 end
    local time_string = Timer.Format(time_remaining)
    if time_remaining == 0 then time_string = "---" end

    if Config.Bar.Show_Next_Tick() then time_string = time_string .. " (+" .. tostring(next_tick.hp) .. ")" end

    return "HP: " .. time_string
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the HP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
HP.Progress = function()
    if HP.TTF_Max == 0 then return 0 end
    return 1 - ((HP.Get_Time_To_Full() - Ticks.Get_Duration()) / HP.TTF_Max)
end