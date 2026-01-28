HP = { }

-- Horizon HMP Documentation
-- https://horizonffxi.wiki/HP_Recovered_While_Healing

HP.Breakdown =
{
    Base             = HPMP.Enum.BASE_HHP,
    Increment        = 0,
    Gear             = 0,
    Food             = 0,
    Signet_Base      = 0,
    Signet_Increment = 0,
}

HP.Current = 0  -- Current HP
HP.Needed  = 0  -- Missing HP
HP.TTF     = 0  -- Current Time to Full
HP.Next    = 0  -- How much HP we will have after the next tick
HP.TTF_Max = 0  -- Used for the denominator in the MP progress bar. Doesn't reset with each tick. Gets reset on end of resting.

-- ------------------------------------------------------------------------------------------------------
-- Sets HP needed to a new value.
-- ------------------------------------------------------------------------------------------------------
---@param hpNeeded integer
-- ------------------------------------------------------------------------------------------------------
local setHpNeeded = function(hpNeeded)
    HP.Needed = hpNeeded or 0
end

-- ------------------------------------------------------------------------------------------------------
-- Resets time to full HP.
-- ------------------------------------------------------------------------------------------------------
local resetTimeToFull = function()
    HP.TTF = 0
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the HP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
local barHpLine = function()
    if Config.HP.ShowBreakdown() then HP.TickBreakdown() end
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much time is left until we have full HP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
local getTimeToFull = function()
    return HP.TTF
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much HP we will have after the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
local getNextHP = function()
    local nextHP = HP.Next
    local maxHP  = Ashita.MaxHP()

    if nextHP > maxHP then
        nextHP = maxHP
    end

    return nextHP
end

-- ------------------------------------------------------------------------------------------------------
-- Show the Time to Full timer.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
local ttfTimer = function()
    local nextTick = HPMP.NextTick()

    if not nextTick then
        return 'HP: ----'
    end

    local timeRemaining = getTimeToFull() - Ticks.GetDuration()

    if timeRemaining < 0 then
        timeRemaining = 0
    end

    local asterisk   = true
    local timeString = Timer.Format(timeRemaining)

    if timeRemaining == 0 then
        timeString = 'FULL'
        asterisk   = false
    end

    if asterisk then
        timeString = string.format('%s*', tostring(timeString))
    end

    if Config.Bar.ShowNextTick() then
        timeString = string.format('%s (+%d*)', tostring(timeString), tostring(nextTick.hp))
    end

    return timeString
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the HP line from under the bar.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
local progress = function()
    if HP.TTF_Max == 0 then
        return 1
    end

    return 1 - ((getTimeToFull() - Ticks.GetDuration()) / HP.TTF_Max)
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the MP bar.
-- ------------------------------------------------------------------------------------------------------
HP.TTFbar = function()
    if Config.HP.ShowTimeToFullBar() then
        UI.ProgressBar(progress(), { -1, Rest.Bar.Height }, ttfTimer())
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Creates display string to show current HP.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
HP.DisplayHP = function()
    local header     = 'HP: '
    local currentHP  = Ashita.CurrentHP()
    local nextString = ''

    if Status.IsResting() and Rest.HP.Show_Next_Tick then
        local nextHP  = getNextHP()
        local maxHP   = Ashita.MaxHP()
        local nextHPP = math.ceil((nextHP / maxHP) * 100)

        nextString = string.format(' -> %d (%d%%)', tostring(nextHP), tostring(nextHPP))
    end

    return string.format('%s%d%s', tostring(header), tostring(currentHP), tostring(nextString))
end

-- ------------------------------------------------------------------------------------------------------
-- Show the breakdown of the tick.
-- ------------------------------------------------------------------------------------------------------
HP.TickBreakdown = function()
    local currentTick = tostring(Ticks.GetCurrentTick())
    local tickBonus   = string.format('%s*%s', tostring(HPMP.Enum.INC_HHP), tostring(currentTick))
    local signetTick  = string.format('%s*%s', tostring(Signet.IncHP()), tostring(currentTick))

    local tableFlags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)
    local colFlags   = bit.bor(ImGuiTableColumnFlags_None)
    local colWidth   = HPMP.Column_Widths.Element

    if UI.BeginTable('HP Breakdown', 3, tableFlags) then
        UI.TableSetupColumn('HP',    colFlags, colWidth)
        UI.TableSetupColumn('Value', colFlags)
        UI.TableSetupColumn('Notes', colFlags)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text('Base HHP')
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Base))
        UI.TableNextColumn()

        UI.TableNextColumn() UI.Text('Tick Bonus')
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Increment))
        UI.TableNextColumn() UI.Text(tickBonus)

        UI.TableNextColumn() UI.Text('Gear Bonus')
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Gear))
        UI.TableNextColumn()

        UI.TableNextColumn() UI.Text('Food Bonus')
        UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Food))
        UI.TableNextColumn()

        if Ashita.HasBuff(Ashita.Enum.Buffs.SIGNET) then
            UI.TableNextColumn() UI.Text('Signet Base*')
            UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Signet_Base))
            UI.TableNextColumn()

            UI.TableNextColumn() UI.Text('Signet Tick*')
            UI.TableNextColumn() UI.Text(tostring(HP.Breakdown.Signet_Increment))
            UI.TableNextColumn() UI.Text(signetTick)
        end

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the HP calculation disclaimer.
-- ------------------------------------------------------------------------------------------------------
HP.Disclaimer = function()
    if not Rest.HP.TTF_Calc_Disclaimer then
        UI.Text('*HP calculation incomplete.')
        if UI.SmallButton('Dismiss') then
            Rest.HP.TTF_Calc_Disclaimer = true
        end
    end
end
