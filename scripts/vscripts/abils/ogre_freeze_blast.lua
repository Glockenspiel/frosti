ogre_freeze_blast = class({})

function ogre_freeze_blast:OnSpellStart(e)
	print("ability used")
	local target = self:GetCaster():GetAggroTarget()
	if target ~= nil then
		self:fire_arrow(target)
	end
end

--Creates a projectile that will travel 2000 units
function ogre_freeze_blast:fire_arrow(target)
	local caster = self:GetCaster()
	local dir = target:GetAbsOrigin() -caster:GetAbsOrigin()
	dir = dir:Normalized()
	--A Liner Projectile must have a table with projectile info
	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		vSpawnOrigin = caster:GetOrigin(),
		fDistance = 2000,
		fStartRadius = 64,
		fEndRadius = 64,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = dir * 600,
		bProvidesVision = true,
		iVisionRadius = 1000,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function ogre_freeze_blast:OnProjectileHitUnit(e)
	print("hit")
end