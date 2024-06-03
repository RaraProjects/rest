Bar.Widgets = T{}

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
Bar.Widgets.Background = function()
    if UI.Checkbox("Show Background", {Rest.Bar.Show_Background}) then
        Rest.Bar.Show_Background = not Rest.Bar.Show_Background
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Show_Countdown = function()
    if UI.Checkbox("Show Countdown", {Rest.Config.Show_Countdown}) then
        Rest.Config.Show_Countdown = not Rest.Config.Show_Countdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Bar.Widgets.Time_Remaining = function()
    if UI.Checkbox("Show Time Remaining", {Rest.Bar.Show_Time_Remaining}) then
        Rest.Bar.Show_Time_Remaining = not Rest.Bar.Show_Time_Remaining
    end
end