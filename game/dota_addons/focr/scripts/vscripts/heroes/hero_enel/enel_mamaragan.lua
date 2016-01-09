function Mamaragan(keys)
	local point = keys.target_points[1]
	local ability = keys.ability
	local caster = keys.caster
	local duration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) ) + 0.03
	local dummy = CreateUnitByName( "npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, "modifier_mamaragan_thinker", {} )
	Timers:CreateTimer( duration, function()
		dummy:ForceKill( true )
		return nil
	end )
end

function MamaraganStrike(keys)
	local target = keys.target
	local point = target:GetAbsOrigin()
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor( "strike_aoe", ( ability:GetLevel() - 1 ) )
	local damage = ability:GetLevelSpecialValueFor( "strike_damage", ( ability:GetLevel() - 1 ) )
	local minDistance = ability:GetLevelSpecialValueFor( "strike_min_dist", ( ability:GetLevel() - 1 ) )
	local maxDistance = ability:GetLevelSpecialValueFor( "strike_max_dist", ( ability:GetLevel() - 1 ) )
	local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = ability:GetAbilityTargetFlags()
	local damageType = ability:GetAbilityDamageType()
	local angle = RandomInt( 0, 360 )
	local castDistance = RandomInt( minDistance, maxDistance )
	local attackPoint = Vector( 0, 0, 0 )
	local dy = castDistance * math.sin( angle )
	local dx = castDistance * math.cos( angle )


	if angle < 91 then
		attackPoint = Vector( point.x + dx, point.y + dy, point.z )
	elseif angle < 181 then 
		attackPoint = Vector( point.x - dx, point.y + dy, point.z )
	elseif angle < 271 then 
		attackPoint = Vector( point.x - dx, point.y - dy, point.z )
	else 
		attackPoint = Vector( point.x + dx, point.y - dy, point.z )
	end
	
	local dummy = CreateUnitByName( "npc_dummy_unit", attackPoint, false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, "modifier_mamaragan_dummy", {} )
	local dummyPos = dummy:GetAbsOrigin()
	local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_POINT, dummy)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_ABSORIGIN, dummy)
	ParticleManager:SetParticleControl(particle1, 0, dummyPos)
    ParticleManager:SetParticleControl(particle1, 1, dummyPos + Vector(0, 0, 2000))
	EmitSoundOn("Hero_Zuus.LightningBolt", dummy)
	Timers:CreateTimer( 0.2, function()
		ParticleManager:DestroyParticle( particle1, false )
		ParticleManager:DestroyParticle( particle2, false )
		dummy:ForceKill( true )
		end
	)	
	
	local units = FindUnitsInRadius( caster:GetTeamNumber(), attackPoint, caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, targetFlag, 0, false )
	for k, v in pairs( units ) do
		local damageTable =
		{
			victim = v,
			attacker = caster,
			damage = damage,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
	end
	
end