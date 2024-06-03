MP.Widgets = T{}

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