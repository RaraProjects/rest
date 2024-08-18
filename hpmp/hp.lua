HP = T{}

-- Horizon HMP Documentation
-- https://horizonffxi.wiki/HP_Recovered_While_Healing

HP.Breakdown = T{
    Base = HPMP.Enum.BASE_HHP,
    Increment = 0,
    Gear = 0,
    Food = 0,
    Signet_Base = 0,
    Signet_Increment = 0,
}

HP.Current = 0      -- Current HP
HP.Needed = 0       -- Missing HP
HP.TTF = 0          -- Current Time to Full
HP.Next = 0         -- How much HP we will have after the next tick
HP.TTF_Max = 0      -- Used for the denominator in the MP progress bar. Doesn't reset with each tick. Gets reset on end of resting.

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
HP.Tick_Breakdown = function()
    local current_tick = tostring(Ticks.Get_Current_Tick())
    local tick_bonus = tostring(HPMP.Enum.INC_HHP) .. "*" .. current_tick
    local signet_tick = tostring(Signet.Inc_HP()) .. "*" .. current_tick

    local table_flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)
    local col_flags = bit.bor(ImGuiTableColumnFlags_None)
    local col_width = HPMP.Column_Widths.Element

    if UI.BeginTable("HP Breakdown", 3, table_flags) then
        UI.TableSetupColumn("HP", col_flags, col_width)
        UI.TableSetupColumn("Value", col_flags)
        UI.TableSetupColumn("Notes", col_flags)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Base HHP")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Base))
        UI.TableNextColumn()

        UI.TableNextColumn() UI.Text("Tick Bonus")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Increment))
        UI.TableNextColumn() UI.Text(tick_bonus)

        UI.TableNextColumn() UI.Text("Gear Bonus")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Gear))
        UI.TableNextColumn()

        UI.TableNextColumn() UI.Text("Food Bonus")
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Food))
        UI.TableNextColumn()

        if Ashita.Has_Buff(Ashita.Enum.Buffs.SIGNET) then
            UI.TableNextColumn() UI.Text("Signet Base*")
            UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Signet_Base))
            UI.TableNextColumn()

            UI.TableNextColumn() UI.Text("Signet Tick*")
            UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Signet_Increment))
            UI.TableNextColumn() UI.Text(signet_tick)
        end

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
    if not next_tick then return "HP: ----" end

    local time_remaining = HP.Get_Time_To_Full() - Ticks.Get_Duration()
    if time_remaining < 0 then time_remaining = 0 end

    local asterisk = true
    local time_string = Timer.Format(time_remaining)
    if time_remaining == 0 then
        time_string = "FULL"
        asterisk = false
    end
    if asterisk then time_string = time_string .. "*" end

    if Config.Bar.Show_Next_Tick() then time_string = time_string .. " (+" .. tostring(next_tick.hp) .. "*)" end

    return time_string
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the HP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
HP.Progress = function()
    if HP.TTF_Max == 0 then return 1 end
    return 1 - ((HP.Get_Time_To_Full() - Ticks.Get_Duration()) / HP.TTF_Max)
end