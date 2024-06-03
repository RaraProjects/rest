Bar = T{}

Bar.Flags = T{}
Bar.Flags.Background = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav)

Bar.Flags.No_Background = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav, ImGuiWindowFlags_NoBackground)

Bar.Scaling_Set = false

require("Bar.config")
require("Bar.widgets")

------------------------------------------------------------------------------------------------------
-- Initialize the window position.
------------------------------------------------------------------------------------------------------
Bar.Initialize = function()
    UI.SetNextWindowPos({Rest.Bar.X_Pos, Rest.Bar.Y_Pos}, ImGuiCond_Always)
    Bar.Display()
end

-- ------------------------------------------------------------------------------------------------------
-- Draws the resting progress bar.
-- ------------------------------------------------------------------------------------------------------
Bar.Display = function()
    local flags = Bar.Flags.No_Background
    if Rest.Bar.Show_Background then flags = Bar.Flags.Background end

    UI.SetNextWindowSize({Rest.Bar.Width, -1}, ImGuiCond_Always)
    if UI.Begin("Rest", true, flags) then
        Rest.Bar.X_Pos, Rest.Bar.Y_Pos = UI.GetWindowPos()
        Bar.Config.Set_Window_Scale()

        if MP.Config.Show_MP() then UI.Text(MP.Display_MP()) end
        UI.ProgressBar(Ticks.Progress(), {-1, Rest.Bar.Height}, Ticks.Get_Countdown())

        if Status.Is_Resting() then
            local time_remaining = MP.Get_Time_To_Full() - Ticks.Get_Duration()
            if time_remaining < 0 then time_remaining = 0 end

            if Rest.Bar.Show_Time_Remaining then
                UI.Text(Timer.Format(time_remaining))
                if Rest.Bar.Show_Next_Tick then
                    UI.SameLine() UI.Text(" (MP+" .. tostring(MP.Next_Tick()) .. ")")
                end
            end

            if Rest.Config.Show_Breakdown then MP.Tick_Breakdown() end
        end

    end
    UI.End()
end