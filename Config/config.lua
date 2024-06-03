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
}

Config.Settings = T{}
Config.Settings.Draggable_Width = 100
Config.Settings.Scaling_Set = false

require("Config.widgets")

-- ------------------------------------------------------------------------------------------------------
-- Populates the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if not Ashita.States.Zoning and Config.Visible[1] then
        if UI.Begin("Settings", Config.Visible, Config.Window_Flags) then
            Rest.Config.X_Pos, Rest.Config.Y_Pos = UI.GetWindowPos()
            Config.Set_Window_Scale()
            if UI.BeginTabBar("Settings Tabs", ImGuiTabBarFlags_None) then
                MP.Config.Populate()
                Bar.Config.Populate()
                Config.Revert()
                UI.EndTabBar()
            end
            UI.End()
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows configuration options.
-- ------------------------------------------------------------------------------------------------------
Config.Revert = function()
    if UI.BeginTabItem("Revert") then
        Config.Widgets.Revert()
        UI.EndTabItem()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles settings window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.Toggle_Visible = function()
    Config.Visible[1] = not Config.Visible[1]
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Config.Set_Window_Scale = function()
    if not Config.Scaling_Set then
        UI.SetWindowFontScale(Rest.Bar.Window_Scaling)
        Config.Scaling_Set = true
    end
end