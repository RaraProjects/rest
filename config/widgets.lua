Config.Widgets = T{}

------------------------------------------------------------------------------------------------------
-- Revert settings to defaults.
------------------------------------------------------------------------------------------------------
Config.Widgets.Revert = function()
    local clicked = 0
    if UI.Button("Revert to Default") then
        clicked = 1
        if clicked and 1 then
            Rest.Bar.Width  = Bar.Defaults.Width
            Rest.Bar.Height = Bar.Defaults.Height
            Rest.MP.Show_Time_To_Full = Bar.MP.Show_Time_Remaining
            Rest.Bar.Show_Background     = Bar.Defaults.Show_Background
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a help text marker.
------------------------------------------------------------------------------------------------------
Config.Widgets.HelpMarker = function(text)
    UI.SameLine()
    UI.TextDisabled("(?)")
    if UI.IsItemHovered() then
        UI.BeginTooltip()
        UI.PushTextWrapPos(UI.GetFontSize() * 25)
        UI.TextUnformatted(text)
        UI.PopTextWrapPos()
        UI.EndTooltip()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets rest bar width.
------------------------------------------------------------------------------------------------------
Config.Widgets.Width = function()
    local width = {[1] = Rest.Bar.Width}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Width", width, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Bar.Width = width[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets rest bar height.
------------------------------------------------------------------------------------------------------
Config.Widgets.Height = function()
    local height = {[1] = Rest.Bar.Height}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Height", height, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Bar.Height = height[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
Config.Widgets.Window_Scale = function()
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
-- Toggles whether the HP progress bar shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.HP_Progress_Bar = function()
    if UI.Checkbox("HP Progress Bar", {Rest.HP.Show_Time_To_Full_Bar}) then
        Rest.HP.Show_Time_To_Full_Bar = not Rest.HP.Show_Time_To_Full_Bar
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the MP progress bar shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.MP_Progress_Bar = function()
    if UI.Checkbox("MP Progress Bar", {Rest.MP.Show_Time_To_Full_Bar}) then
        Rest.MP.Show_Time_To_Full_Bar = not Rest.MP.Show_Time_To_Full_Bar
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the next tick gain will show.
------------------------------------------------------------------------------------------------------
Config.Widgets.Next_Tick = function()
    if UI.Checkbox("Next Tick Amount", {Rest.Bar.Show_Next_Tick}) then
        Rest.Bar.Show_Next_Tick = not Rest.Bar.Show_Next_Tick
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Show_Countdown = function()
    if UI.Checkbox("Tick Countdown", {Rest.Bar.Show_Countdown}) then
        Rest.Bar.Show_Countdown = not Rest.Bar.Show_Countdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the active food shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Show_Food = function()
    if UI.Checkbox("Show Food", {Rest.Bar.Show_Food}) then
        Rest.Bar.Show_Food = not Rest.Bar.Show_Food
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the HP -> New HP line shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Show_HP = function()
    if UI.Checkbox("Raw HP Gains", {Rest.HP.Show_HP}) then
        Rest.HP.Show_HP = not Rest.HP.Show_HP
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the MP -> New MP line shows.
------------------------------------------------------------------------------------------------------
Config.Widgets.Show_MP = function()
    if UI.Checkbox("Raw MP Gains", {Rest.MP.Show_MP}) then
        Rest.MP.Show_MP = not Rest.MP.Show_MP
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the rest bar auto hides when not resting.
------------------------------------------------------------------------------------------------------
Config.Widgets.Auto_Hide = function()
    if UI.Checkbox("Auto Hide", {Rest.Bar.Auto_Hide}) then
        Rest.Bar.Auto_Hide = not Rest.Bar.Auto_Hide
    end
    Config.Widgets.HelpMarker("The rest bar will hide automatically when not resting.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the background will show.
------------------------------------------------------------------------------------------------------
Config.Widgets.Background = function()
    if UI.Checkbox("Show Background", {Rest.Bar.Show_Background}) then
        Rest.Bar.Show_Background = not Rest.Bar.Show_Background
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the background will show.
------------------------------------------------------------------------------------------------------
Config.Widgets.Lock_Position = function()
    if UI.Checkbox("Lock Position", {Rest.Bar.Position_Locked}) then
        Rest.Bar.Position_Locked = not Rest.Bar.Position_Locked
    end
end