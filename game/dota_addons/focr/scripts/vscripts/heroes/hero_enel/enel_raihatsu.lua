function Raihatsu(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
	local dummy = CreateUnitByName( "npc_dummy_unit", casterPos, false, caster, caster, caster:GetTeamNumber() )
	local dummyPos = dummy:GetAbsOrigin()
	ability:ApplyDataDrivenModifier( caster, dummy, "modifier_raihatsu_dummy", {} )
	local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge_e.vpcf", PATTACH_ABSORIGIN, dummy)
	
	Timers:CreateTimer( 0.5, function()
		local target = FindUnitsInRadius(caster:GetTeam(), casterPos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		
		ParticleManager:DestroyParticle( particle1, false )
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_POINT, dummy)
		local particle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_ABSORIGIN, dummy)
		ParticleManager:SetParticleControl(particle2, 0, dummyPos)
        ParticleManager:SetParticleControl(particle2, 1, dummyPos + Vector(0, 0, 2000))
		
		Timers:CreateTimer( 0.5, function()
			dummy:ForceKill( true )
			ParticleManager:DestroyParticle( particle2, false )
			ParticleManager:DestroyParticle( particle3, false )
		end
		)
		
		for i, enemyTarget in ipairs(target) do 
			ability:ApplyDataDrivenModifier(keys.caster, enemyTarget, "modifier_raihatsu", {})
			ApplyDamage({ victim = enemyTarget, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
		end
	end
	)
end