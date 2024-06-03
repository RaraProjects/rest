Bar.Config = T{}

Bar.Config.Defaults = T{
    Width  = 305,
    Height = 20,
    X_Pos  = 100,
    Y_Pos  = 100,
    Show_Countdown = true,
    Show_Background = false,
    Show_Food = true,
    Window_Scaling = 1,
}

------------------------------------------------------------------------------------------------------
-- Populates the bar settings in the settings window.
------------------------------------------------------------------------------------------------------
Bar.Config.Populate = function()
    if UI.BeginTabItem("GUI") then
        Bar.Widgets.Show_Food()
        Bar.Widgets.Show_Countdown()
        Bar.Widgets.Background()
        UI.Separator()
        Bar.Widgets.Width()
        Bar.Widgets.Height()
        Bar.Widgets.Window_Scale()
        UI.EndTabItem()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Bar.Config.Set_Window_Scale = function()
    if not Bar.Scaling_Set then
        UI.SetWindowFontScale(Rest.Bar.Window_Scaling)
        Bar.Scaling_Set = true
    end
end

------------------------------------------------------------------------------------------------------
-- Returns the bar tick countdown timer setting.
------------------------------------------------------------------------------------------------------
Bar.Config.Show_Countdown = function()
    return Rest.Bar.Show_Countdown
end

------------------------------------------------------------------------------------------------------
-- Returns the show background setting.
------------------------------------------------------------------------------------------------------
Bar.Config.Show_Background = function()
    return Rest.Bar.Show_Background
end

------------------------------------------------------------------------------------------------------
-- Returns the show food setting.
------------------------------------------------------------------------------------------------------
Bar.Config.Show_Food = function()
    return Rest.Bar.Show_Food
end