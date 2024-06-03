MP.Config = T{}

MP.Config.Defaults = T{
    Show_Breakdown = false,
    Show_MP = true,
    Show_Countdown = true,
}

------------------------------------------------------------------------------------------------------
-- Populates the MP settings in the settings window.
------------------------------------------------------------------------------------------------------
MP.Config.Populate = function()
    if UI.BeginTabItem("MP") then
        MP.Widgets.Show_MP()
        Bar.Widgets.Time_Remaining()
        Bar.Widgets.Show_Countdown()
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
-- Retrieves the show MP setting.
------------------------------------------------------------------------------------------------------
MP.Config.Show_MP = function()
    return Rest.MP.Show_MP
end