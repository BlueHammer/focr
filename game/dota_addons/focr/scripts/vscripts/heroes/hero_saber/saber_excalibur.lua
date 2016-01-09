function Excalibur( keys )
local caster = keys.caster
local ability = keys.ability

ability:EndCooldown()
end

function ParticleAttach( keys )
local caster = keys.caster
local ability = keys.ability

caster.pParticle = ParticleManager:CreateParticle("particles/saber/oracle_fortune_channel.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(caster.pParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
end

function ParticleRemove( keys )
local caster = keys.caster
local ability = keys.ability

ParticleManager:DestroyParticle( caster.pParticle, false )
end

function ExcaliburFinish( keys )
local ability = keys.ability
local caster = keys.caster
local casterPos = keys.caster:GetAbsOrigin()
local point = keys.target_points[1]
local direction = (point - casterPos):Normalized()
local dummyPoint = direction * 2000 + casterPos
local dummy = CreateUnitByName( "npc_dummy_unit", dummyPoint, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy, "modifier_excalibur_dummy", {} )
local dummyPos = dummy:GetAbsOrigin()
local casterH = casterPos.y

local particle = ParticleManager:CreateParticle("particles/saber/luna_lucent_beam_impact_shared_ti_5_gold.vpcf", PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", casterPos, true)
ParticleManager:SetParticleControlEnt(particle, 2, dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", dummyPos, true)
ParticleManager:SetParticleControlEnt(particle, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", casterPos, true)

Timers:CreateTimer( 1, function()
	ParticleManager:DestroyParticle( particle, false )
	dummy:ForceKill( true )
	return nil
	end
)
end

