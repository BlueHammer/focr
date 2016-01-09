function GrapplingDash( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local direction = caster:GetForwardVector()

local newPos = casterPos + direction * 266.67
caster:SetAbsOrigin(newPos)
end

function GrapplingDashEnd( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
FindClearSpaceForUnit(caster, casterPos, false)
end 

function GrapplingDashDamage( keys )
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local level_multiplier = ability:GetLevelSpecialValueFor("lvl_multiplier", (ability:GetLevel() - 1))
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local damageType = ability:GetAbilityDamageType()
local level = caster:GetLevel()

if level <= 21 then 
	local damageTable =
	{
		victim = target,
		attacker = caster,
		damage = damage + level * level_multiplier,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
else
	local damageTable =
	{
		victim = target,
		attacker = caster,
		damage = damage + 1575,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
end
end