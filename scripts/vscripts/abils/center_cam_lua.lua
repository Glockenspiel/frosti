center_cam_lua = class ({})
LinkLuaModifier( "modifier_center_camera_lua", "abils/modifier_center_camera_lua", LUA_MODIFIER_MOTION_NONE )

function center_cam_lua:OnSpellStart()
	print("casting center cam")
	local target = self:GetCursorTarget()
	target:AddNewModifier(caster, self, "modifier_center_camera_lua", { duration = 0.1 } )
end