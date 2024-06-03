Res = T{}

require("resources.clear_mind")
require("resources.hmp_items")

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
-- Returns the HMP of food.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Res.Food_HMP = function(item_id)
    if not item_id then return 0 end
    if not Res.HMP.Food[item_id] then return 0 end
    return Res.HMP.Food[item_id].hmp
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the name of HMP food.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@return string
-- ------------------------------------------------------------------------------------------------------
Res.Food_Name = function(item_id)
    if not item_id then return "None" end
    if not Res.HMP.Food[item_id] then return "None" end
    return Res.HMP.Food[item_id].name
end