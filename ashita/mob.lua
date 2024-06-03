Ashita.Mob = T{}

-- ------------------------------------------------------------------------------------------------------
-- Get an index from a mob ID. I got this from WinterSolstice8's parse lua.
-- Parse: https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
---@param id number
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.Index_By_ID = function(id)
    local index = bit.band(id, 0x7FF)
    local entity_manager = AshitaCore:GetMemoryManager():GetEntity()
    if entity_manager:GetServerId(index) == id then return index end
    for i = 1, 2303 do
        if entity_manager:GetServerId(i) == id then return i end
    end
    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- ------------------------------------------------------------------------------------------------------
---@param id number
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.Get_Mob_By_ID = function(id)
    return Ashita.Mob.Data(id, true)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- HXUI    : https://github.com/tirem/HXUI
-- Zone might only come from the party packet.
-- ------------------------------------------------------------------------------------------------------
---@param id number this can be an ID or an index. If it's an ID then set the convert_id flag.
---@param convert_id? boolean if an ID is supplied then the it will be need to be converted to an index.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.Data = function(id, convert_id)
    local index = id
    if convert_id then index = Ashita.Mob.Index_By_ID(id) end

	local entity_manager = AshitaCore:GetMemoryManager():GetEntity()
    local entity = {}

    entity.name = entity_manager:GetName(index)
    entity.id = entity_manager:GetServerId(index)

    return entity
end

-- ------------------------------------------------------------------------------------------------------
-- Checks to see if a given string matches your character's name.
-- ------------------------------------------------------------------------------------------------------
---@param actor_id string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.Is_Me = function(actor_id)
    local player = GetPlayerEntity()
    if not player then return false end
    return actor_id == player.ServerId
end