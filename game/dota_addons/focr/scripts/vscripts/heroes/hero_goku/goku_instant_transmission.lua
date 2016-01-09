function Blink(keys)
local point = keys.target_points[1]
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local pid = caster:GetPlayerID()
local difference = point - casterPos
local ability = keys.ability
local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

if difference:Length2D() > range then
	point = casterPos + (point - casterPos):Normalized() * range
end

FindClearSpaceForUnit(caster, point, false)
ProjectileManager:ProjectileDodge(caster)

Timers:CreateTimer( 0.30, function()		
	local blinkIndex = ParticleManager:CreateParticle("particles/goku/status_invisibility_star_instantt.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
	return nil
	end
)
end

function BlinkGlobal(keys)
local point = keys.target_points[1]
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local pid = caster:GetPlayerID()
local difference = point - casterPos
local ability = keys.ability
local range = 9999999

if difference:Length2D() > range then
	point = casterPos + (point - casterPos):Normalized() * range
end

FindClearSpaceForUnit(caster, point, false)
ProjectileManager:ProjectileDodge(caster)

Timers:CreateTimer( 0.30, function()		
	local blinkIndex = ParticleManager:CreateParticle("particles/goku/status_invisibility_star_instantt.vpcf", PATTACH_ABSORIGIN, caster)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle2, 1, Vector(150, 150, 150))
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		ParticleManager:DestroyParticle( particle2, false )
		return nil
		end
	)
	return nil
	end
)
end