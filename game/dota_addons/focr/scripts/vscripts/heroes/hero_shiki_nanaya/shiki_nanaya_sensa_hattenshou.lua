function SensaHattenshouDamage( keys )
local soundfx = keys.soundfx
local caster = keys.caster
local target = keys.target
local health = target:GetHealth()
local ability = keys.ability
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local damageType = ability:GetAbilityDamageType()
local damagePerTick = damage / 8
local damageTable =
{
	victim = target,
	attacker = caster,
	damage = damagePerTick,
	damage_type = damageType
}

--[[if health > damagePerTick then
	local newHealth = health - damagePerTick
	target:SetHealth(newHealth)
else
	target:SetHealth(1)
end--]]
if caster:IsAlive() then
	if not(caster:IsStunned()) then
		if health > damagePerTick then
			ApplyDamage( damageTable )
		else
			EmitSoundOn(soundfx, target)
			local blinkIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_mid.vpcf", PATTACH_ABSORIGIN, target)
			ApplyDamage( damageTable )
			caster:RemoveModifierByName("modifier_hattenshou_slashing")
			Timers:CreateTimer( 2, function()
				ParticleManager:DestroyParticle( blinkIndex, false )
				StopSoundOn(soundfx, target)
				return nil
				end
			)
		end
	else
		target:RemoveModifierByName("modifier_hattenshou_disable")
		caster:RemoveModifierByName("modifier_hattenshou_slashing")
	end
else
	target:RemoveModifierByName("modifier_hattenshou_disable")
end
end