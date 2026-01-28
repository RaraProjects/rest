Food = { }

Food.Name      = 'Unknown'
Food.HHP_Value = 0
Food.HMP_Value = 0

-- ------------------------------------------------------------------------------------------------------
-- Sets food name value.
-- ------------------------------------------------------------------------------------------------------
---@param name string
-- ------------------------------------------------------------------------------------------------------
local setName = function(name)
    if not name then
        return nil
    end

    Food.Name = name
end

-- ------------------------------------------------------------------------------------------------------
-- Sets food HHP/HMP value.
-- ------------------------------------------------------------------------------------------------------
---@param itemID integer
---@param stats  table
-- ------------------------------------------------------------------------------------------------------
Food.SetHPMP = function(itemID, stats)
    if not itemID or not stats then
        return nil
    end

    if not stats.hhp or not stats.hmp then
        return nil
    end

    Food.HHP_Value = stats.hhp
    Food.HMP_Value = stats.hmp
    setName(stats.name)
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates additional HMP from food.
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Food.GetHPMP = function()
    local hasFood = Ashita.HasBuff(Ashita.Enum.Buffs.FOOD)

    if not hasFood then
        Food.HHP_Value = 0
        Food.HMP_Value = 0
    end

    return { hhp = Food.HHP_Value, hmp = Food.HMP_Value }
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the name for the HMP food.
-- ------------------------------------------------------------------------------------------------------
---@return string
-- ------------------------------------------------------------------------------------------------------
Food.GetName = function()
    local hasFood = Ashita.HasBuff(Ashita.Enum.Buffs.FOOD)

    if not hasFood then
        Food.Name = 'No Food'
    end

    return Food.Name
end
