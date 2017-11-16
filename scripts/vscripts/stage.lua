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
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
	
end