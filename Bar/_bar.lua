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
    if Bar.Config.Show_Background() then flags = Bar.Flags.Background end

    UI.SetNextWindowSize({Rest.Bar.Width, -1}, ImGuiCond_Always)
    if UI.Begin("Rest", true, flags) then
        Rest.Bar.X_Pos, Rest.Bar.Y_Pos = UI.GetWindowPos()
        Bar.Config.Set_Window_Scale()

        if MP.Config.Show_MP() then UI.Text(MP.Display_MP()) end
        if Bar.Config.Show_Food() then UI.Text(Bar.Food()) end
        UI.ProgressBar(Ticks.Progress(), {-1, Rest.Bar.Height}, Ticks.Get_Countdown())

        if Status.Is_Resting() then
            local time_remaining = MP.Get_Time_To_Full() - Ticks.Get_Duration()
            if time_remaining < 0 then time_remaining = 0 end

            if MP.Config.Show_Time_To_Full() then
                UI.Text("Full MP: " .. Timer.Format(time_remaining))
                if MP.Config.Show_Next_Tick() then
                    UI.SameLine() UI.Text(" Next: MP+" .. tostring(MP.Next_Tick()))
                end
            end

            if MP.Config.Show_Breakdown() then MP.Tick_Breakdown() end
        end

    end
    UI.End()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the active food.
-- ------------------------------------------------------------------------------------------------------
Bar.Food = function()
    return "HMP Food: " .. MP.Food.Get_Name()
end