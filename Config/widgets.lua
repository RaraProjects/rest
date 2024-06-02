Config.Widgets = T{}

------------------------------------------------------------------------------------------------------
-- Sets rest bar width.
------------------------------------------------------------------------------------------------------
Config.Widgets.Width = function()
    local width = {[1] = Rest.Settings.Bar.Width}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Width", width, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Settings.Bar.Width = width[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets rest bar height.
------------------------------------------------------------------------------------------------------
Config.Widgets.Height = function()
    local height = {[1] = Rest.Settings.Bar.Height}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Height", height, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Settings.Bar.Height = height[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the amount of food HMP.
------------------------------------------------------------------------------------------------------
Config.Widgets.Food = function()
    local height = {[1] = Config.Settings.Food_HMP}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Food HMP", height, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Config.Settings.Food_HMP = height[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles food will be considered in time calculations.
------------------------------------------------------------------------------------------------------
Config.Widgets.Use_Food = function()
    if UI.Checkbox("Use Food", {Rest.Settings.Config.Use_Food}) then
        Rest.Settings.Config.Use_Food = not Rest.Settings.Config.Use_Food
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Show_MP = function()
    if UI.Checkbox("Show MP", {Rest.Settings.Config.Show_MP}) then
        Rest.Settings.Config.Show_MP = not Rest.Settings.Config.Show_MP
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Show_Countdown = function()
    if UI.Checkbox("Show Countdown", {Rest.Settings.Config.Show_Countdown}) then
        Rest.Settings.Config.Show_Countdown = not Rest.Settings.Config.Show_Countdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Time_Remaining = function()
    if UI.Checkbox("Show Time Remaining", {Rest.Settings.Bar.Show_Time_Remaining}) then
        Rest.Settings.Bar.Show_Time_Remaining = not Rest.Settings.Bar.Show_Time_Remaining
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the next tick gain will show.
------------------------------------------------------------------------------------------------------
Config.Widgets.Next_Tick = function()
    if UI.Checkbox("Show Next Tick", {Rest.Settings.Bar.Show_Next_Tick}) then
        Rest.Settings.Bar.Show_Next_Tick = not Rest.Settings.Bar.Show_Next_Tick
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the tick breakdown will show.
------------------------------------------------------------------------------------------------------
Config.Widgets.Breakdown = function()
    if UI.Checkbox("Show Breakdown", {Rest.Settings.Config.Show_Breakdown}) then
        Rest.Settings.Config.Show_Breakdown = not Rest.Settings.Config.Show_Breakdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the background will show.
------------------------------------------------------------------------------------------------------
Config.Widgets.Background = function()
    if UI.Checkbox("Show Background", {Rest.Settings.Bar.Show_Background}) then
        Rest.Settings.Bar.Show_Background = not Rest.Settings.Bar.Show_Background
    end
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
Config.Widgets.Window_Scale = function()
    local window_scale = {[1] = Rest.Settings.Bar.Window_Scaling}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.1, 3, "%.2f", ImGuiSliderFlags_None) then
        Rest.Settings.Bar.Window_Scaling = window_scale[1]
        Bar.Scaling_Set = false
        Config.Scaling_Set = false
    end
end

------------------------------------------------------------------------------------------------------
-- Revert settings to defaults.
------------------------------------------------------------------------------------------------------
Config.Widgets.Revert = function()
    local clicked = 0
    if UI.Button("Revert to Default") then
        clicked = 1
        if clicked and 1 then
            Rest.Settings.Bar.Width  = Bar.Defaults.Width
            Rest.Settings.Bar.Height = Bar.Defaults.Height
            Rest.Settings.Bar.Show_Time_Remaining = Bar.Defaults.Show_Time_Remaining
            Rest.Settings.Bar.Show_Background     = Bar.Defaults.Show_Background
        end
    end
end