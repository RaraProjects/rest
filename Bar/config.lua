Bar.Config = T{}

Bar.Config.Defaults = T{
    Width  = 305,
    Height = 20,
    X_Pos  = 100,
    Y_Pos  = 100,
    Show_Time_Remaining = true,
    Show_Next_Tick = true,
    Show_Background = false,
    Window_Scaling = 1,
}

------------------------------------------------------------------------------------------------------
-- Populates the bar settings in the settings window.
------------------------------------------------------------------------------------------------------
Bar.Config.Populate = function()
    if UI.BeginTabItem("GUI") then
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
-- Toggles showing the timer.
------------------------------------------------------------------------------------------------------
Bar.Config.Toggle_Timer = function()
    Rest.Bar.Show_Time_Remaining = not Rest.Bar.Show_Time_Remaining
end