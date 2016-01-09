function FuryScream( keys )
local ability = keys.ability
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local damageType = ability:GetAbilityDamageType()
local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local strength_multiplier = ability:GetLevelSpecialValueFor("strength_multiplier", (ability:GetLevel() - 1))
local strength = caster:GetStrength()
local extraDamage = strength * strength_multiplier
local totaldamage = damage + extraDamage

local units = FindUnitsInRadius( caster:GetTeamNumber(), casterPos, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
for k, v in pairs(units) do
	print(totaldamage)
	local damageTable =
	{
		victim = v,
		attacker = caster,
		damage = totaldamage,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	ability:ApplyDataDrivenModifier(caster, v, "modifier_fury_scream_debuff", {})
end
end