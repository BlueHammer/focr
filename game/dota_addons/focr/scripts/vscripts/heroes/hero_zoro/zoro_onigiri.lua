function OnigiriBlink(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local target = keys.target
	local targetPos = target:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local ability = keys.ability

	FindClearSpaceForUnit(caster, targetPos, false)
	ProjectileManager:ProjectileDodge(caster)
	
	local blinkIndex1 = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN, caster)
	local blinkIndex2 = ParticleManager:CreateParticle("particles/zoro/morphling_adaptive_strike.vpcf", PATTACH_ABSORIGIN, target)

	Timers:CreateTimer( 0.03, function()
		local blinkIndex3 = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_ABSORIGIN, caster)
		Timers:CreateTimer( 1, function()
			ParticleManager:DestroyParticle( blinkIndex1, false )
			ParticleManager:DestroyParticle( blinkIndex2, false )
			ParticleManager:DestroyParticle( blinkIndex3, false )
			return nil
			end
		)
		return nil
		end
	)
end
