Bar = T{}

Bar.Window_Flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav)

Bar.Scaling_Set = false
Bar.Reset_Position = true

require("Bar.config")

-- ------------------------------------------------------------------------------------------------------
-- Draws the resting progress bar.
-- ------------------------------------------------------------------------------------------------------
Bar.Display = function()
    local flags = Bar.Window_Flags
    if Rest.Bar.Position_Locked then flags = bit.bor(flags, ImGuiWindowFlags_NoMove) end
    if not Bar.Config.Show_Background() then flags = bit.bor(flags, ImGuiWindowFlags_NoBackground) end

    -- Handle resetting the window position between characters.
    if Bar.Reset_Position then
        UI.SetNextWindowPos({Rest.Bar.X_Pos, Rest.Bar.Y_Pos}, ImGuiCond_Always)
        Bar.Reset_Position = false
    end
    UI.SetNextWindowSize({Rest.Bar.Width, -1}, ImGuiCond_Always)

    if UI.Begin("Rest", true, flags) then
        Rest.Bar.X_Pos, Rest.Bar.Y_Pos = UI.GetWindowPos()
        Bar.Config.Set_Window_Scale()

        if Bar.Config.Show_Food() then UI.Text(Bar.Food()) end
        if MP.Config.Show_MP() then UI.Text(MP.Display_MP()) end
        UI.ProgressBar(Ticks.Progress(), {-1, Rest.Bar.Height}, Ticks.Get_Countdown())

        if MP.Config.Show_Time_To_Full_Bar() then
            UI.PushStyleColor(ImGuiCol_PlotHistogram, {0.0, 0.50, 1.0, 1.0})
            UI.ProgressBar(MP.Progress(), {-1, Rest.Bar.Height}, MP.TTF_Timer())
            UI.PopStyleColor(1)
        end

        if Status.Is_Resting() then MP.Bar_MP_Line() end
    end
    UI.End()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the active food.
-- ------------------------------------------------------------------------------------------------------
Bar.Food = function()
    return "HMP Food: " .. MP.Food.Get_Name()
end