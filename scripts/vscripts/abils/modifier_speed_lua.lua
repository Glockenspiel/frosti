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

function modifier_speed_lua:OnCreated()
	print("jumping")
	local hCaster = self:GetCaster()
	local nFXIndex2 = ParticleManager:CreateParticle( "particles/speed_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( 200, 200, 200 ) )
	self:AddParticle( nFXIndex2, false, false, -1, false, false )
end