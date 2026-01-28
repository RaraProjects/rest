local parser = require('packets._parser') -- from atom0s

Ashita.Packets = { }

-- ------------------------------------------------------------------------------------------------------
-- Wintersolstice converted the the action packet 0x0028 to the Windower version.
-- This is basically copy and pasted from Wintersolstice's parse lua.
-- Ashita  : https://github.com/atom0s/XiPackets/tree/main/world/server/0x0028
-- Windower: https://github.com/Windower/Lua/wiki/Action-Event
-- Parse   : https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
---@param data table parsed packet data
---@return nil
-- ------------------------------------------------------------------------------------------------------
Ashita.Packets.BuildAction = function (data)
	local parsedPacket = parser.parse(data)
	local act          = { }

	-- Junk packet from server. Ignore it.
	if parsedPacket.trg_sum == 0 then
        return nil
    end

	act.actor_id     = parsedPacket.m_uID
	act.category     = parsedPacket.cmd_no
	act.param        = parsedPacket.cmd_arg
	act.target_count = parsedPacket.trg_sum
	act.unknown      = 0
	act.recast       = parsedPacket.info
	act.targets      = { }

	for _, v in ipairs(parsedPacket.target) do
		local target = { }

		target.id           = v.m_uID
		target.action_count = v.result_sum
		target.actions      = { }
		for _, action in ipairs (v.result) do
			local newAction = { }

			newAction.reaction  = action.miss -- These values are different compared to windower, so the code outside of this function was adjusted.
			newAction.animation = action.sub_kind
			newAction.effect    = action.info
			newAction.stagger   = action.scale
			newAction.param     = action.value
			newAction.message   = action.message
			newAction.unknown   = action.bit

			if action.has_proc then
				newAction.has_add_effect       = true
				newAction.add_effect_animation = action.proc_kind
				newAction.add_effect_effect    = action.proc_info
				newAction.add_effect_param     = action.proc_value
				newAction.add_effect_message   = action.proc_message
			else
				newAction.has_add_effect       = false
				newAction.add_effect_animation = 0
				newAction.add_effect_effect    = 0
				newAction.add_effect_param     = 0
				newAction.add_effect_message   = 0
			end

			if action.has_react then
				newAction.has_spike_effect       = true
				newAction.spike_effect_animation = action.react_kind
				newAction.spike_effect_effect    = action.react_info
				newAction.spike_effect_param     = action.react_value
				newAction.spike_effect_message   = action.react_message
			else 
				newAction.has_spike_effect       = false
				newAction.spike_effect_animation = 0
				newAction.spike_effect_effect    = 0
				newAction.spike_effect_param     = 0
				newAction.spike_effect_message   = 0
			end

			table.insert(target.actions, newAction)
		end

		table.insert(act.targets, target)
	end

	return act
end
