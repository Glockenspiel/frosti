fall_lua = class ({})

local timeSinceFall = 0;

--activate the falling
function fall_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	--caster:SetAnimation("flail")
	self:SetContextThink("Tick", function() return self:Tick() end, 0.03)
end

--falling thinker function
function fall_lua:Tick()
	local interval = 0.03
	local distToFall = 300
	local fallSpeed = 20
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local pos = origin + Vector(0,0,-fallSpeed)
	caster:SetAbsOrigin(pos)
	
	local ground = GetGroundPosition(pos, caster)
	local diff = caster:GetOrigin() - ground
	local distBelowGround = diff:Length()
	
	if distBelowGround < distToFall and timeSinceFall < 2 then
		timeSinceFall = timeSinceFall + interval
		return interval
	else
		timeSinceFall = 0
		caster:ForceKill(false)
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	end
end