Window = { }

Window.Window_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav
)

Window.Tab_Flags = ImGuiTabBarFlags_None

Window.Colors =
{
    WHITE    = { 1.0,  1.0,  1.0,  1.0  },
    BLACK    = { 0.0,  0.0,  0.0,  1.0  },
    RED      = { 1.0,  0.2,  0.2,  1.0  },
    ORANGE   = { 0.9,  0.6,  0.0,  1.0  },
    YELLOW   = { 0.9,  1.0,  0.0,  1.0  },
    DIM      = { 0.4,  0.4,  0.4,  1.0  },
    DEFAULT  = { 0.18, 0.20, 0.23, 0.96 },
    INACTIVE = { 0.4,  0.4,  0.4,  1.0  },
}

Window.IO = UI.GetIO()

Window.Draw       = { }
Window.Draw.Modes =
{
    LEGACY = 0,
    BETA   = 1,
}
Window.Draw.CurrentMode = Window.Draw.Modes.LEGACY

------------------------------------------------------------------------------------------------------
-- Returns the draw mode.
------------------------------------------------------------------------------------------------------
---@return integer
------------------------------------------------------------------------------------------------------
Window.GetDrawMode = function()
    return Window.Draw.CurrentMode
end

------------------------------------------------------------------------------------------------------
-- Checks whether this is 4.2.0.1+ or not.
------------------------------------------------------------------------------------------------------
Window.SetDrawMode = function()
    if UI.GetStyle then
        local style = UI.GetStyle()

        -- Ashita 4.2.0.1+
        if style and style.FontScaleMain ~= nil then
            Window.Draw.CurrentMode = Window.Draw.Modes.BETA
        elseif Window.IO and Window.IO.FontGlobalScale ~= nil then
            Window.Draw.CurrentMode = Window.Draw.Modes.LEGACY
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Gets the window scaling.
------------------------------------------------------------------------------------------------------
Window.GetScaling = function()
    if UI.GetStyle then
        local style = UI.GetStyle()

        -- Ashita 4.2.0.1+
        if style and style.FontScaleMain ~= nil then
            return style.FontScaleMain
        end

        -- Ashita Legacy
        if Window.IO and Window.IO.FontGlobalScale ~= nil then
            return Window.IO.FontGlobalScale
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling for Ashita 4.2.0.1+.
------------------------------------------------------------------------------------------------------
---@param scale? number
------------------------------------------------------------------------------------------------------
Window.SetScaling = function(scale)
    if Window.GetDrawMode() == Window.Draw.Modes.BETA then
        if UI.GetStyle then
            local style = UI.GetStyle()

            if style and style.FontScaleMain ~= nil then
                style.FontScaleMain = scale or Rest.Bar.Window_Scaling or 1
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling for legacy Ashita.
------------------------------------------------------------------------------------------------------
---@param scale? number
------------------------------------------------------------------------------------------------------
Window.SetLegacyScaling = function(scale)
    if Window.GetDrawMode() == Window.Draw.Modes.LEGACY then
        UI.SetWindowFontScale(scale or Rest.Bar.Window_Scaling or 1)
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the table row color.
------------------------------------------------------------------------------------------------------
---@param row integer
------------------------------------------------------------------------------------------------------
Window.TableRowColor = function(row)
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBg)

    if (row % 2) == 0 then
        x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableRowBgAlt)
    end

    local rowColor = UI.GetColorU32({ x, y, z, w })

    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, rowColor)
end