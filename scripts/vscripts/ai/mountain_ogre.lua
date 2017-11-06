function Spawn(entityKeyValues)
	print("name:" .. thisEntity:GetName())
    thisEntity:SetContextThink("UseAbility", UseAbility, 1)
end

function UseAbility()
	local target = thisEntity:GetAggroTarget()
	local abilityIndex = 0
	local ability = thisEntity:GetAbilityByIndex(abilityIndex)
	
	if target ~= nil and ability:IsCooldownReady() then
		ability:CastAbility()
	end
	return 1
end