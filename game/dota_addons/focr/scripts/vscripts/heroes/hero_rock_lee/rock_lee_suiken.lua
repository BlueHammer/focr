function SuikenProc( keys )
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local agi_multiplier = ability:GetLevelSpecialValueFor("agility_multiplier", (ability:GetLevel() - 1))
local agility = caster:GetAgility()
local bonus_damage = agi_multiplier * agility
if target:IsAlive() then
	local damageTable =
	{
		victim = target,
		attacker = caster,
		damage = bonus_damage,
		damage_type = DAMAGE_TYPE_PHYSICAL  
	}
	ApplyDamage( damageTable )
end
end