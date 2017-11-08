pudge_meat_hook_vt_lua = class ({})

local targetStart

function pudge_meat_hook_vt_lua:OnSpellStart()
	local targetEnd = self:GetCursorPosition()
	local diff = targetEnd - targetEnd
	local direction = diff:Normalized()
	local displacement = direction * 500
	local finalTarget  = targetStart + displacement
	print("finalTarget:")
	print(finalTarget)
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

