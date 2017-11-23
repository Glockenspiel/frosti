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

function modifier_jump_lua:OnCreated()
	local hCaster = self:GetCaster()
	local nFXIndex2 = ParticleManager:CreateParticle( "particles/jump_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( 800, 800, 800 ) )
	self:AddParticle( nFXIndex2, false, false, -1, false, false )
end
