modifier_jump_lua = class({})

function modifier_jump_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
 
	return state
end

function modifier_jump_lua:IsDebuff()
	return false
end