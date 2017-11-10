
local landingPt
local startingPt
--local unit
local totalTime = 0

function StartJump(trigger)
	local unit = trigger.activator
	local triggerName = trigger.caller:GetName()
	triggerPt = trigger.caller:GetAbsOrigin()
	
	--landingPtName = jump_landing_ .. index
	local landingPtName = string.gsub(triggerName, "jump_pad", "jump_landing")
	
	local ent = Entities:FindByName(nil, landingPtName)
	if ent == nil then
		print("landing point not found:" .. landingPtName)
		return
	end
	
	local maxIndex = unit:GetAbilityCount() -1
	print("max:" .. tostring(maxIndex))
	for i=0, maxIndex do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			--print("abil:" .. abil:GetAbilityName())
			if abil:GetAbilityName() == "jump_lua" then
				--print("found jump")
				if abil:GetLevel() == 0 then
					abil:SetLevel(1)
				end
				
				abil:SetTarget(ent:GetAbsOrigin())
				local playerID = unit:GetPlayerID()
				unit:CastAbilityNoTarget(abil, playerID)
			end
		end
	end
	--local jumpAbil = 
	--unit ent:GetAbsOrigin()
	
	--startingPt = GetGroundPosition(triggerPt, unit)
	--landingPt = GetGroundPosition(ent:GetAbsOrigin(), unit)
	
	--print("triggerName:" .. landingPtName)
	--unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	--trigger.caller:SetContextThink("JumpThink", JumpThink, 0.03)
end

function JumpThink()
	local interval = 0.03
	local maxTime = 0.4
	local z = 350
	totalTime = totalTime + interval
	local diff = landingPt - startingPt
	local totalDist = diff:Length2D()
	local percent = totalTime/maxTime
	print("percent:" .. tostring(percent))
	local extra = diff * Vector(percent,percent,percent)
	
	local zWeight
	--value from 0-0.5
	if percent > 0.5 then
		zWeight = 0.5 - (percent-0.5) 
	else 
		zWeight = percent
	end
	print("zWeigth:" .. tostring(zWeight))
	extra = extra + Vector(0, 0, zWeight*z)
	
	local nextPos = startingPt+extra
	unit:SetAbsOrigin(nextPos)
	
	local vToTarget = landingPt - nextPos
	local distToTarget = vToTarget:Length2D()
	if distToTarget > 50 then
		return interval
	end
	
	unit:Stop()
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	totalTime = 0
	return
end