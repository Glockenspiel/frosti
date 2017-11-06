--called by hole trigger after a delay
function FallEnter(trigger)
	--local entIndex = trigger.activator:GetEntityIndex()
	--print("entered:" .. tostring(entIndex))
	--if the unit is still over the hole then activate fall physics
	local unit = trigger.activator
	
	if trigger.caller:IsTouching(unit) then
		print("activate fall physics")
		local maxIndex = unit:GetAbilityCount()-1
		for i=0, maxIndex do
			local abil = unit:GetAbilityByIndex(i)
			
			if abil ~= nil then
				print("found abil:" .. abil:GetAbilityName())
				if abil:GetAbilityName() == "fall_lua" then
					abil:CastAbility()
				end
			end
		end
	end
end