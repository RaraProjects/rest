Signet = { }

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
Signet.BaseHP = function()
    local bonus     = 0
    local hasSignet = Ashita.HasBuff(Ashita.Enum.Buffs.SIGNET)

    if hasSignet then
        bonus = Signet.Base_Rate * math.floor(Ashita.JobLevel() / 10)
    end

    return bonus
end

-- ------------------------------------------------------------------------------------------------------
-- Gets incremental HHP bonus from signet.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Signet.IncHP = function()
    local bonus = 0
    local hasSignet = Ashita.HasBuff(Ashita.Enum.Buffs.SIGNET)

    if hasSignet then
        bonus = 1 + math.floor(Ashita.MaxHP() / 300)

        if bonus > 5 then
            bonus = 5
        end
    end

    return bonus
end
