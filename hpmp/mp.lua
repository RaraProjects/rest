MP = T{}

-- Horizon HMP Documentation
-- https://horizonffxi.wiki/MP_Recovered_While_Healing
-- https://horizonffxi.wiki/Clear_Mind

-- Retail HMP Documentation
-- https://www.bg-wiki.com/ffxi/Clear_Mind

MP.Breakdown =
{
    Base      = HPMP.Enum.BASE_HMP,
    Increment = 0,
    Bonus     = 0,
    Gear      = 0,
    CM        = 0,
    Food      = 0,
}

MP.Current = 0  -- Current MP
MP.Needed  = 0  -- Missing MP
MP.TTF     = 0  -- Current Time to Full
MP.Next    = 0  -- How much MP we will have after the next tick
MP.TTF_Max = 0  -- Used for the denominator in the MP progress bar. Doesn't reset with each tick. Gets reset on end of resting.

-- ------------------------------------------------------------------------------------------------------
-- Returns how much time is left until we have full MP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
local getTimeToFull = function()
    return MP.TTF
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much MP we will have after the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
local getNextMP = function()
    local nextMP = MP.Next
    local maxMP  = Ashita.MaxMP()

    if nextMP > maxMP then
        nextMP = maxMP
    end

    return nextMP
end

-- ------------------------------------------------------------------------------------------------------
-- Show the Time to Full timer.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
local ttfTimer = function()
    local nextTick = HPMP.NextTick()

    if not nextTick then
        return 'MP: ----'
    end

    local timeRemaining = getTimeToFull() - Ticks.GetDuration()

    if timeRemaining < 0 then
        timeRemaining = 0
    end

    local timeString = Timer.Format(timeRemaining)

    if timeRemaining == 0 then
        timeString = 'FULL'
    end

    if Config.Bar.ShowNextTick() then
        timeString = string.format('%s (+%s)', tostring(timeString), tostring(nextTick.mp))
    end

    return string.format('MP: %s', tostring(timeString))
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
local progress = function()
    if MP.TTF_Max == 0 then
        return 1
    end

    return 1 - ((getTimeToFull() - Ticks.GetDuration()) / MP.TTF_Max)
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP bar.
-- ------------------------------------------------------------------------------------------------------
MP.TTFbar = function()
    if Config.MP.ShowTimeToFullBar() then
        UI.PushStyleColor(ImGuiCol_PlotHistogram, { 0.0, 0.50, 1.0, 1.0 })
        UI.ProgressBar(progress(), { -1, Rest.Bar.Height }, ttfTimer())
        UI.PopStyleColor(1)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Sets MP needed to a new value.
-- ------------------------------------------------------------------------------------------------------
---@param mpNeeded integer
-- ------------------------------------------------------------------------------------------------------
MP.SetMPNeeded = function(mpNeeded)
    MP.Needed = mpNeeded or 0
end

-- ------------------------------------------------------------------------------------------------------
-- Resets time to full MP.
-- ------------------------------------------------------------------------------------------------------
MP.ResetTimeToFull = function()
    MP.TTF = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Creates display string to show current MP.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
MP.DisplayMP = function()
    local header     = 'MP: '
    local currentMP  = Ashita.CurrentMP()
    local nextString = ''
    local maxMP      = Ashita.MaxMP()

    if maxMP > 0 and Status.IsResting() and Config.Bar.ShowNextTick() then
        local nextMP  = getNextMP()
        local nextMPP = math.ceil((nextMP / maxMP) * 100)

        nextString = string.format(' -> %d (%d%%)', tostring(nextMP), tostring(nextMPP))
    end

    return  string.format('%s%d%s', tostring(header), tostring(currentMP), tostring(nextString))
end

-- ------------------------------------------------------------------------------------------------------
-- Show the breakdown of the tick.
-- ------------------------------------------------------------------------------------------------------
MP.TickBreakdown = function()
    local tickBonus  = string.format('%s*%s', tostring(ClearMind.IncHMP()), tostring(Ticks.GetCurrentTick()))
    local cmRank     = ClearMind.Rank()
    local tableFlags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)
    local colFlags   = bit.bor(ImGuiTableColumnFlags_None)
    local colWidth   = HPMP.Column_Widths.Element

    if UI.BeginTable('MP Breakdown', 3, tableFlags) then
        UI.TableSetupColumn('MP',    colFlags, colWidth)
        UI.TableSetupColumn('Value', colFlags)
        UI.TableSetupColumn('Note',  colFlags)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text('Base HMP')
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Base))
        UI.TableNextColumn()

        UI.TableNextColumn() UI.Text('Tick Bonus')
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Increment))
        UI.TableNextColumn() UI.Text(tickBonus)

        UI.TableNextColumn() UI.Text('Clear Mind')
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.CM))
        UI.TableNextColumn() UI.Text(ClearMind.DisplayRank(cmRank))

        UI.TableNextColumn() UI.Text('Gear Bonus')
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Gear))
        UI.TableNextColumn()

        UI.TableNextColumn() UI.Text('Food Bonus')
        UI.TableNextColumn() UI.Text(tostring(MP.Breakdown.Food))
        UI.TableNextColumn()

        UI.EndTable()
    end
end
