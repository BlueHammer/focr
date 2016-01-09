function BladeStrikeBlink(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local target = keys.target
	local targetPos = target:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local ability = keys.ability
	local level_multiplier = ability:GetLevelSpecialValueFor("lvl_multiplier", (ability:GetLevel() - 1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local damageType = ability:GetAbilityDamageType()
	local level = caster:GetLevel()
	

	FindClearSpaceForUnit(caster, targetPos, false)
	ProjectileManager:ProjectileDodge(caster)
	if level <= 21 then 
		local damageTable =
		{
			victim = target,
			attacker = caster,
			damage = damage + level * level_multiplier,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
	else
		local damageTable =
		{
			victim = target,
			attacker = caster,
			damage = damage + 1050,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
	end
	
	local blinkIndex1 = ParticleManager:CreateParticle("particles/eren_jaeger/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN, caster)


	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex1, false )
		return nil
		end
	)

end
