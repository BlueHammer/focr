function SanzenSekaiDash( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local direction = caster:GetForwardVector()

local newPos = casterPos + direction * 153.85
print("dashing")
caster:SetAbsOrigin(newPos)
end

function SanzenSekaiEnd( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
print("deleting stuff")
FindClearSpaceForUnit(caster, casterPos, false)
end 

function SanzenSekaiParticle( keys )
local caster = keys.caster

local particle1 = ParticleManager:CreateParticle("particles/zoro/dark_seer_surge_e.vpcf", PATTACH_POINT_FOLLOW, caster)
local particle2 = ParticleManager:CreateParticle("particles/zoro/dark_seer_surge_e.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(particle1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)

Timers:CreateTimer( 1, function()
	ParticleManager:DestroyParticle( particle1, false )
	ParticleManager:DestroyParticle( particle2, false )
	end
)
end