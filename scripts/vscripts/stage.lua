--change the stage index on the custom net table if the payload enters a stage trigger
function enter(trigger)
	local unit = trigger.activator
	if unit:GetUnitName() ~= "payload" then
		 return
	end
	
	local box = trigger.caller
	local name  = box:GetName()
	local indexStr =  string.gsub(name, "stage_", "")
	local index = tonumber(indexStr)
	CustomNetTables:SetTableValue("game", "stage", { value = index})

	--victory condition
	if index == 5 then
		local round = CustomNetTables:GetTableValue("game", "round")
		if round.value == 1 then
			CustomNetTables:SetTableValue("game", "round", { value = 2 })
			CustomNetTables:SetTableValue("game", "stage", { value = 1 })
			SwitchSides()
		else
			SetWinner()
		end
	end
end

--reset values for round 2
function SwitchSides()
	print("switching sides")
	
	--return players to spawn
	local goodUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_HERO,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
							  
	local badUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_HERO,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	
	local goodSpawn = Entities:FindByName(nil, "good_spawn"):GetAbsOrigin()
	local badSpawn = Entities:FindByName(nil, "bad_spawn"):GetAbsOrigin()
	
	for _,unit in pairs(goodUnits) do
	   FindClearSpaceForUnit(unit, goodSpawn, true).
	   unit:Stop()
	end
	
	for _,unit in pairs(badUnits) do
		FindClearSpaceForUnit(unit, badSpawn, true)
		unit:Stop()
	end
	
	--set timer to 5mins
	--set 
end

--victory condition
--furthest distance is the winner
--if distance is the same then pick the team with the most kills
function SetWinner()
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
end