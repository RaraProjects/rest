Bar = { }

Bar.Window_Flags = bit.bor(
    ImGuiWindowFlags_NoDecoration,
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav
)

Bar.Scaling_Set    = false
Bar.Reset_Position = true

-- ------------------------------------------------------------------------------------------------------
-- Draws the resting progress bar.
-- ------------------------------------------------------------------------------------------------------
Bar.Display = function()
    if Ashita.Menu.Hide() then
        return nil
    end

    if Rest.Bar.Auto_Hide and not Status.IsResting() then
        return nil
    end

    local flags = Bar.Window_Flags

    if Rest.Bar.Position_Locked then
        flags = bit.bor(flags, ImGuiWindowFlags_NoMove)
    end

    if not Config.Bar.ShowBackground() then
        flags = bit.bor(flags, ImGuiWindowFlags_NoBackground)
    end

    -- Handle resetting the window position between characters.
    if Bar.Reset_Position then
        UI.SetNextWindowPos({ Rest.Bar.X_Pos, Rest.Bar.Y_Pos }, ImGuiCond_Always)
        Bar.Reset_Position = false
    end

    UI.SetNextWindowSize({ Rest.Bar.Width, -1 }, ImGuiCond_Always)

    if UI.Begin('Rest', true, flags) then
        Rest.Bar.X_Pos, Rest.Bar.Y_Pos = UI.GetWindowPos()
        Config.Bar.SetWindowScale()

        -- Additional Information
        if Config.Bar.ShowFood() then
            UI.Text(Bar.Food())
        end

        if Config.HP.ShowHP() then
            UI.Text(HP.DisplayHP())
        end

        if Config.MP.ShowMP() then
            UI.Text(MP.DisplayMP())
        end

        -- Progress Bars
        UI.ProgressBar(Ticks.Progress(), {-1, Rest.Bar.Height}, Ticks.GetCountdown())
        HP.TTFbar()
        MP.TTFbar()
        HP.Disclaimer()
    end

    UI.End()
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the active food.
-- ------------------------------------------------------------------------------------------------------
Bar.Food = function()
    return string.format('Food: %s', tostring(Food.GetName()))
end
