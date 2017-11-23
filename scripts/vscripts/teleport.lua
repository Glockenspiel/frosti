--name of entities of spawns for attackers and defenders in each stage
local SpawnsStage1 = 
{
	{"spawn_2", "spawn_3"},
	{"spawn_1", "spawn_4"}
}

local SpawnsStage2 = 
{
	{"spawn_1", "spawn_2", "spawn_3"},
	{"spawn_5", "spawn_9"}
}

local SpawnsStage3 = 
{
	{"spawn_13", "spawn_14"},
	{"spawn_15", "spawn_16"}
}

local SpawnsStage4 = 
{
	{"spawn_12", "spawn_18"},
	{"spawn_10", "spawn_11"}
}

local Spawns = {
	SpawnsStage1,
	SpawnsStage2,
	SpawnsStage3,
	SpawnsStage4
}

--LinkLuaModifier( "modifier_teleport_lua", "abils/modifier_teleport_lua", LUA_MODIFIER_MOTION_NONE )


function enter(trigger)
	local unit = trigger.activator
	local team  = unit:GetTeamNumber()
	
	local stage = CustomNetTables:GetTableValue("game", "stage").value
	local round  = CustomNetTables:GetTableValue("game", "round").value
	
	local side = 1
	if round == 1 and team == DOTA_TEAM_BADGUYS then
		side = 2
	elseif round == 2 and team == DOTA_TEAM_GOODGUYS then
		side = 2
	end
	
	local curSpawns = Spawns[stage][side]
	local index = math.random(1,#curSpawns)
	local targetName = curSpawns[index]
	
	local ent = Entities:FindByName(nil, targetName)
	
	if ent ~= nil then
		local target  = ent:GetAbsOrigin()
		FindClearSpaceForUnit(unit, target, true)
		unit:Stop()
		
		--cast the ability on dummy teleport so a modifier will be added
		--this modifier will help tackle spawn camping
		local radUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
		
		for _,u in pairs(radUnits) do
			print("unit:" .. u:GetUnitName())
			if u:GetUnitName() == "dummy_teleport" then
				print("found dummy")
				local abil = u:GetAbilityByIndex(0)
				local playerID = unit:GetPlayerID()
				u:CastAbilityOnTarget(unit, abil, playerID)
				break
			end
		end
		
	else
		print("spawn point not found")
	end
end