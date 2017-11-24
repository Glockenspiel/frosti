-- Generated from template

if Frosti == nil then
	_G.Frosti = class({})
end


local isDebugging = false
local setOnce = false
--_G.nextPathIndex = 2 					--first index in PathPoints the bot will move to
PayloadTarget = nil

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	
	
	
		PrecacheResource( "model", "models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl", context )
		PrecacheResource( "particle", "particles/status_fx/status_effect_snow_heavy.vpcf", context )
		
		--mini pudge
		--PrecacheResource( "model", "models/courier/minipudge/minipudge_flying.vmdl", context )
		PrecacheResource( "particle", "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl3_a1.vpcf", context )
		PrecacheResource( "particle", "particles/ui/ui_sweeping_ring.vpcf", context )
		PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_rot.vpcf", context )
		PrecacheResource( "particle", "particles/dummy_ring.vpcf", context )
		PrecacheResource( "particle", "particles/jump_ring.vpcf", context )
		PrecacheResource( "particle", "particles/speed_buff.vpcf", context )
		PrecacheResource( "particle", "particles/teleport_buff.vpcf", context )
		--PrecacheResource( "particle", "particles/teleport_beam.vpcf", context )
		--PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_flying.vpcf", context )
		
		
		
		
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = Frosti()
	GameRules.AddonTemplate:InitGameMode()
end

function Frosti:InitGameMode()

	--set custom values for game rules
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetThink( "OnThink", self, "GlobalThink", 1 )
	
	GameRules:SetPreGameTime( 4 )
	Frosti:ResetCustomGameState()
	Frosti:CustomGameStateChange()
	
	if IsInToolsMode() then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 60 )
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay( 45 )
	end
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )
	GameRules:SetPostGameTime(30)
	GameRules:SetHeroSelectionTime(45)
	GameRules:SetStartingGold(650)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)

	--set custom values for game mode
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetTopBarTeamValuesVisible(false)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetDaynightCycleDisabled(true)

	--Frosti:SpawnStartingUnits()
	CustomNetTables:SetTableValue("game", "stage", { value = 1})
	ListenToGameEvent("npc_spawned", Frosti.AddExtraAbilities, self)
	ListenToGameEvent("game_rules_state_change", Frosti.ChangeGameState, self)
end

