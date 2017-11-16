speed_lua = class({})
LinkLuaModifier( "modifier_speed_lua", "abils/modifier_speed_lua", LUA_MODIFIER_MOTION_NONE )

function speed_lua:OnSpellStart()
	print("add speed modifier")
	local caster = self:GetCaster()
	caster:AddNewModifier( self:GetCaster(), self, "modifier_speed_lua", { duration = 5 } )
end