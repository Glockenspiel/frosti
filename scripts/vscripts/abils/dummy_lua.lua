dummy_lua = class({})
LinkLuaModifier( "modifier_dummy_lua", "abils/modifier_dummy_lua", LUA_MODIFIER_MOTION_NONE )

function dummy_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_dummy_lua", { } )
end