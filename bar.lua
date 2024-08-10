Bar = T{}

Bar.Window_Flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize,
ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing,
ImGuiWindowFlags_NoNav)

Bar.Scaling_Set = false
Bar.Reset_Position = true

-- ------------------------------------------------------------------------------------------------------
-- Draws the resting progress bar.
-- ------------------------------------------------------------------------------------------------------
Bar.Display = function()
    if Ashita.Menu.Hide() then return nil end
    if Rest.Bar.Auto_Hide and not Status.Is_Resting() then return nil end

    local flags = Bar.Window_Flags
    if Rest.Bar.Position_Locked then flags = bit.bor(flags, ImGuiWindowFlags_NoMove) end
    if not Config.Bar.Show_Background() then flags = bit.bor(flags, ImGuiWindowFlags_NoBackground) end

    -- Handle resetting the window position between characters.
    if Bar.Reset_Position then
        UI.SetNextWindowPos({Rest.Bar.X_Pos, Rest.Bar.Y_Pos}, ImGuiCond_Always)
        Bar.Reset_Position = false
    end
    UI.SetNextWindowSize({Rest.Bar.Width, -1}, ImGuiCond_Always)

    if UI.Begin("Rest", true, flags) then
        Rest.Bar.X_Pos, Rest.Bar.Y_Pos = UI.GetWindowPos()
        Config.Bar.Set_Window_Scale()

        -- Additional Information
        if Config.Bar.Show_Food() then UI.Text(Bar.Food()) end
        if Config.HP.Show_HP() then UI.Text(HP.Display_HP()) end
        if Config.MP.Show_MP() then UI.Text(MP.Display_MP()) end

        -- Progress Bars
        UI.ProgressBar(Ticks.Progress(), {-1, Rest.Bar.Height}, Ticks.Get_Countdown())
        HP.TTF_Bar()
        MP.TTF_Bar()
    end
    UI.End()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the active food.
-- ------------------------------------------------------------------------------------------------------
Bar.Food = function()
    return "Food: " .. Food.Get_Name()
end