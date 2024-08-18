Signet = T{}

-- Horizon Signet Documentation
-- https://horizonffxi.wiki/Signet

Signet.Base_Rate = 3


HP.HP_Division = 300
HP.Division_Max = 4

-- ------------------------------------------------------------------------------------------------------
-- Gets base HHP bonus from signet.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Signet.Base_HP = function()
    local bonus = 0
    local has_signet = Ashita.Has_Buff(Ashita.Enum.Buffs.SIGNET)
    if has_signet then
        bonus = Signet.Base_Rate * math.floor(Ashita.Job_Level() / 10)
    end
    return bonus
end

-- ------------------------------------------------------------------------------------------------------
-- Gets incremental HHP bonus from signet.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Signet.Inc_HP = function()
    local bonus = 0
    local has_signet = Ashita.Has_Buff(Ashita.Enum.Buffs.SIGNET)
    if has_signet then
        bonus = 1 + math.floor(Ashita.Max_HP() / 300)
        if bonus > 5 then bonus = 5 end
    end
    return bonus
end