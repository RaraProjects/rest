Ashita = T{}

Ashita.Enum = T{}
Ashita.Enum.Status = T{
    RESTING = 33,
}

Ashita.States = T{
    Zoning = false,
    Food = false,
}

Ashita.Slots = require("ashita.slots")
Ashita.Jobs  = require("ashita.jobs")
require("ashita.mob")
require("ashita.packets")

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a player is currently resting or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Is_Resting = function()
    local player = GetPlayerEntity()
    if not player then return false end
    local status = player.Status
    return status == Ashita.Enum.Status.RESTING
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's maximum MP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Max_MP = function()
    -- This value doesn't update in time. I usually have to open the equipment menu to get it to update.
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then return 0 end
    return player:GetMPMax()
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's current MP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Current_MP = function()
    local party = AshitaCore:GetMemoryManager():GetParty()
    if not party then return 0 end
    if party:GetMemberIsActive(0) == 1 then
        return party:GetMemberMP(0)
    end
    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's main or sub job.
-- ------------------------------------------------------------------------------------------------------
---@param sub_job? boolean
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Job = function(sub_job)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then return "ERR" end
    local job_id = player:GetMainJob()
    if sub_job then job_id = player:GetSubJob() end
    return Ashita.Jobs[job_id].ens
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's main or sub job level.
-- ------------------------------------------------------------------------------------------------------
---@param subjob? boolean
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Job_Level = function(subjob)
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then return 0 end
    if subjob then return player:GetSubJobLevel() end
    return player:GetMainJobLevel()
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a player is currently logged in or not.
-- I grabbed this from HXUI.
-- https://github.com/tirem/HXUI
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Is_Logged_In = function()
    local logged_in = false
    local playerIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)
    if playerIndex ~= 0 then
        local entity = AshitaCore:GetMemoryManager():GetEntity()
        local flags = entity:GetRenderFlags0(playerIndex)
        if bit.band(flags, 0x200) == 0x200 and bit.band(flags, 0x4000) == 0 then
            logged_in = true
        end
    end
    return logged_in
end

-- ------------------------------------------------------------------------------------------------------
-- Keeps track of if the player is zoning or not. Used to hide the window during zoning.
-- ------------------------------------------------------------------------------------------------------
---@param zoning boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Is_Zoning = function(zoning)
    Ashita.States.Zoning = zoning
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the ID of an equipped item.
-- Modeled this after LuAshitaCast.
-- https://github.com/ThornyFFXI/LuAshitacast
-- ------------------------------------------------------------------------------------------------------
---@param slot integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Equipment = function(slot)
    local inventory_manager = AshitaCore:GetMemoryManager():GetInventory()
    local item = inventory_manager:GetEquippedItem(slot)
    local index = bit.band(item.Index, 0x00FF)
    local equipment_entry = {}
    if index ~= 0 then
        equipment_entry.Container = bit.band(item.Index, 0xFF00) / 256
        equipment_entry.Item = inventory_manager:GetContainerItem(equipment_entry.Container, index)
        return equipment_entry.Item.Id
    end
    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if the player has the food buff or not.
-- ------------------------------------------------------------------------------------------------------
Ashita.Has_Food = function()
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    if not player then return nil end
    local food_buff = 251
    local buffs = player:GetBuffs()
    for _, buff_id in pairs(buffs) do
        if buff_id == food_buff then return true end
    end
    return false
end