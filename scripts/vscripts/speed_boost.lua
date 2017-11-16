
function enter(trigger)
	local unit = trigger.activator
	local abil = unit:FindAbilityByName("speed_lua")
	
	if abil~=nil then
		abil:CastAbility()
	end
end