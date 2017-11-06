local triggers = {
	{"trigger_1", "spawn_2", "spawn_1", "spawn_3"},
	{"trigger_2", "spawn_4", "spawn_5"}
}

local spawners = {
	{ "spawn_1", "mountain_ogre"},
	{ "spawn_2", "mountain_ogre" },
	{ "spawn_3", "mountain_ogre"},
	{ "spawn_4"},
	{ "spawn_5"}
}


function OnStartTouch(trigger)
	--caller == trigger
	--activator == unit
	
	for i = 1, #triggers do
		if triggers[i][1] == trigger.caller:GetName() then
			for j = 2, #triggers[i] do
				print("SpawnUnits():" .. triggers[i][j])
				SpawnUnits(triggers[i][j])
			end
			break
		end
	end
end


--spawns all the units for this spawner
function SpawnUnits(spawnerName)
	local ent = Entities:FindByName( nil, spawnerName)
	if ent == nil then
		print("spawner not found:" .. spawnerName)
		return
	end
	
	local point = ent:GetAbsOrigin()
	for i = 1, #spawners do
		if spawners[i][1] == spawnerName then
			for j = 2, #spawners[i] do
				print("createing unit:" .. spawners[i][j])
				CreateUnitByName(spawners[i][j], point, true, nil, nil, DOTA_TEAM_BADGUYS)
			end
			break
		end
	end
end