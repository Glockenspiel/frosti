-- Generated from template

if Frosti == nil then
	Frosti = class({})
end


local isDebugging = true
local setOnce = false

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	
	

		PrecacheResource( "model", "models/items/courier/nexon_turtle_01_grey/nexon_turtle_01_grey.vmdl", context )
		PrecacheResource( "model", "models/heroes/ogre_magi/ogre_magi.vmdl", context )
		
		
		PrecacheResource( "particle", "particles/status_fx/status_effect_snow_heavy.vpcf", context )
		PrecacheResource( "particle", "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf", context )
		
		--mini pudge
		PrecacheResource( "model", "models/courier/minipudge/minipudge_flying.vmdl", context )
		PrecacheResource( "particle", "*particles/units/heroes/hero_puck/puck_phase_shift.vpcf", context )
		
		
		
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = Frosti()
	GameRules.AddonTemplate:InitGameMode()
end

function Frosti:InitGameMode()

	--set custom values for game rules
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetPreGameTime( 5 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetCustomGameTeamMaxPlayers(4,0)
	GameRules:SetPostGameTime(30)

	--set custom values for game mode
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetTopBarTeamValuesVisible(false)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetAnnouncerDisabled(true)

	--Frosti:SpawnStartingUnits()
end


-- Evaluate the state of the game
function Frosti:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IsInToolsMode() and isDebugging then
			Frosti:ToolsModeSpawn()
			
			Frosti:AddFallAbility()
			
		end

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--adds the fall ability onto every hero in the game (once only)
local addFallAbilityOnce = false;
function Frosti:AddFallAbility()
	if addFallAbilityOnce == true then
		return
	end
	
	local maxIndex = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	for i=0, maxIndex do
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS,i)
		local hPlayer = PlayerResource:GetPlayer(playerID)
		
		if hPlayer ~= nil then
			local hero  = hPlayer:GetAssignedHero()
			hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
			hero:AddAbility("fall_lua")
			print("added falled ability")
		end
	end
	
	addFallAbilityOnce = true;
end

--spawns all the units need when initializing
function Frosti:SpawnStartingUnits()
	--payload
	local target = Entities:FindByName( nil, "path_10")
	CreateUnitByName("payload", target:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
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
