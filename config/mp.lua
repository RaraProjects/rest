Config.MP = T{}

Config.MP.ALIAS = "mp"
Config.MP.Defaults = T{
    Show_MP = true,
    Show_Time_To_Full_Bar = true,
}

------------------------------------------------------------------------------------------------------
-- Toggles showing MP.
------------------------------------------------------------------------------------------------------
Config.MP.Toggle_MP = function()
    Rest.MP.Show_MP = not Rest.MP.Show_MP
end

------------------------------------------------------------------------------------------------------
-- Toggles showing the timer.
------------------------------------------------------------------------------------------------------
Config.MP.Toggle_Time_To_Full_Bar = function()
    Rest.MP.Show_Time_To_Full_Bar = not Rest.MP.Show_Time_To_Full_Bar
end

------------------------------------------------------------------------------------------------------
-- Retrieves the setting for showing the time to full bar for MP.
------------------------------------------------------------------------------------------------------
Config.MP.Show_Time_To_Full_Bar = function()
    return Rest.MP.Show_Time_To_Full_Bar
end

------------------------------------------------------------------------------------------------------
-- Retrieves the show MP setting.
------------------------------------------------------------------------------------------------------
Config.MP.Show_MP = function()
    return Rest.MP.Show_MP
end