Bar = T{}

Bar.Flags = T{}
Bar.Flags.Background = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav)
Bar.Flags.No_Background = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoBackground)

Bar.Defaults = T{
    Width  = 305,
    Height = 10,
    X_Pos  = 100,
    Y_Pos  = 100,
    Show_Time_Remaining = true,
    Show_Next_Tick = true,
    Show_MP_Needed = false,
    Show_Background = false,
    Window_Scaling = 1,
}

Bar.Scaling_Set = false

-- ------------------------------------------------------------------------------------------------------
-- Draws the resting progress bar.
-- ------------------------------------------------------------------------------------------------------
Bar.Display = function()
    local flags = Bar.Flags.No_Background
    if Rest.Settings.Bar.Show_Background then flags = Bar.Flags.Background end

    UI.SetNextWindowSize({Rest.Settings.Bar.Width, -1}, ImGuiCond_Always)
    if UI.Begin("Rest", true, flags) then
        Rest.Settings.Bar.X_Pos, Rest.Settings.Bar.Y_Pos = UI.GetWindowPos()
        Bar.Set_Window_Scale()

        if Rest.Settings.Config.Show_MP then UI.Text("MP: " .. tostring(Ashita.Current_MP()) .. "/" .. tostring(Ashita.Max_MP()) .. " (" .. (Rest.Next_MP) .. ")") end

        UI.ProgressBar(MP.Progress(), {-1, Rest.Settings.Bar.Height}, "")

        if Rest.Is_Resting then
            local time_remaining = Rest.Total_Time - (os.time() - Rest.Tick_Time)
            if time_remaining < 0 then time_remaining = 0 end
            if Rest.Settings.Bar.Show_Time_Remaining then
                UI.Text(Timer.Format(time_remaining))
                if Rest.Settings.Bar.Show_MP_Needed then
                    UI.SameLine() UI.Text(" (" .. tostring(Rest.MP_Needed) .. ")")
                end
                if Rest.Settings.Bar.Show_Next_Tick then
                    UI.SameLine() UI.Text(" (+" .. tostring(MP.Next_Tick()) .. ")")
                end
            end

            if Rest.Settings.Config.Show_Breakdown then
                UI.Text("Base     : " .. tostring(MP.Breakdown.Base))
                UI.Text("Tick     : " .. tostring(MP.Breakdown.Increment))
                UI.Text("Gear     : " .. tostring(MP.Breakdown.Gear))
                UI.Text("Cl. Mind : " .. tostring(MP.Breakdown.CM))
                UI.Text("Food     : " .. tostring(MP.Breakdown.Food))
            end
        end

    end
    UI.End()
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Bar.Set_Window_Scale = function()
    if not Bar.Scaling_Set then
        UI.SetWindowFontScale(Rest.Settings.Bar.Window_Scaling)
        Bar.Scaling_Set = true
    end
end