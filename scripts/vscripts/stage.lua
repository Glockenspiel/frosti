--change the stage index on the custom net table if the payload enters a stage trigger
local stageBonus = 
{
	0,
	0,
	120,
	120,
	0
}

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
	
	local lastStage = 5
	--end of path is reached
	if index == lastStage then
		local round = CustomNetTables:GetTableValue("game", "round")
		if round.value == 1 then
			CustomNetTables:SetTableValue("game", "round", { value = 2 })
			CustomNetTables:SetTableValue("game", "stage", { value = 1 })
			CustomNetTables:SetTableValue("game", "dist_good", { value = 1 })
			Frosti:SwitchSides()
		else
			CustomNetTables:SetTableValue("game", "dist_bad", { value = 1 })
			Frosti:SetWinner()
		end
	else
		local bonus = stageBonus[index]
		if bonus > 0 then
			local curTime = CustomNetTables:GetTableValue("gamestate", "time").value
			CustomNetTables:SetTableValue("gamestate", "time", { value = curTime + bonus })
		end
	end
end