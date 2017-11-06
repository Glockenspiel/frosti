fall_lua = class ({})
--LinkLuaModifier( "fall_modifier_lua", LUA_MODIFIER_MOTION_NONE )

local ticks = 0

function fall_lua:OnSpellStart()
	print("fall spell start")
	local caster = self:GetCaster()
	--CreateModifierThinker(caster, self, "fall_modifier", { duration = self:GetDuration() }, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	self:SetContextThink("Tick", Tick, 0.2)
end

function fall_lua:Tick()
	local caster = self:GetCaster()
	local origin  = caster:SetAbsOrigin()
	--caster:SetAbsOrigin()
	print("pos:" .. origin)

	ticks = ticks + 1
	return 0.2
end