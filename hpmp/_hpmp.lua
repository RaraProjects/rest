HPMP = T{}

HPMP.Enum = T{
    BASE_HHP = 10,
    INC_HHP  = 4,
    BASE_HMP = 12,
    INC_HMP  = 4,   -- Retail: 1
}

HPMP.Column_Widths = T{
    Element = 100,
}

require("hpmp.hp")
require("hpmp.mp")

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much time remains until full HP/MP. This gets called every time there is an HP/MP change.
-- ------------------------------------------------------------------------------------------------------
HPMP.Time_To_Full = function()
    local hp_needed = Ashita.Missing_HP()
    local mp_needed = Ashita.Missing_MP()
    if not hp_needed or not mp_needed then return nil end

    local hpp = Ashita.HPP()
    local mpp = Ashita.MPP()
    if not hpp or not mpp then return nil end

    local hp_time = 0
    local mp_time = 0

    -- Food and Equipment
    local equip = Equipment.HPMP()
    if not equip then return nil end
    local food = Food.Get_HPMP()
    if not food then return nil end

    -- Only during first tick.
    if not Ticks.Is_First_Tick() then
        if hpp < 100 then hp_time = hp_time + 20 end
        if mpp < 100 then mp_time = mp_time + 20 end
        hp_needed = hp_needed
                    - HPMP.Enum.BASE_HHP
                    - equip.hhp
                    - food.hhp
        mp_needed = mp_needed
                    - Clear_Mind.Base_HMP()
                    - Clear_Mind.MP()
                    - equip.hmp
                    - food.hmp
    end

    -- Subsequent ticks if more HP or MP needs to be recovered.
    if hp_needed < 0 then hp_needed = 0 end
    if mp_needed < 0 then mp_needed = 0 end

    -- Get HP ticks.
    if hpp < 100 then
        local hp_ticks = Ticks.Get_Current_Tick()
        while hp_needed > 0 do
            hp_ticks = hp_ticks + 1
            hp_time = hp_time + 10
            hp_needed = hp_needed
                        - HPMP.Enum.INC_HHP * hp_ticks
                        - equip.hhp
                        - food.hhp
                        - Signet.Base_HP()
                        - Signet.Inc_HP() * hp_ticks
        end
    end

    -- Get MP ticks.
    if mpp < 100 then
        local mp_ticks = Ticks.Get_Current_Tick()
        while mp_needed > 0 do
            mp_ticks = mp_ticks + 1
            mp_time = mp_time + 10
            mp_needed = mp_needed
                        - Clear_Mind.Base_HMP()
                        - Clear_Mind.Inc_HMP() * mp_ticks
                        - Clear_Mind.MP()
                        - equip.hmp
                        - food.hmp
        end
    end

    HP.TTF = hp_time
    if hpp == 100 then
        HP.TTF_Max = 0
    elseif HP.TTF_Max == 0 then
        HP.TTF_Max = hp_time
    end

    local max_mp = Ashita.Max_MP()
    if not max_mp then max_mp = 0 end

    if max_mp > 0 then MP.TTF = mp_time end
    if mpp == 100 or mp_needed == 0 then
        MP.TTF_Max = 0
    elseif MP.TTF_Max == 0 then
        MP.TTF_Max = mp_time
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much HP and MP the player should get on the next tick.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
HPMP.Next_Tick = function()
    local equip = Equipment.HPMP()
    if not equip then return {hp = 0, mp = 0} end

    local food = Food.Get_HPMP()
    if not food then return {hp = 0, mp = 0} end

    local current_tick = Ticks.Get_Current_Tick()

    HP.Breakdown.Base = HPMP.Enum.BASE_HHP
    HP.Breakdown.Increment = (HPMP.Enum.INC_HHP * current_tick) or 0
    HP.Breakdown.Gear = equip.hhp or 0
    HP.Breakdown.Food = food.hhp or 0
    HP.Breakdown.Signet_Base = Signet.Base_HP()
    HP.Breakdown.Signet_Increment = (Signet.Inc_HP() * current_tick) or 0

    MP.Breakdown.Base = Clear_Mind.Base_HMP()
    MP.Breakdown.Increment = (Clear_Mind.Inc_HMP() * current_tick) or 0
    MP.Breakdown.Gear = equip.hmp or 0
    MP.Breakdown.CM = Clear_Mind.MP() or 0
    MP.Breakdown.Food = food.hmp or 0

    local hp_tick_amount = HP.Breakdown.Base + HP.Breakdown.Increment + HP.Breakdown.Gear + HP.Breakdown.Food + HP.Breakdown.Signet_Base + HP.Breakdown.Signet_Increment
    local mp_tick_amount = MP.Breakdown.Base + MP.Breakdown.Increment + MP.Breakdown.Gear + MP.Breakdown.CM + MP.Breakdown.Food

    HP.Next = Ashita.Current_HP() + hp_tick_amount
    MP.Next = Ashita.Current_MP() + mp_tick_amount

    return {hp = hp_tick_amount, mp = mp_tick_amount}
end