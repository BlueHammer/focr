function AirStrike( keys )
local caster = keys.caster
local point = keys.target_points[1]
local casterPos = caster:GetAbsOrigin()
local ability = keys.ability
local dummyPoint1 = (point - casterPos):Normalized() * 250 + casterPos
local dummyPoint2 = (point - casterPos):Normalized() * 750 + casterPos
local dummyPoint3 = (point - casterPos):Normalized() * 1250 + casterPos
local dummyPoint4 = (point - casterPos):Normalized() * 0 + casterPos
local dummyPoint5 = (point - casterPos):Normalized() * 500 + casterPos
local dummyPoint6 = (point - casterPos):Normalized() * 1000 + casterPos
local dummyPoint7 = (point - casterPos):Normalized() * 1500 + casterPos

local dummy1 = CreateUnitByName( "npc_dummy_unit", dummyPoint1, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy1, "modifier_air_strike_dummy", {} )
local dummy2 = CreateUnitByName( "npc_dummy_unit", dummyPoint2, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy2, "modifier_air_strike_dummy", {} )
local dummy3 = CreateUnitByName( "npc_dummy_unit", dummyPoint3, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy3, "modifier_air_strike_dummy", {} )
local dummy4 = CreateUnitByName( "npc_dummy_unit", dummyPoint4, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy4, "modifier_air_strike_dummy", {} )
local dummy5 = CreateUnitByName( "npc_dummy_unit", dummyPoint5, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy5, "modifier_air_strike_dummy", {} )
local dummy6 = CreateUnitByName( "npc_dummy_unit", dummyPoint6, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy6, "modifier_air_strike_dummy", {} )
local dummy7 = CreateUnitByName( "npc_dummy_unit", dummyPoint7, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy7, "modifier_air_strike_dummy", {} )

local particle1 = ParticleManager:CreateParticle("particles/saber/air_strike_master.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy1)
local particle2 = ParticleManager:CreateParticle("particles/saber/air_strike_master.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy2)
local particle3 = ParticleManager:CreateParticle("particles/saber/air_strike_master.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy3)
local particle4 = ParticleManager:CreateParticle("particles/saber/air_strike_master_b.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy4)
local particle5 = ParticleManager:CreateParticle("particles/saber/air_strike_master_b.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy5)
local particle6 = ParticleManager:CreateParticle("particles/saber/air_strike_master_b.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy6)
local particle7 = ParticleManager:CreateParticle("particles/saber/air_strike_master_b.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy7)

Timers:CreateTimer( 2, function()
	ParticleManager:DestroyParticle( particle1, false )
	ParticleManager:DestroyParticle( particle2, false )
	ParticleManager:DestroyParticle( particle3, false )
	ParticleManager:DestroyParticle( particle4, false )
	ParticleManager:DestroyParticle( particle5, false )
	ParticleManager:DestroyParticle( particle6, false )
	ParticleManager:DestroyParticle( particle7, false )
	dummy1:ForceKill( true )
	dummy2:ForceKill( true )
	dummy3:ForceKill( true )
	dummy4:ForceKill( true )
	dummy5:ForceKill( true )
	dummy6:ForceKill( true )
	dummy7:ForceKill( true )
	end
)
end
