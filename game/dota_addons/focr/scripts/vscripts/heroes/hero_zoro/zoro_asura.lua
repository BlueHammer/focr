function AsuraDamage( keys )
local target = keys.target
local health = target:GetHealth()
local ability = keys.ability
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local damagePerTick = damage * 0.8 / 15

if health > damagePerTick then
	local newHealth = health - damagePerTick
	target:SetHealth(newHealth)
	local particle = ParticleManager:CreateParticle("particles/zoro/rosh_dismember.vpcf", PATTACH_ABSORIGIN, target)
	Timers:CreateTimer( 2, function()
		ParticleManager:DestroyParticle( particle, false )
	return nil
	end
	)
else
	target:SetHealth(1)
	local particle = ParticleManager:CreateParticle("particles/zoro/rosh_dismember.vpcf", PATTACH_ABSORIGIN, target)
	Timers:CreateTimer( 2, function()
		ParticleManager:DestroyParticle( particle, false )
	return nil
	end
	)
end
end

