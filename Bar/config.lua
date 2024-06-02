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
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Bar.Config.Set_Window_Scale = function()
    if not Bar.Scaling_Set then
        UI.SetWindowFontScale(Rest.Settings.Bar.Window_Scaling)
        Bar.Scaling_Set = true
    end
end