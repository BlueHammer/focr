function ParticleAttach( keys )
local caster = keys.caster
local ability = keys.ability

caster.genki_Particle = ParticleManager:CreateParticle("particles/goku/oracle_fortune_channel_core.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(caster.genki_Particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
end

function ParticleRemove( keys )
local caster = keys.caster
local ability = keys.ability

ParticleManager:DestroyParticle( caster.genki_Particle, false )
end

function GenkiDamaThrow( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local point = keys.target_points[1]
local meteor_fly_original_point = casterPos + Vector (0, 0, 300)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/goku/biggu_bangu_throw.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, point)
ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(0.2, 0, 0))
Timers:CreateTimer( 0.2, function()
	local impact_bang = ParticleManager:CreateParticle("particles/goku/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(impact_bang, 0, point)
	ParticleManager:SetParticleControl(impact_bang, 1, Vector(1000,1000,1000))
	local impact_crater = ParticleManager:CreateParticle("particles/goku/gyro_call_down_explosion_impact_a.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(impact_crater, 3, point)
	ParticleManager:SetParticleControl(impact_crater, 5, Vector(1000,1000,1000))
	return nil
	end
)
end