Config.Bar  = { }

Config.Bar.ALIAS = 'bar'

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
    if UI.BeginTabItem('GUI') then
        UI.Text('Progress Bars')
        Config.Widgets.HpProgressBar()
        Config.Widgets.MpProgressBar()
        Config.Widgets.NextTick()
        Config.Widgets.ShowCountdown()
        UI.Separator()

        UI.Text('Additional Info')
        Config.Widgets.ShowFood()
        Config.Widgets.ShowHP()
        Config.Widgets.ShowMP()
        UI.Separator()

        UI.Text('Window Settings')
        Config.Widgets.AutoHide()
        Config.Widgets.Background()
        Config.Widgets.LockPosition()
        UI.Separator()

        Config.Widgets.Width()
        Config.Widgets.Height()
        Config.Widgets.WindowScale()

        UI.EndTabItem()
    end
end

------------------------------------------------------------------------------------------------------
-- Returns the bar show next tick setting.
------------------------------------------------------------------------------------------------------
Config.Bar.ShowNextTick = function()
    return Rest.Bar.Show_Next_Tick
end

------------------------------------------------------------------------------------------------------
-- Returns the bar tick countdown timer setting.
------------------------------------------------------------------------------------------------------
Config.Bar.ShowCountdown = function()
    return Rest.Bar.Show_Countdown
end

------------------------------------------------------------------------------------------------------
-- Returns the show background setting.
------------------------------------------------------------------------------------------------------
Config.Bar.ShowBackground = function()
    return Rest.Bar.Show_Background
end

------------------------------------------------------------------------------------------------------
-- Returns the show food setting.
------------------------------------------------------------------------------------------------------
Config.Bar.ShowFood = function()
    return Rest.Bar.Show_Food
end
