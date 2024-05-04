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
}

-- ------------------------------------------------------------------------------------------------------
-- Draws the resting progress bar.
-- ------------------------------------------------------------------------------------------------------
Bar.Display = function()
    local flags = Bar.Flags.No_Background
    if Rest.Settings.Bar.Show_Background then flags = Bar.Flags.Background end

    UI.SetNextWindowSize({Rest.Settings.Bar.Width, -1}, ImGuiCond_Always)
    if UI.Begin("Rest", true, flags) then
        Rest.Settings.Bar.X_Pos, Rest.Settings.Bar.Y_Pos = UI.GetWindowPos()

        UI.ProgressBar(MP.Progress(), {-1, Rest.Settings.Bar.Height}, "")

        if Rest.Is_Resting then
            local time_remaining = Rest.Total_Time - (os.time() - Rest.Tick_Time)
            if time_remaining < 0 then time_remaining = 0 end
            if Rest.Settings.Bar.Show_Time_Remaining then
                UI.Text("Est. Time to Full: " .. Timer.Format(time_remaining))
                if Rest.Settings.Bar.Show_MP_Needed then
                    UI.SameLine() UI.Text(" (" .. tostring(Rest.MP_Needed) .. ")")
                end
                if Rest.Settings.Bar.Show_Next_Tick then
                    UI.SameLine() UI.Text(" (+" .. tostring(MP.Next_Tick()) .. ")")
                end
            end
        end

    end
    UI.End()
end