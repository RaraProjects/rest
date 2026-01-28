Equipment = { }

-- ------------------------------------------------------------------------------------------------------
-- Calculates additional HMP from gear.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Equipment.HPMP = function()
    local additionalHHP = 0
    local additionalHMP = 0

    for slot, _ in pairs(Ashita.Slots) do
        local itemID = Ashita.Equipment(slot)

        additionalHHP = additionalHHP + Res.EquipHHP(itemID)
        additionalHMP = additionalHMP + Res.EquipHMP(itemID)
    end

    return { hhp = additionalHHP, hmp = additionalHMP }
end
