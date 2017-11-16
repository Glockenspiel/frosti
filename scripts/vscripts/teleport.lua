local GOODGUYS = 1
local BADGUYS = 2



local SpawnsStage1 = 
{
	{"spawn_2", "spawn_3"},
	{"spawn_1", "spawn_4"}
}

local SpawnsStage2 = 
{
	{"spawn_1", "spawn_4"},
	{"spawn_5", "spawn_9"}
}

local SpawnsStage3 = 
{
	{"spawn_5", "spawn_9"},
	{"spawn_6", "spawn_7", "spawn_8"}
}

local SpawnsStage4 = 
{
	{"spawn_12", "spawn_9"},
	{"spawn_10", "spawn_11"}
}

local Spawns = {
	SpawnsStage1,
	SpawnsStage2,
	SpawnsStage3,
	SpawnsStage4
}



function enter(trigger)
	local unit = trigger.activator
	local team  = unit:GetTeamNumber()
	
	local stageTable = CustomNetTables:GetTableValue("game", "stage")
	local stage = stageTable.value
	
	local curSpawns = Spawns[stage][team-1]
	local index = math.random(1,#curSpawns)
	local targetName = curSpawns[index]
	
	local ent = Entities:FindByName(nil, targetName)
	
	if ent ~= nil then
		local target  = ent:GetAbsOrigin()
		FindClearSpaceForUnit(unit, target, true)
		unit:Stop()
		local playerID = unit:GetPlayerID()
		SendToConsole("dota_camera_center")
	else
		print("spawn point not found")
	end
end