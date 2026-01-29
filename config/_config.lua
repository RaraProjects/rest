Config = T{}

Config.Visible = { false }
Config.Window_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav
)

Config.ALIAS = 'config'
Config.Defaults = T{
    X_Pos = 100,
    Y_Pos = 100,
}

Config.Settings                 = { }
Config.Settings.Draggable_Width = 100
Config.Settings.Scaling_Set     = false

Config.Reset_Position           = true

require('config.widgets')
require('config.mp')
require('config.hp')
require('config.bar')

-- ------------------------------------------------------------------------------------------------------
-- Shows configuration options.
-- ------------------------------------------------------------------------------------------------------
local revert = function()
    if UI.BeginTabItem('Revert') then
        Config.Widgets.Revert()
        UI.EndTabItem()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Config.SetWindowScale = function()
    if not Config.Scaling_Set then
        UI.SetWindowFontScale(Rest.Bar.Window_Scaling)
        Config.Scaling_Set = true
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if not Ashita.States.Zoning and Config.Visible[1] then
        -- Handle resetting the window position between characters.
        if Config.Reset_Position then
            UI.SetNextWindowPos({Rest.Config.X_Pos, Rest.Config.Y_Pos}, ImGuiCond_Always)
            Config.Reset_Position = false
        end

        Window.SetScaling()

        if UI.Begin('Rest Settings', Config.Visible, Config.Window_Flags) then
            Rest.Config.X_Pos, Rest.Config.Y_Pos = UI.GetWindowPos()
            Window.SetLegacyScaling()

            HPMP.NextTick()

            if UI.BeginTabBar('Settings Tabs', ImGuiTabBarFlags_None) then
                if UI.BeginTabItem('Info') then
                    UI.Text(Food.GetName())

                    UI.Separator()
                    HP.TickBreakdown()

                    UI.Separator()
                    MP.TickBreakdown()

                    UI.EndTabItem()
                end

                Config.Bar.Populate()
                revert()

                if UI.BeginTabItem('Update') then
                    Version.Populate()

                    UI.EndTabItem()
                end

                UI.EndTabBar()
            end

            Window.SetLegacyScaling(Rest.Bar.Window_Scaling)
            UI.End()
        end

        Window.SetScaling(Rest.Bar.Window_Scaling)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Toggles settings window visibility.
-- ------------------------------------------------------------------------------------------------------
Config.ToggleVisible = function()
    Config.Visible[1] = not Config.Visible[1]
end
