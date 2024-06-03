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
    if Bar.Config.Show_Background() then flags = Bar.Flags.Background end

    UI.SetNextWindowSize({Rest.Bar.Width, -1}, ImGuiCond_Always)
    if UI.Begin("Rest", true, flags) then
        Rest.Bar.X_Pos, Rest.Bar.Y_Pos = UI.GetWindowPos()
        Bar.Config.Set_Window_Scale()

        if Bar.Config.Show_Food() then UI.Text(Bar.Food()) end
        if MP.Config.Show_MP() then UI.Text(MP.Display_MP()) end
        UI.ProgressBar(Ticks.Progress(), {-1, Rest.Bar.Height}, Ticks.Get_Countdown())

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