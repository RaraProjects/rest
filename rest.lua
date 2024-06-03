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
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
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

addon.author = "Metra"
addon.name = "Rest"
addon.version = "06.03.24.02"

-- Horizon approved addon (addonreq-0524)

_Globals = {}
_Globals.Initialized = false

UI = require("imgui")
Settings = require("settings")

require("ashita._ashita")
require("timer")
require("resources._resources")
require("Bar._bar")
require("Config.config")
require("MP._mp")
require("ticks")
require("status")

Rest = T{}

-- ------------------------------------------------------------------------------------------------------
-- Catch the screen rendering packet.
-- ------------------------------------------------------------------------------------------------------
ashita.events.register('d3d_present', 'present_cb', function ()
    if not _Globals.Initialized then
        if not Ashita.Is_Logged_In() then return nil end

        -- Initialize settings from file.
        Rest = T{
            Bar    = Settings.load(Bar.Config.Defaults, "bar"),
            MP     = Settings.load(MP.Config.Defaults, "mp"),
            Config = Settings.load(Config.Defaults, "config"),
        }

        Bar.Initialize()

        _Globals.Initialized = true
    end

    MP.Check_Resting_Status()
    Bar.Display()
    Config.Display()
end)

------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
    local arg = command_args[2]

    ---@diagnostic disable-next-line: undefined-field
    if table.contains({"/rest"}, command_args[1]) then
        if not arg then
            Config.Toggle_Visible()
        elseif arg == "breakdown" or arg == "b" then
            MP.Config.Toggle_MP_Breakdown()
        elseif arg == "mp" then
            MP.Config.Toggle_MP()
        elseif arg == "timer" or arg == "t" then
            MP.Config.Toggle_Time_To_Full()
        end
    end

end)

------------------------------------------------------------------------------------------------------
-- Subscribes to incoming packets.
-- https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
------------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function(packet)
    if not _Globals.Initialized then return nil end
    if packet.id == 0xB then        -- Start Zone
        Ashita.Is_Zoning(true)
    elseif packet.id == 0xA then    -- End Zone
        Ashita.Is_Zoning(false)
    end
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings.save("bar")
    Settings.save("config")
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

        local action = Ashita.Packets.Build_Action(packet.data)
        if not action then return nil end

        local actor_mob = Ashita.Mob.Get_Mob_By_ID(action.actor_id)
        if not actor_mob then return nil end
        if not Ashita.Mob.Is_Me(actor_mob.id) then return nil end

        -- Use Item
        if (action.category ==  5) then
            local item_id = action.param
            local hmp = Res.Food_HMP(item_id)
            if hmp > 0 then
                MP.Food.Set_HMP(hmp)
                MP.Food.Set_Name(Res.Food_Name(item_id))
            end
        end
    end
end)