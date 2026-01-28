Res = { }

require('resources.food')
require('resources.clear_mind')
require('resources.hmp_items')
require('resources.hhp_items')

-- ------------------------------------------------------------------------------------------------------
-- Returns the HHP/HMP of a food item.
-- ------------------------------------------------------------------------------------------------------
---@param itemID integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.GetFood = function(itemID)
    local default = { name = 'Unknown', hhp = 0, hmp = 0 }

    if not itemID then
        return default
    end

    if not Res.Food[itemID] then
        return default
    end

    return Res.Food[itemID]
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the HMP of an item.
-- ------------------------------------------------------------------------------------------------------
---@param itemID integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Res.EquipHMP = function(itemID)
    if not itemID then
        return 0
    end

    if not Res.HMP.Equip[itemID] then
        return 0
    end

    return Res.HMP.Equip[itemID].hmp
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the HHP of an item.
-- ------------------------------------------------------------------------------------------------------
---@param itemID integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Res.EquipHHP = function(itemID)
    if not itemID then
        return 0
    end

    if not Res.HHP.Equip[itemID] then
        return 0
    end

    return Res.HHP.Equip[itemID].hhp
end
