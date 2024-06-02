Config = T{}

Config.Visible = {false}
Config.Window_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav,
    ImGuiWindowFlags_NoTitleBar)

Config.Defaults = T{
    X_Pos = 100,
    Y_Pos = 100,
    Use_Food = false,
    Show_Breakdown = false,
    Show_MP = true,
    Show_Countdown = true,
}

Config.Settings = T{}
Config.Settings.Draggable_Width = 100
Config.Settings.Food_HMP = 0            -- This won't get saved between settings.
Config.Settings.Scaling_Set = false

require("Config.widgets")

-- ------------------------------------------------------------------------------------------------------
-- Populates the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if not Ashita.States.Zoning and Config.Visible[1] then
        if UI.Begin("Settings", Config.Visible, Config.Window_Flags) then
            Rest.Settings.Config.X_Pos, Rest.Settings.Config.Y_Pos = UI.GetWindowPos()
            Config.Set_Window_Scale()
            if UI.BeginTabBar("Settings Tabs", ImGuiTabBarFlags_None) then
                if UI.BeginTabItem("MP") then
                    Config.Options()
                    UI.EndTabItem()
                end
                UI.EndTabBar()
            end
            UI.End()
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows configuration options.
-- ------------------------------------------------------------------------------------------------------
Config.Options = function()
    Config.Widgets.Use_Food()
    if Rest.Settings.Config.Use_Food then Config.Widgets.Food() end
    Config.Widgets.Show_MP()
    Config.Widgets.Time_Remaining()
    Config.Widgets.Show_Countdown()
    Config.Widgets.Next_Tick()
    Config.Widgets.Breakdown()
    Config.Widgets.Background()
    Config.Widgets.Width()
    Config.Widgets.Height()
    Config.Widgets.Window_Scale()
    Config.Widgets.Revert()
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Config.Set_Window_Scale = function()
    if not Config.Scaling_Set then
        UI.SetWindowFontScale(Rest.Settings.Bar.Window_Scaling)
        Config.Scaling_Set = true
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles showing the breakdown.
------------------------------------------------------------------------------------------------------
Config.Toggle_MP_Breakdown = function()
    Rest.Settings.Config.Show_Breakdown = not Rest.Settings.Config.Show_Breakdown
end

------------------------------------------------------------------------------------------------------
-- Toggles showing MP.
------------------------------------------------------------------------------------------------------
Config.Toggle_MP = function()
    Rest.Settings.Config.Show_MP = not Rest.Settings.Config.Show_MP
end

------------------------------------------------------------------------------------------------------
-- Toggles showing the timer.
------------------------------------------------------------------------------------------------------
Config.Toggle_Timer = function()
    Rest.Settings.Bar.Show_Time_Remaining = not Rest.Settings.Bar.Show_Time_Remaining
end