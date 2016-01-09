function ManeuverStart( keys )
local point = keys.target_points[1]
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local difference = point - casterPos
local distance = difference:Length2D()
local direction = difference:Normalized()
local ability = keys.ability
local range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
if distance > range then
	distance = range
end
local duration = distance / 650 * 0.18
ability:ApplyDataDrivenModifier(caster, caster, "modifier_3d_maneuver_dash", {Duration = duration})
Timers:CreateTimer( 0.03, function()
	local projectileTable =
	{
		EffectName = "particles/invisible.vpcf",
		Ability = ability,
		vSpawnOrigin = casterPos,
		vVelocity = speed * direction,
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	}
	ProjectileManager:CreateLinearProjectile(projectileTable)
	return nil
	end
)
end

function ManeuverDash( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local direction = caster:GetForwardVector()

local newPos = casterPos + direction * 108.33
caster:SetAbsOrigin(newPos)
end

function ManeuverDashEnd( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
FindClearSpaceForUnit(caster, casterPos, false)
end 

function ManeuverDamage( keys )
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local damage_multiplier = ability:GetLevelSpecialValueFor("damage_multiplier", (ability:GetLevel() - 1))
local damageType = ability:GetAbilityDamageType()

caster:PerformAttack( target, true, false, true, false, false )
end