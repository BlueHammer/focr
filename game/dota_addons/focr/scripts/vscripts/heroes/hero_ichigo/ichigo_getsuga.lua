function DoubleKuroiGetsuga( keys ) 
local caster = keys.caster
local ability = keys.ability
local casterOrigin = caster:GetAbsOrigin()
local point = keys.target_points[1]
local width = ability:GetLevelSpecialValueFor( "getsuga_aoe" , ability:GetLevel() - 1  )
local speed = ability:GetLevelSpecialValueFor( "getsuga_speed" , ability:GetLevel() - 1  )
local distance = ability:GetLevelSpecialValueFor( "getsuga_distance" , ability:GetLevel() - 1  )
local damage = ability:GetLevelSpecialValueFor( "getsuga_damage" , ability:GetLevel() - 1  )
local startTime	= GameRules:GetGameTime()
local travelDuration = distance / speed
local endTime = startTime + travelDuration
local targetDirection	= ( ( point - casterOrigin ) * Vector(1,1,0) ):Normalized()
local projVelocity		= targetDirection * speed

local projID = ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		EffectName			= "particles/ichigo/gets_2.vpcf",
		vSpawnOrigin		= casterOrigin,
		fDistance			= distance,
		fStartRadius		= width,
		fEndRadius			= width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime			= endTime,
		bDeleteOnHit		= false,
		vVelocity			= projVelocity,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	} )

	Timers:CreateTimer( 0.25, function()
		local projID2 = ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		EffectName			= "particles/ichigo/gets_2.vpcf",
		vSpawnOrigin		= casterOrigin,
		fDistance			= distance,
		fStartRadius		= width,
		fEndRadius			= width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime			= endTime,
		bDeleteOnHit		= false,
		vVelocity			= projVelocity,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	} )
		return nil
		end
	)
end
