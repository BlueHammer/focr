function BoulderThrow( keys )
print("throwing")
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local point = keys.target_points[1]
local meteor_fly_original_point = casterPos + Vector (0, 0, 900)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/eren_jaeger/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, point)
ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(0.2, 0, 0))

Timers:CreateTimer( 0.2, function()
	local impact_throw = ParticleManager:CreateParticle("particles/eren_jaeger/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(impact_throw, 0, point)
	return nil
	end
)
end