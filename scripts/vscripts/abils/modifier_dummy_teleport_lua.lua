modifier_dummy_teleport_lua = class({})

--makes player immune from damage when they teleport so they dotn get spawn camped
function modifier_dummy_teleport_lua:OnCreated()
	local target = self:GetParent()
	local nFXIndex = ParticleManager:CreateParticle( "particles/teleport_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 50 ) )
	self:AddParticle( nFXIndex, false, false, -1, false, false )
end

function modifier_dummy_teleport_lua:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	}
 
	return state
end