function RasenShurikenAttach( keys )
Timers:CreateTimer( 0.09, function()

local caster = keys.caster
local ability = keys.ability

caster.futon_rasengan_Particle = ParticleManager:CreateParticle("particles/naruto/futon.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(caster.futon_rasengan_Particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack_rasengan", caster:GetAbsOrigin(), true)
return nil
end
)
end

function RasenShurikenRemove( keys )
Timers:CreateTimer( 0.2, function()
local caster = keys.caster
local ability = keys.ability

ParticleManager:DestroyParticle( caster.futon_rasengan_Particle, true )
return nil
end
)
end

function RasenShurikenRegister( keys )
local caster = keys.caster
caster.rasen_shuriken_point = keys.target_points[1]
caster:SetAbsOrigin(caster.rasen_shuriken_point + Vector( 0, 0, 500))
end

function RasenShurikenCycle( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
caster:SetAbsOrigin(casterPos - Vector( 0, 0, 41.67))
end

function RasenShurikenEnd( keys ) 
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local ability = keys.ability
local damageType = ability:GetAbilityDamageType()
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local aoe = ability:GetLevelSpecialValueFor("aoe", (ability:GetLevel() - 1))
local extra_damage = ability:GetLevelSpecialValueFor("extra_damage", (ability:GetLevel() - 1))
local agility = caster:GetAgility()
local total_damage = damage + extra_damage + agility

FindClearSpaceForUnit(caster, casterPos, false)
local units = FindUnitsInRadius( caster:GetTeamNumber(), casterPos, caster, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
for k, v in pairs(units) do
	ability:ApplyDataDrivenModifier(caster, v, "modifier_rasen_shuriken_stun", {})
	local damageTable =
	{
		victim = v,
		attacker = caster,
		damage = total_damage,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
end

local particle = ParticleManager:CreateParticle("particles/naruto/futon_boom.vpcf", PATTACH_POINT, caster)
ParticleManager:SetParticleControl(particle, 1, casterPos)

local particle3 = ParticleManager:CreateParticle("particles/naruto/futonarus_kaboom.vpcf", PATTACH_POINT, caster)
ParticleManager:SetParticleControl(particle3, 0, casterPos)

local particle2 = ParticleManager:CreateParticle("particles/naruto/kunkka_spell_torrent_splash_econ.vpcf", PATTACH_POINT, caster)
ParticleManager:SetParticleControl(particle2, 0, casterPos)

end