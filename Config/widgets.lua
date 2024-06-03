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