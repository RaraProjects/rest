MP.Config  = T{}
MP.Widgets = T{}

MP.Config.ALIAS = "mp"
MP.Config.Defaults = T{
    Show_Breakdown = false,
    Show_MP = true,
    Show_Next_Tick = true,
    Show_Time_To_Full = true,
    Show_Time_To_Full_Bar = true,
}

------------------------------------------------------------------------------------------------------
-- Populates the MP settings in the settings window.
------------------------------------------------------------------------------------------------------
MP.Config.Populate = function()
    if UI.BeginTabItem("MP") then
        MP.Widgets.Show_MP()
        MP.Widgets.Time_Remaining()
        MP.Widgets.Time_To_Full_Bar()
        MP.Widgets.Next_Tick()
        MP.Widgets.Breakdown()
        UI.EndTabItem()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles showing the breakdown.
------------------------------------------------------------------------------------------------------
MP.Config.Toggle_MP_Breakdown = function()
    Rest.MP.Show_Breakdown = not Rest.MP.Show_Breakdown
end

------------------------------------------------------------------------------------------------------
-- Toggles showing MP.
------------------------------------------------------------------------------------------------------
MP.Config.Toggle_MP = function()
    Rest.MP.Show_MP = not Rest.MP.Show_MP
end

------------------------------------------------------------------------------------------------------
-- Toggles showing the timer.
------------------------------------------------------------------------------------------------------
MP.Config.Toggle_Time_To_Full = function()
    Rest.MP.Show_Time_To_Full = not Rest.MP.Show_Time_To_Full
end

------------------------------------------------------------------------------------------------------
-- Retrieves the setting for showing the timer for MP.
------------------------------------------------------------------------------------------------------
MP.Config.Show_Time_To_Full = function()
    return Rest.MP.Show_Time_To_Full
end

------------------------------------------------------------------------------------------------------
-- Retrieves the setting for showing the time to full bar for MP.
------------------------------------------------------------------------------------------------------
MP.Config.Show_Time_To_Full_Bar = function()
    return Rest.MP.Show_Time_To_Full_Bar
end

------------------------------------------------------------------------------------------------------
-- Retrieves the show MP setting.
------------------------------------------------------------------------------------------------------
MP.Config.Show_MP = function()
    return Rest.MP.Show_MP
end

------------------------------------------------------------------------------------------------------
-- Retrieves the show show next tick setting.
------------------------------------------------------------------------------------------------------
MP.Config.Show_Breakdown = function()
    return Rest.MP.Show_Breakdown
end

------------------------------------------------------------------------------------------------------
-- Retrieves the show show next tick setting.
------------------------------------------------------------------------------------------------------
MP.Config.Show_Next_Tick = function()
    return Rest.MP.Show_Next_Tick
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the next tick gain will show.
------------------------------------------------------------------------------------------------------
MP.Widgets.Next_Tick = function()
    if UI.Checkbox("Show Next Tick", {Rest.MP.Show_Next_Tick}) then
        Rest.MP.Show_Next_Tick = not Rest.MP.Show_Next_Tick
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
MP.Widgets.Show_MP = function()
    if UI.Checkbox("Show MP", {Rest.MP.Show_MP}) then
        Rest.MP.Show_MP = not Rest.MP.Show_MP
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the tick breakdown will show.
------------------------------------------------------------------------------------------------------
MP.Widgets.Breakdown = function()
    if UI.Checkbox("Show Breakdown", {Rest.MP.Show_Breakdown}) then
        Rest.MP.Show_Breakdown = not Rest.MP.Show_Breakdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
MP.Widgets.Time_Remaining = function()
    if UI.Checkbox("Show Time To Full", {Rest.MP.Show_Time_To_Full}) then
        Rest.MP.Show_Time_To_Full = not Rest.MP.Show_Time_To_Full
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the time to full bar shows.
------------------------------------------------------------------------------------------------------
MP.Widgets.Time_To_Full_Bar = function()
    if UI.Checkbox("Show Time To Full Bar", {Rest.MP.Show_Time_To_Full_Bar}) then
        Rest.MP.Show_Time_To_Full_Bar = not Rest.MP.Show_Time_To_Full_Bar
    end
end