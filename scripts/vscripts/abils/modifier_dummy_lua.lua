modifier_dummy_lua = class({})

function modifier_dummy_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
 
	return funcs
end

function modifier_dummy_lua:CheckState()
	local state = {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true
	}
 
	return state
end