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
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
 
	return state
end

--add particles to the payload
function modifier_dummy_lua:OnCreated()
	local hCaster = self:GetCaster()
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl3_a1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 400, 1, 400 ) )
	self:AddParticle( nFXIndex, false, false, -1, false, false )
	
	local nFXIndex2 = ParticleManager:CreateParticle( "particles/dummy_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( 500, 1, 500 ) )
	self:AddParticle( nFXIndex2, false, false, -1, false, false )
end