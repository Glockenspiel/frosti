pudge_meat_hook_vt_lua = class ({})

local targetStart

function pudge_meat_hook_vt_lua:OnSpellStart()
	--print("startPT")
	--print(targetStart)

	local targetEnd = self:GetCursorPosition()
	local diff = targetEnd - targetEnd
	local direction = diff:Normalized()
	local displacement = direction * 500
	local finalTarget  = targetStart + displacement
	--print("finalTarget:")
	--print(finalTarget)
	
	local caster = self:GetCaster();
	
	local miniPudge = CreateUnitByName("mini_pudge", targetStart, true,  caster, caster, caster:GetTeamNumber())
	
	local height = GetGroundHeight(miniPudge:GetAbsOrigin(), miniPudge)
	local forward = targetEnd - targetStart
	if forward == Vector(0,0,0) then
		forward = Vector(1,0,0)
	end
	--print(forward)
	miniPudge:SetForwardVector(forward)
	
	--local hookAbil = miniPudge:GetAbilityByIndex(0)
	--miniPudge:CastAbilityOnPosition(finalTarget, hookAbil, caster:GetPlayerID())
end

-- function pudge_meat_hook_vt_lua:OnAbilityPhaseStart()
	-- print("ability phase start")
-- end

function StartVectorTarget(eventSourceIndex, args)
	local point = args["point"]
	if point == nil then
		return
	end
	
	targetStart = Vector(args['point']["0"], args['point']["1"], args['point']["2"])
end

if IsServer() then 
	CustomGameEventManager:RegisterListener("start_vector_target",  StartVectorTarget)
end

