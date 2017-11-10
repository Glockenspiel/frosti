local jumpVals = {
	{"jump_landing_1", 500, 0.4}
}


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
	
	local vals = GetJumpValues(landingPtName)
	
	local maxIndex = unit:GetAbilityCount() -1
	--print("max:" .. tostring(maxIndex))
	for i=0, maxIndex do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			if abil:GetAbilityName() == "jump_lua" then
				--level up if not already skilled
				if abil:GetLevel() == 0 then
					abil:SetLevel(1)
				end
				
				abil:SetJump(ent:GetAbsOrigin(), vals[2], vals[3])
				--local playerID = unit:GetPlayerID()
				--unit:CastAbilityNoTarget(abil, playerID)
				abil:CastAbility()
			end
		end
	end
end

function GetJumpValues(entName)
	for i=1, #jumpVals do
		if jumpVals[i][1] == entName then
			return jumpVals[i]
		end
	end
	print("GetJumpValues not found")
end