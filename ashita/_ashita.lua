Ashita = { }

Ashita.Enum = { }
Ashita.Enum.Status =
{
    RESTING = 33,
}

Ashita.Enum.Buffs =
{
    FOOD   = 251,
    SIGNET = 253,
}

Ashita.States =
{
    Zoning = false,
    Food   = false,
}

Ashita.Slots = require('ashita.slots')
Ashita.Jobs  = require('ashita.jobs')

require('ashita.mob')
require('ashita.packets')
require('ashita.menu')
require('ashita.chat')

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a player is currently resting or not.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.IsResting = function()
    local player = GetPlayerEntity()

    if not player then
        return false
    end

    return player.Status == Ashita.Enum.Status.RESTING
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's maximum HP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.MaxHP = function()
    -- This value doesn't update in time. I usually have to open the equipment menu to get it to update.
    local player = AshitaCore:GetMemoryManager():GetPlayer()

    if not player then
        return 0
    end

    return player:GetHPMax()
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's current HP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.CurrentHP = function()
    local party = AshitaCore:GetMemoryManager():GetParty()

    if not party then
        return 0
    end

    if party:GetMemberIsActive(0) == 1 then
        return party:GetMemberHP(0)
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's current HP percentage.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.HPP = function()
    local party = AshitaCore:GetMemoryManager():GetParty()

    if not party then
        return 0
    end

    if party:GetMemberIsActive(0) == 1 then
        return party:GetMemberHPPercent(0)
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the difference between max HP and current HP.
-- ------------------------------------------------------------------------------------------------------
Ashita.MissingHP = function()
    return Ashita.MaxHP() - Ashita.CurrentHP()
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's maximum MP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.MaxMP = function()
    -- This value doesn't update in time. I usually have to open the equipment menu to get it to update.
    local player = AshitaCore:GetMemoryManager():GetPlayer()

    if not player then
        return 0
    end

    local maxMP = player:GetMPMax() or 0

    return maxMP
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's current MP.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.CurrentMP = function()
    local party = AshitaCore:GetMemoryManager():GetParty()

    if not party then
        return 0
    end

    if party:GetMemberIsActive(0) == 1 then
        return party:GetMemberMP(0)
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's current MP percentage.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.MPP = function()
    local party = AshitaCore:GetMemoryManager():GetParty()

    if not party then
        return 0
    end

    if party:GetMemberIsActive(0) == 1 then
        return party:GetMemberMPPercent(0)
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the difference between max MP and current MP.
-- ------------------------------------------------------------------------------------------------------
Ashita.MissingMP = function()
    return Ashita.MaxMP() - Ashita.CurrentMP()
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's main or sub job.
-- ------------------------------------------------------------------------------------------------------
---@param subJob? boolean
---@return string
-- ------------------------------------------------------------------------------------------------------
Ashita.Job = function(subJob)
    local player = AshitaCore:GetMemoryManager():GetPlayer()

    if not player then
        return 'ERR'
    end

    local jobID = player:GetMainJob()

    if subJob then
        jobID = player:GetSubJob()
    end

    return Ashita.Jobs[jobID].ens
end

-- ------------------------------------------------------------------------------------------------------
-- Gets a player's main or sub job level.
-- ------------------------------------------------------------------------------------------------------
---@param subJob? boolean
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.JobLevel = function(subJob)
    local player = AshitaCore:GetMemoryManager():GetPlayer()

    if not player then
        return 0
    end

    if subJob then
        return player:GetSubJobLevel()
    end

    return player:GetMainJobLevel()
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a player is currently logged in or not.
-- I grabbed this from HXUI.
-- https://github.com/tirem/HXUI
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.IsLoggedIn = function()
    local isLoggedIn  = false
    local playerIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)

    if playerIndex ~= 0 then
        local entity = AshitaCore:GetMemoryManager():GetEntity()
        local flags  = entity:GetRenderFlags0(playerIndex)

        if bit.band(flags, 0x200) == 0x200 and bit.band(flags, 0x4000) == 0 then
            isLoggedIn = true
        end
    end

    return isLoggedIn
end

-- ------------------------------------------------------------------------------------------------------
-- Keeps track of if the player is zoning or not. Used to hide the window during zoning.
-- ------------------------------------------------------------------------------------------------------
---@param zoning boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.IsZoning = function(zoning)
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
    local inventoryManager = AshitaCore:GetMemoryManager():GetInventory()
    local item             = inventoryManager:GetEquippedItem(slot)

    if not item then
        return 0
    end

    local index          = bit.band(item.Index, 0x00FF)
    local equipmentEntry = { }

    if index ~= 0 then
        equipmentEntry.Container = bit.band(item.Index, 0xFF00) / 256
        equipmentEntry.Item      = inventoryManager:GetContainerItem(equipmentEntry.Container, index)

        return equipmentEntry.Item.Id
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if the player has the specified buff or not.
-- ------------------------------------------------------------------------------------------------------
---@param buff_id integer
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.HasBuff = function(buff_id)
    local player = AshitaCore:GetMemoryManager():GetPlayer()

    if not player then
        return false
    end

    local buffs = player:GetBuffs()

    for _, id in pairs(buffs) do
        if id == buff_id then
            return true
        end
    end

    return false
end
