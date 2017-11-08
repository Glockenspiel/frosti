
function Spawn()
	thisEntity:SetContextThink("UseHook", UseHook, 0.03)
	thisEntity:SetContextThink("Disapear", Disapear, 2)
end

function UseHook()
	local hookAbil = thisEntity:GetAbilityByIndex(0)
	local targetPos = thisEntity:GetForwardVector()*400
	targetPos = targetPos + thisEntity:GetAbsOrigin()
	targetPos = GetGroundPosition(targetPos, thisEntity)
	local owner = thisEntity:GetOwner()
	local playerID = owner:GetPlayerID()
	thisEntity:CastAbilityOnPosition(targetPos, hookAbil, playerID)
end

function Disapear()
	local phaseShiftAbil = thisEntity:GetAbilityByIndex(1)
	phaseShiftAbil:CastAbility()
	thisEntity:SetContextThink("Teleport", Teleport, 0.09)
	-- local entPt = Entities:FindByName(nil, "death_point")
	-- local point = entPt:GetAbsOrigin()
	-- thisEntity:SetAbsOrigin(point)
	-- thisEntity:ForceKill(false)
end

function Teleport()
	local entPt = Entities:FindByName(nil, "death_point")
	local point = entPt:GetAbsOrigin()
	thisEntity:SetAbsOrigin(point)
	thisEntity:SetContextThink("Kill", Kill, 0.3)
end

function Kill()
	thisEntity:ForceKill(false)
end