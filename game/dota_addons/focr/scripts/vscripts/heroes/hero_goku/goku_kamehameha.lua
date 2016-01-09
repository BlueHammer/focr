function KamehamehaEffect( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local direction = caster:GetForwardVector()
local particlePoint = casterPos + direction * 1200

local particle = ParticleManager:CreateParticle("particles/goku/luna_lucent_beam_impact_shared_ti_5.vpcf", PATTACH_ABSORIGIN, caster)
--ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(particle, 1, casterPos + Vector(0,0,140))
ParticleManager:SetParticleControl(particle, 2, particlePoint + Vector(0,0,140))


local particle1 = ParticleManager:CreateParticle("particles/goku/invoker_tornado_trail_glow.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(particle1, 3, particlePoint + Vector(0,0,140))

end