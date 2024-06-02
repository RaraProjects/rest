Config = T{}

Config.Visible = false
Config.Window_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav,
    ImGuiWindowFlags_NoTitleBar)

Config.Defaults = T{
    X_Pos = 100,
    Y_Pos = 100,
    Use_Food = false,
    Show_Breakdown = false,
    Show_MP = true,
}

Config.Settings = T{}
Config.Settings.Draggable_Width = 150
Config.Settings.Food_HMP = 0            -- This won't get saved between settings.

-- ------------------------------------------------------------------------------------------------------
-- Populates the configuration window.
-- ------------------------------------------------------------------------------------------------------
Config.Display = function()
    if not Ashita.States.Zoning and Config.Visible then
        if UI.Begin("Settings", {Config.Visible}, Config.Window_Flags) then
            Rest.Settings.Config.X_Pos, Rest.Settings.Config.Y_Pos = UI.GetWindowPos()
            if UI.BeginTabBar("Settings Tabs", ImGuiTabBarFlags_None) then
                if UI.BeginTabItem("MP") then
                    Config.Options()
                    UI.EndTabItem()
                end
                UI.EndTabBar()
            end
            UI.End()
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows configuration options.
-- ------------------------------------------------------------------------------------------------------
Config.Options = function()
    Config.Settings.Use_Food()
    if Rest.Settings.Config.Use_Food then Config.Settings.Food() end
    Config.Settings.Show_MP()
    Config.Settings.Time_Remaining()
    Config.Settings.Next_Tick()
    Config.Settings.Breakdown()
    Config.Settings.MP_Needed()
    Config.Settings.Background()
    Config.Settings.Width()
    Config.Settings.Height()
    Config.Settings.Revert()
end

------------------------------------------------------------------------------------------------------
-- Sets rest bar width.
------------------------------------------------------------------------------------------------------
Config.Settings.Width = function()
    local width = {[1] = Rest.Settings.Bar.Width}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Width", width, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Settings.Bar.Width = width[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets rest bar height.
------------------------------------------------------------------------------------------------------
Config.Settings.Height = function()
    local height = {[1] = Rest.Settings.Bar.Height}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Height", height, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Rest.Settings.Bar.Height = height[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the amount of food HMP.
------------------------------------------------------------------------------------------------------
Config.Settings.Food = function()
    local height = {[1] = Config.Settings.Food_HMP}
    UI.SetNextItemWidth(Config.Settings.Draggable_Width)
    if UI.DragInt("Food HMP", height, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Config.Settings.Food_HMP = height[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles food will be considered in time calculations.
------------------------------------------------------------------------------------------------------
Config.Settings.Use_Food = function()
    if UI.Checkbox("Use Food", {Rest.Settings.Config.Use_Food}) then
        Rest.Settings.Config.Use_Food = not Rest.Settings.Config.Use_Food
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Config.Settings.Show_MP = function()
    if UI.Checkbox("Show MP", {Rest.Settings.Config.Show_MP}) then
        Rest.Settings.Config.Show_MP = not Rest.Settings.Config.Show_MP
    end
end


------------------------------------------------------------------------------------------------------
-- Toggles whether time remaining clock shows.
------------------------------------------------------------------------------------------------------
Config.Settings.Time_Remaining = function()
    if UI.Checkbox("Show Time Remaining", {Rest.Settings.Bar.Show_Time_Remaining}) then
        Rest.Settings.Bar.Show_Time_Remaining = not Rest.Settings.Bar.Show_Time_Remaining
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether remaining MP needed will show.
------------------------------------------------------------------------------------------------------
Config.Settings.MP_Needed = function()
    if UI.Checkbox("Show MP Remaining", {Rest.Settings.Bar.Show_MP_Needed}) then
        Rest.Settings.Bar.Show_MP_Needed = not Rest.Settings.Bar.Show_MP_Needed
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the next tick gain will show.
------------------------------------------------------------------------------------------------------
Config.Settings.Next_Tick = function()
    if UI.Checkbox("Show Next Tick", {Rest.Settings.Bar.Show_Next_Tick}) then
        Rest.Settings.Bar.Show_Next_Tick = not Rest.Settings.Bar.Show_Next_Tick
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the tick breakdown will show.
------------------------------------------------------------------------------------------------------
Config.Settings.Breakdown = function()
    if UI.Checkbox("Show Breakdown", {Rest.Settings.Config.Show_Breakdown}) then
        Rest.Settings.Config.Show_Breakdown = not Rest.Settings.Config.Show_Breakdown
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles whether the background will show.
------------------------------------------------------------------------------------------------------
Config.Settings.Background = function()
    if UI.Checkbox("Show Background", {Rest.Settings.Bar.Show_Background}) then
        Rest.Settings.Bar.Show_Background = not Rest.Settings.Bar.Show_Background
    end
end

------------------------------------------------------------------------------------------------------
-- Revert settings to defaults.
------------------------------------------------------------------------------------------------------
Config.Settings.Revert = function()
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