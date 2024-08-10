Equipment = T{}

-- ------------------------------------------------------------------------------------------------------
-- Calculates additional HMP from gear.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Equipment.HPMP = function()
    local additional_hhp = 0
    local additional_hmp = 0
    for slot, _ in pairs(Ashita.Slots) do
        local item_id = Ashita.Equipment(slot)
        additional_hhp = additional_hhp + Res.Equip_HHP(item_id)
        additional_hmp = additional_hmp + Res.Equip_HMP(item_id)
    end
    return {hhp = additional_hhp, hmp = additional_hmp}
end