-- Generated from template

if Frosti == nil then
	Frosti = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]

		PrecacheResource( "model", "models/items/courier/nexon_turtle_01_grey/nexon_turtle_01_grey.vmdl", context )
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
	GameRules:SetPreGameTime( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetCustomGameTeamMaxPlayers(4,0)
	GameRules:SetPostGameTime(30)

	--set custom values for game mode
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetTopBarTeamValuesVisible(false)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)

	Frosti:SpawnStartingUnits()
end

-- Evaluate the state of the game
function Frosti:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--spawns all the units need when initializing
function Frosti:SpawnStartingUnits()
	--payload
	local target = Entities:FindByName( nil, "path_5")
	CreateUnitByName("payload", target:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
end
