--[[
Copyright © 2024, Metra of HorizonXI
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of React nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL --Metra-- BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

addon.author  = 'Metra'
addon.name    = 'Rest'
addon.version = '2026-01-28'
-- Horizon approved addon (addonreq-0524)

_Globals = { }
_Globals.Initialized = false

UI       = require('imgui')
Settings = require('settings')

require('ashita._ashita')
require('resources._resources')
require('config._config')
require('hpmp._hpmp')
require('timer')
require('bar')
require('clear_mind')
require('signet')
require('equipment')
require('food')
require('ticks')
require('status')
require('window')
require('version')
require('intialization')

Rest = T{ }

Window.SetDrawMode()

-- ------------------------------------------------------------------------------------------------------
-- Catch the screen rendering packet.
-- ------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    if not _Globals.Initialized then
        return nil
    end

    if not Ashita.IsLoggedIn() or Ashita.States.Zoning then
        return nil
    end

    Status.CheckRest()  -- Primary resting loop.
    Bar.Display()       -- Populate windows.
    Config.Display()
end)

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    if not _Globals.Initialized then
        return nil
    end

    if packet.id == 0x00B then        -- Start Zone
        Ashita.IsZoning(true)
    elseif packet.id == 0x00A then    -- End Zone
        Ashita.IsZoning(false)
    end
end)

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- Party info doesn't seem to update right away with 0xC8 (200) and 0xDD (221) so can't update party directly from those.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    if not _Globals.Initialized then return nil end
    -- Action Packet
    if packet.id == 0x028 then

        local action = Ashita.Packets.BuildAction(packet.data)

        if not action then
            return nil
        end

        local actorMob = Ashita.Mob.GetMobByID(action.actor_id)

        if not actorMob then
            return nil
        end

        if not Ashita.Mob.IsMe(actorMob.id) then
            return nil
        end

        -- Use Item
        if (action.category ==  5) then
            local itemID = action.param
            local stats  = Res.GetFood(itemID)

            Food.SetHPMP(itemID, stats)
        end
    end
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local commandArgs = e.command:lower():args()
    local arg         = commandArgs[2]

    ---@diagnostic disable-next-line: undefined-field
    if table.contains({'/rest'}, commandArgs[1]) then
        if not arg then
            Config.ToggleVisible()
        elseif arg == 'mp' then
            Config.MP.ToggleMP()
        elseif arg == 'timer' or arg == 't' then
            Config.MP.ToggleTimeToFullBar()
        end
    end
end)
