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
	
	local blinkIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge_e.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
end

function AutoAttack(keys)
	local caster = keys.caster
	local target = keys.target
	local targetPos = target:GetAbsOrigin()
	DeepPrintTable(keys)
	
	EmitSoundOn("Hero_Zuus.LightningBolt", target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_POINT, target)
	ParticleManager:SetParticleControl(particle, 0, targetPos)
    ParticleManager:SetParticleControl(particle, 1, targetPos + Vector(0, 0, 2000))
	
end