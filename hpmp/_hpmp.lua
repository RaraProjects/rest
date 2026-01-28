HPMP = { }

HPMP.Enum =
{
    BASE_HHP = 10,
    INC_HHP  = 4,
    BASE_HMP = 12,
    INC_HMP  = 4,   -- Retail: 1
}

HPMP.Column_Widths =
{
    Element = 100,
}

require('hpmp.hp')
require('hpmp.mp')

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much time remains until full HP/MP. This gets called every time there is an HP/MP change.
-- ------------------------------------------------------------------------------------------------------
HPMP.TimeToFull = function()
    local hpNeeded = Ashita.MissingHP()
    local mpNeeded = Ashita.MissingMP()

    if not hpNeeded or not mpNeeded then
        return nil
    end

    local hpp = Ashita.HPP()
    local mpp = Ashita.MPP()

    if not hpp or not mpp then
        return nil
    end

    local hpTime = 0
    local mpTime = 0

    -- Food and Equipment
    local equip = Equipment.HPMP()

    if not equip then
        return nil
    end

    local food = Food.GetHPMP()

    if not food then
        return nil
    end

    -- Only during first tick.
    if not Ticks.IsFirstTick() then
        if hpp < 100 then
            hpTime = hpTime + 20
        end

        if mpp < 100 then
            mpTime = mpTime + 20
        end

        hpNeeded = hpNeeded
                    - HPMP.Enum.BASE_HHP
                    - equip.hhp
                    - food.hhp
        mpNeeded = mpNeeded
                    - ClearMind.BaseHMP()
                    - ClearMind.MP()
                    - equip.hmp
                    - food.hmp
    end

    -- Subsequent ticks if more HP or MP needs to be recovered.
    if hpNeeded < 0 then
        hpNeeded = 0
    end

    if mpNeeded < 0 then
        mpNeeded = 0
    end

    -- Get HP ticks.
    if hpp < 100 then
        local hpTicks = Ticks.GetCurrentTick()

        while hpNeeded > 0 do
            hpTicks  = hpTicks + 1
            hpTime   = hpTime + 10
            hpNeeded = hpNeeded
                        - HPMP.Enum.INC_HHP * hpTicks
                        - equip.hhp
                        - food.hhp
                        - Signet.BaseHP()
                        - Signet.IncHP() * hpTicks
        end
    end

    -- Get MP ticks.
    if mpp < 100 then
        local mpTicks = Ticks.GetCurrentTick()

        while mpNeeded > 0 do
            mpTicks  = mpTicks + 1
            mpTime   = mpTime + 10
            mpNeeded = mpNeeded
                        - ClearMind.BaseHMP()
                        - ClearMind.IncHMP() * mpTicks
                        - ClearMind.MP()
                        - equip.hmp
                        - food.hmp
        end
    end

    HP.TTF = hpTime

    if hpp == 100 then
        HP.TTF_Max = 0
    elseif HP.TTF_Max == 0 then
        HP.TTF_Max = hpTime
    end

    local maxMP = Ashita.MaxMP() or 0

    if maxMP > 0 then
        MP.TTF = mpTime
    end

    if mpp == 100 or mpNeeded == 0 then
        MP.TTF_Max = 0
    elseif MP.TTF_Max == 0 then
        MP.TTF_Max = mpTime
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much HP and MP the player should get on the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
HPMP.NextTick = function()
    local equip = Equipment.HPMP()

    if not equip then
        return { hp = 0, mp = 0 }
    end

    local food = Food.GetHPMP()

    if not food then
        return { hp = 0, mp = 0 }
    end

    local currentTick = Ticks.GetCurrentTick()

    HP.Breakdown.Base             = HPMP.Enum.BASE_HHP
    HP.Breakdown.Increment        = (HPMP.Enum.INC_HHP * currentTick) or 0
    HP.Breakdown.Gear             = equip.hhp or 0
    HP.Breakdown.Food             = food.hhp or 0
    HP.Breakdown.Signet_Base      = Signet.BaseHP()
    HP.Breakdown.Signet_Increment = (Signet.IncHP() * currentTick) or 0

    MP.Breakdown.Base      = ClearMind.BaseHMP()
    MP.Breakdown.Increment = (ClearMind.IncHMP() * currentTick) or 0
    MP.Breakdown.Gear      = equip.hmp or 0
    MP.Breakdown.CM        = ClearMind.MP() or 0
    MP.Breakdown.Food      = food.hmp or 0

    local hpTickAmount = HP.Breakdown.Base + HP.Breakdown.Increment + HP.Breakdown.Gear + HP.Breakdown.Food + HP.Breakdown.Signet_Base + HP.Breakdown.Signet_Increment
    local mpTickAmount = MP.Breakdown.Base + MP.Breakdown.Increment + MP.Breakdown.Gear + MP.Breakdown.CM + MP.Breakdown.Food

    HP.Next = Ashita.CurrentHP() + hpTickAmount
    MP.Next = Ashita.CurrentMP() + mpTickAmount

    return { hp = hpTickAmount, mp = mpTickAmount }
end
