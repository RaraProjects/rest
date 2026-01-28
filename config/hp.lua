Config.HP = { }

Config.HP.ALIAS = 'hp'

Config.HP.Defaults = T{
    Show_HP = true,
    Show_Time_To_Full_Bar = true,
    TTF_Calc_Disclaimer = false,             -- false = not acknowledged
}

------------------------------------------------------------------------------------------------------
-- Toggles showing HP.
------------------------------------------------------------------------------------------------------
Config.HP.ToggleHP = function()
    Rest.HP.Show_HP = not Rest.HP.Show_HP
end

------------------------------------------------------------------------------------------------------
-- Toggles showing the timer.
------------------------------------------------------------------------------------------------------
Config.HP.ToggleTimeToFullBar = function()
    Rest.HP.Show_Time_To_Full = not Rest.HP.Show_Time_To_Full
end

------------------------------------------------------------------------------------------------------
-- Retrieves the setting for showing the time to full bar for HP.
------------------------------------------------------------------------------------------------------
Config.HP.ShowTimeToFullBar = function()
    return Rest.HP.Show_Time_To_Full_Bar
end

------------------------------------------------------------------------------------------------------
-- Retrieves the show HP setting.
------------------------------------------------------------------------------------------------------
Config.HP.ShowHP = function()
    return Rest.HP.Show_HP
end
