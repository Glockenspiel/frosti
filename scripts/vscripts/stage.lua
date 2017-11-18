--change the stage index on the custom net table if the payload enters a stage trigger
function enter(trigger)
	local unit = trigger.activator
	
	if unit:GetUnitName() ~= "payload" then
		 return
	end
	
	--temp
	--Frosti:SwitchSides()
	
	
	local box = trigger.caller
	local name  = box:GetName()
	local indexStr =  string.gsub(name, "stage_", "")
	local index = tonumber(indexStr)
	CustomNetTables:SetTableValue("game", "stage", { value = index})

	--end of path is reached
	if index == 5 then
		local round = CustomNetTables:GetTableValue("game", "round")
		if round.value == 1 then
			CustomNetTables:SetTableValue("game", "round", { value = 2 })
			CustomNetTables:SetTableValue("game", "stage", { value = 1 })
			
			Frosti:SwitchSides()
		else
			Frosti:SetWinner()
		end
	end
end