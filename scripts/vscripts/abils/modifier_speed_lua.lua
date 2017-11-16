modifier_speed_lua = class({})


function modifier_speed_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		}
	return funcs	
end

function modifier_speed_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return 60
end