function Frosti:ChangeGameState(event)

	--random hero if not selected
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local pos = Entities:FindByName(nil, "death_point"):GetAbsOrigin()
		CreateUnitByName("dummy_teleport", pos, true, nil, nil, DOTA_TEAM_GOODGUYS)
		local target = Entities:FindByName( nil, "path_10")
		PayloadTarget = CreateUnitByName("payload", target:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	
		for teamNum = 2, 3 do
			for i=1, 4 do
				local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
				if playerID ~= nil then
					if PlayerResource:HasSelectedHero(playerID) == false then
						local hPlayer = PlayerResource:GetPlayer(playerID)
						if hPlayer ~= nil then
							hPlayer:MakeRandomHeroSelection()
						end
					end
				end
			end
		end
	end


	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--add more movespeed to each hero at the start of the game
		local extraMS = 80
		for teamNum = 2, 3 do
			for i=1, 4 do
				local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
				if playerID ~= nil then
					local hPlayer = PlayerResource:GetPlayer(playerID)
					if hPlayer ~=nil then
						local hero = hPlayer:GetAssignedHero()
						if hero ~= nil then
							local baseMS = hero:GetBaseMoveSpeed()
							hero:SetBaseMoveSpeed(baseMS + extraMS)
						end
					end
				end
			end
		end
	end
end	


--should be called when the key "state" in the custom net table "gamestate" changes
function Frosti:CustomGameStateChange()
	--local curTime = CustomNetTables:GetTableValue("gamestate", "time").value
	local state = CustomNetTables:GetTableValue("gamestate", "state").value
	
	if state ==  "pregame" then
		GameRules:SetGoldPerTick( 0 )
	elseif state == "in_progress" then
		GameRules:SetGoldPerTick( 6 )
	end
end



-- Evaluate the state of the game using net table
function Frosti:OnThink()
	local state = CustomNetTables:GetTableValue("gamestate", "state").value
	local curTime = CustomNetTables:GetTableValue("gamestate", "time").value
	
	--changing state
	if curTime == 0 then
		if state == "pregame" then
			CustomNetTables:SetTableValue("gamestate", "state", { value = "in_progress" })
			CustomNetTables:SetTableValue("gamestate", "time", { value = 220 })
		elseif state == "in_progress" then
			local round = CustomNetTables:GetTableValue("game", "round").value
			if round == 1 then
				CustomNetTables:SetTableValue("game", "round", { value = 2 })
				Frosti:SwitchSides()
			else
				Frosti:SetWinner()
			end
		end
		
		Frosti:CustomGameStateChange()
	end
	
	state = CustomNetTables:GetTableValue("gamestate", "state").value
	curTime = CustomNetTables:GetTableValue("gamestate", "time").value
	
	if GameRules:State_Get() > DOTA_GAMERULES_STATE_PRE_GAME and state ~= "post_game" and GameRules:IsGamePaused() == false then
		--pregame of a round
		if state == "pregame" then
			CustomNetTables:SetTableValue("gamestate", "time", { value = curTime + 1 })
			
		--round in progress
		elseif state == "in_progress" then
			CustomNetTables:SetTableValue("gamestate", "time", { value = curTime - 1 })
			
			--passive experience
			local XPS = 10 --experience per second
			for teamNum = 2, 3 do
				for i=1, 4 do
					local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
					if playerID ~= nil then
						local hPlayer = PlayerResource:GetPlayer(playerID)
						if hPlayer ~=nil then
							local hero = hPlayer:GetAssignedHero()
							if hero ~= nil then
								hero:AddExperience(XPS , 0, false, true)
							end
						end
					end
				end
			end
			
		--game over
		else
			return nil
		end
	end
	return 1
end

function Frosti:AddExtraAbilities(event)
	local spawnedUnit = EntIndexToHScript( event.entindex )
	AddAbilityIfNotExist(spawnedUnit, "fall_lua")
	AddAbilityIfNotExist(spawnedUnit, "jump_lua")
	AddAbilityIfNotExist(spawnedUnit, "speed_lua")
end

function AddAbilityIfNotExist(unit, abilityName)
	if unit:HasAbility(abilityName) == false then
		unit:AddAbility(abilityName)
	end
end

--spawns all the units need when initializing
function Frosti:SpawnStartingUnits()
	--payload
	local target = Entities:FindByName( nil, "path_10")
	PayloadTarget = CreateUnitByName("payload", target:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
end

--set movespeed of the player to fast when debugging
function Frosti:ToolsModeSpawn()
	if	setOnce then
		return
	end

	units = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		Vector(0, 0, 0),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _,u in pairs(units) do
		if u:GetOwner()~=nil then
			u:SetBaseMoveSpeed(600)
			setOnce=true
		end
	end
end

--switches sides at the end of a round
--players stay on the same team as the prevoius round
function Frosti:SwitchSides()
	--return players to spawn
	local spawnPts = { 
		Entities:FindByName(nil, "good_spawn"):GetAbsOrigin(), 
		Entities:FindByName(nil, "bad_spawn"):GetAbsOrigin() 
	}
	
	local round2Level = 10

	for teamNum = 2, 3 do
		for i=1, 4 do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
			if playerID ~= nil then
				local hPlayer = PlayerResource:GetPlayer(playerID)
				if hPlayer ~=nil then
					local hero = hPlayer:GetAssignedHero()
					--return hero to spawn island
					FindClearSpaceForUnit(hero, spawnPts[teamNum-1], true)
					
					--set all heroes to level 10 for round 2
					for k = hero:GetLevel(), round2Level-1 do
						hero:HeroLevelUp(false)
					end
					
					hero:Stop()
					
					--respawn if dead
					if hero:IsAlive() == false then
						hero:RespawnUnit()
					end
					
					--center camera
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
						if u:GetUnitName() == "dummy_teleport" then
							local abil = u:GetAbilityByIndex(1)
							u:CastAbilityOnTarget(hero, abil, playerID)
							break
						end
					end
					
				end
			end
		end
	end

	--return the payload to the spawn
	local startPt = Entities:FindByName(nil, "path_10"):GetAbsOrigin()
	FindClearSpaceForUnit(PayloadTarget, startPt, true)
	
	--reset path for payload
	CustomNetTables:SetTableValue("payload", "nextPath", { value = 2 })
	
	Frosti:ResetCustomGameState()
end

--sets victory condition
function Frosti:SetWinner()
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_POST_GAME then
		--furthest distance is the winner
		--if both reached same distance then check which got there first
		--if distance is the same then pick the team with the most kills
		CustomNetTables:SetTableValue("gamestate", "state", { value = "post_game" })
		
		local goodScore = CustomNetTables:GetTableValue("game", "dist_good").value
		local badScore = CustomNetTables:GetTableValue("game", "dist_bad").value
		
		if goodScore > badScore then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		elseif goodScore < badScore then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		else
			local goodKills = PlayerResource:GetTeamKills(DOTA_TEAM_GOODGUYS)
			local badKills = PlayerResource:GetTeamKills(DOTA_TEAM_BADGUYS)
			
			if goodKill == nil then
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end
			
			if badKill == nil or goodKill > badKills then
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			else
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end
		end
	end
end

function Frosti:ResetCustomGameState()
	CustomNetTables:SetTableValue("gamestate", "time", { value = -20 })
	CustomNetTables:SetTableValue("gamestate", "state", { value = "pregame" })
end