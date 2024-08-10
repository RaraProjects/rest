Food = T{}

Food.Name = "Unknown"
Food.HHP_Value = 0
Food.HMP_Value = 0

-- ------------------------------------------------------------------------------------------------------
-- Sets food HHP/HMP value.
-- ------------------------------------------------------------------------------------------------------
---@param item_id integer
---@param stats table
-- ------------------------------------------------------------------------------------------------------
Food.Set_HPMP = function(item_id, stats)
    if not item_id or not stats then return nil end
    if not stats.hhp or not stats.hmp then return nil end
    Food.HHP_Value = stats.hhp
    Food.HMP_Value = stats.hmp
    Food.Set_Name(stats.name)
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates additional HMP from food.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Food.Get_HPMP = function()
    local has_food = Ashita.Has_Food()
    if not has_food then
        Food.HHP_Value = 0
        Food.HMP_Value = 0
    end
    return {hhp = Food.HHP_Value, hmp = Food.HMP_Value}
end

-- ------------------------------------------------------------------------------------------------------
-- Sets food name value.
-- ------------------------------------------------------------------------------------------------------
---@param name string
-- ------------------------------------------------------------------------------------------------------
Food.Set_Name = function(name)
    if not name then return nil end
    Food.Name = name
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the name for the HMP food.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
Food.Get_Name = function()
    local has_food = Ashita.Has_Food()
    if not has_food then Food.Name = "No Food" end
    return Food.Name
end