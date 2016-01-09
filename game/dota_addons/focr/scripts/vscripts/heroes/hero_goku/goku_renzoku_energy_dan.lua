function StartRenzoku( keys )
local caster = keys.caster
local point = keys.target_points[1]
local ability = keys.ability
caster.renzoku_dummy = CreateUnitByName( "npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, caster.renzoku_dummy, "modifier_renzoku_dummy", {} )
end

function RenzokuDamage( keys )
local trueCaster = keys.caster
local trueCasterPos = trueCaster:GetAbsOrigin()
local caster = keys.target
local casterPos = caster:GetAbsOrigin()

local angle = RandomInt( 0, 360 )
local castDistance = RandomInt( 0, 320 )
local attackPoint = Vector( 0, 0, 0 )
local dy = castDistance * math.sin( angle )
local dx = castDistance * math.cos( angle )

if angle < 91 then
	attackPoint = Vector( casterPos.x + dx, casterPos.y + dy, casterPos.z )
elseif angle < 181 then 
	attackPoint = Vector( casterPos.x - dx, casterPos.y + dy, casterPos.z )
elseif angle < 271 then 
	attackPoint = Vector( casterPos.x - dx, casterPos.y - dy, casterPos.z )
else 
	attackPoint = Vector( casterPos.x + dx, casterPos.y - dy, casterPos.z )
end
local particle = ParticleManager:CreateParticle("particles/goku/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, trueCaster)
--ParticleManager:SetParticleControlEnt(particle, 0, trueCaster, PATTACH_POINT_FOLLOW, "attach_attack1", trueCaster:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(particle, 0, trueCasterPos + Vector(0,0,140))
ParticleManager:SetParticleControl(particle, 1, attackPoint)
ParticleManager:SetParticleControl(particle, 2, Vector(0.3, 0, 0))
Timers:CreateTimer( 0.3, function()
local ability = keys.ability
local radius = ability:GetLevelSpecialValueFor("aoe", (ability:GetLevel() - 1))
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local damagePerTick = damage / 20
local damageType = ability:GetAbilityDamageType()
local dummy = CreateUnitByName( "npc_dummy_unit", attackPoint, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy, "modifier_renzoku_dummy_2", {} )
local particle_dum = ParticleManager:CreateParticle("particles/goku/techies_suicide_base.vpcf", PATTACH_ABSORIGIN, dummy)
Timers:CreateTimer( 0.27, function()
	dummy:ForceKill( true )
	ParticleManager:DestroyParticle( particle_dum, false )
	return nil
	end
)
local units = FindUnitsInRadius( caster:GetTeamNumber(), casterPos, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
for k, v in pairs(units) do
	print(damage)
	local damageTable =
	{
		victim = v,
		attacker = trueCaster,
		damage = damagePerTick,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	ability:ApplyDataDrivenModifier(trueCaster, v, "modifier_renzoku_dan_stun", {})
end
	return nil
	end
)
end

function EndRenzoku( keys )
local caster = keys.caster
if caster.renzoku_dummy:IsAlive() then
	caster.renzoku_dummy:RemoveModifierByName("modifier_renzoku_dummy")
	caster.renzoku_dummy:ForceKill( true )
end
end