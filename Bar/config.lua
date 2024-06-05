Bar.Config  = T{}
Bar.Widgets = T{}

Bar.Config.ALIAS = "bar"
Bar.Config.Defaults = T{
    Width  = 305,
    Height = 20,
    X_Pos  = 100,
    Y_Pos  = 100,
    Position_Locked = false,
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
        Bar.Widgets.Lock_Position()
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

------------------------------------------------------------------------------------------------------
-- Sets rest bar width.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Width = function()
    local width = {[1] = Rest.Bar.Width}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Width", width, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Bar.Width = width[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets rest bar height.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Height = function()
    local height = {[1] = Rest.Bar.Height}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Height", height, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Bar.Height = height[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Window_Scale = function()
    local window_scale = {[1] = Rest.Bar.Window_Scaling}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.7, 3, "%.2f", ImGuiSliderFlags_None) then
        if window_scale[1] < 0.7 then window_scale[1] = 0.7
        elseif window_scale[1] > 3 then window_scale[1] = 3 end
        Rest.Bar.Window_Scaling = window_scale[1]
        Bar.Scaling_Set = false
        Config.Scaling_Set = false
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the background will show.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Lock_Position = function()
    if UI.Checkbox("Lock Position", {Rest.Bar.Position_Locked}) then
        Rest.Bar.Position_Locked = not Rest.Bar.Position_Locked
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the background will show.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Background = function()
    if UI.Checkbox("Show Background", {Rest.Bar.Show_Background}) then
        Rest.Bar.Show_Background = not Rest.Bar.Show_Background
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Show_Countdown = function()
    if UI.Checkbox("Show Countdown", {Rest.Bar.Show_Countdown}) then
        Rest.Bar.Show_Countdown = not Rest.Bar.Show_Countdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the active food shows.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Show_Food = function()
    if UI.Checkbox("Show Food", {Rest.Bar.Show_Food}) then
        Rest.Bar.Show_Food = not Rest.Bar.Show_Food
    end
end