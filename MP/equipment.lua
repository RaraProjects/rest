MP.Equipment = T{}

-- ------------------------------------------------------------------------------------------------------
-- Calculates additional HMP from gear.
-- ------------------------------------------------------------------------------------------------------
MP.Equipment.MP = function()
    local additional_hmp = 0
    for slot, _ in pairs(Ashita.Slots) do
        local item_id = Ashita.Equipment(slot)
        if HMP[item_id] then
            additional_hmp = additional_hmp + HMP[item_id]
        end
    end
    return additional_hmp
end