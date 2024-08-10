Res = T{}

require("resources.food")
require("resources.clear_mind")
require("resources.hmp_items")
require("resources.hhp_items")

-- ------------------------------------------------------------------------------------------------------
-- Returns the HHP/HMP of a food item.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Res.Get_Food = function(item_id)
    local default = {name = "Unknown", hhp = 0, hmp = 0}
    if not item_id then return default end
    if not Res.Food[item_id] then return default end
    return Res.Food[item_id]
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the HMP of an item.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Res.Equip_HMP = function(item_id)
    if not item_id then return 0 end
    if not Res.HMP.Equip[item_id] then return 0 end
    return Res.HMP.Equip[item_id].hmp
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the HHP of an item.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Res.Equip_HHP = function(item_id)
    if not item_id then return 0 end
    if not Res.HHP.Equip[item_id] then return 0 end
    return Res.HHP.Equip[item_id].hhp
end