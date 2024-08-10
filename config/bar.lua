Config.Bar  = T{}

Config.Bar.ALIAS = "bar"
Config.Bar.Defaults = T{
    Width  = 305,
    Height = 20,
    X_Pos  = 100,
    Y_Pos  = 100,
    Position_Locked = false,
    Show_Next_Tick = false,
    Show_Countdown = true,
    Show_Background = false,
    Show_Food = true,
    Window_Scaling = 1,
    Auto_Hide = false,
}

------------------------------------------------------------------------------------------------------
-- Populates the bar settings in the settings window.
------------------------------------------------------------------------------------------------------
Config.Bar.Populate = function()
    if UI.BeginTabItem("GUI") then
        UI.Text("Progress Bars")
        Config.Widgets.HP_Progress_Bar()
        Config.Widgets.MP_Progress_Bar()
        Config.Widgets.Next_Tick()
        Config.Widgets.Show_Countdown()
        UI.Separator()
        UI.Text("Additional Info")
        Config.Widgets.Show_Food()
        Config.Widgets.Show_HP()
        Config.Widgets.Show_MP()
        UI.Separator()
        UI.Text("Window Settings")
        Config.Widgets.Auto_Hide()
        Config.Widgets.Background()
        Config.Widgets.Lock_Position()
        UI.Separator()
        Config.Widgets.Width()
        Config.Widgets.Height()
        Config.Widgets.Window_Scale()
        UI.EndTabItem()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Config.Bar.Set_Window_Scale = function()
    if not Bar.Scaling_Set then
        UI.SetWindowFontScale(Rest.Bar.Window_Scaling)
        Bar.Scaling_Set = true
    end
end

------------------------------------------------------------------------------------------------------
-- Returns the bar show next tick setting.
------------------------------------------------------------------------------------------------------
Config.Bar.Show_Next_Tick = function()
    return Rest.Bar.Show_Next_Tick
end

------------------------------------------------------------------------------------------------------
-- Returns the bar tick countdown timer setting.
------------------------------------------------------------------------------------------------------
Config.Bar.Show_Countdown = function()
    return Rest.Bar.Show_Countdown
end

------------------------------------------------------------------------------------------------------
-- Returns the show background setting.
------------------------------------------------------------------------------------------------------
Config.Bar.Show_Background = function()
    return Rest.Bar.Show_Background
end

------------------------------------------------------------------------------------------------------
-- Returns the show food setting.
------------------------------------------------------------------------------------------------------
Config.Bar.Show_Food = function()
    return Rest.Bar.Show_Food
end