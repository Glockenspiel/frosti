dummy_teleport_lua = class({})
LinkLuaModifier( "modifier_dummy_teleport_lua", "abils/modifier_dummy_teleport_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_center_camera_lua", "abils/modifier_center_camera_lua", LUA_MODIFIER_MOTION_NONE )


function dummy_teleport_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	target:AddNewModifier(caster, self, "modifier_dummy_teleport_lua", { duration = 5 } )
	target:AddNewModifier(caster, self, "modifier_center_camera_lua", { duration = 0.1 } )
end