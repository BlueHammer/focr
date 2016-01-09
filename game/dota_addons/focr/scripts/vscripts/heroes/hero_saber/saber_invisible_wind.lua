function InvisibleWind( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local casterPos = caster:GetAbsOrigin()
	
	local projectile_speed = ability:GetLevelSpecialValueFor( "projectile_speed" , ability:GetLevel() - 1  )
	local aoe = ability:GetLevelSpecialValueFor( "aoe" , ability:GetLevel() - 1  )
	local aoe_damage = ability:GetLevelSpecialValueFor( "aoe_damage" , ability:GetLevel() - 1  )
	local main_target_damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local agi_pct = ability:GetLevelSpecialValueFor( "agi_pct" , ability:GetLevel() - 1  )
	local caster_agi = caster:GetAgility()
	local agi_bonus_damage = agi_pct * 0.01 * caster_agi
	local aoe_target_total_damage = aoe_damage + agi_bonus_damage
	
	local projectile_info = 
	{
		EffectName = "particles/saber/invoker_tornado.vpcf",
		Ability = ability,
		vSpawnOrigin = casterPos,
		Target = target,
		Source = caster,
		bHasFrontalCone = false,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,
		bProvidesVision = false,
		--iVisionRadius = vision_radius,
		--iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateTrackingProjectile(projectile_info)
end

function ProjectileImpact( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local targetPos = target:GetAbsOrigin()
	local casterPos = caster:GetAbsOrigin()
	
	local projectile_speed = ability:GetLevelSpecialValueFor( "projectile_speed" , ability:GetLevel() - 1  )
	local aoe = ability:GetLevelSpecialValueFor( "aoe" , ability:GetLevel() - 1  )
	local aoe_damage = ability:GetLevelSpecialValueFor( "aoe_damage" , ability:GetLevel() - 1  )
	local main_target_damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local agi_pct = ability:GetLevelSpecialValueFor( "agi_pct" , ability:GetLevel() - 1  )
	local caster_agi = caster:GetAgility()
	local agi_bonus_damage = agi_pct * 0.01 * caster_agi
	local aoe_target_total_damage = aoe_damage + agi_bonus_damage
	local main_target_extra_damage = main_target_damage - aoe_damage
	
	local blinkIndex = ParticleManager:CreateParticle("particles/saber/tornado_blast.vpcf", PATTACH_ABSORIGIN, target)
	Timers:CreateTimer( 2, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
	
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local unitOrder = FIND_ANY_ORDER
	
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), targetPos, nil, aoe, targetTeam,
		targetType, targetFlag, unitOrder, false
	)
	
	for k,v in pairs(units) do
		local damagetable = {
		victim = v,
		attacker = caster,
		damage = aoe_target_total_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}
	
		ApplyDamage(damagetable)
		ability:ApplyDataDrivenModifier( caster, v, "modifier_invisible_wind_silence", {})
	end
	
	local target_damagetable = {
		victim = target,
		attacker = caster,
		damage = main_target_extra_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}
		
	ApplyDamage(target_damagetable)
	
	local distance = (casterPos - targetPos):Length2D()
	local direction = (casterPos - targetPos):Normalized()
	local traveled_distance = 0
	local speed = 50
	local target_location = targetPos
	
	--Moving the target
	Timers:CreateTimer(0, function()
		if traveled_distance < distance then
			target_location = target_location + direction * speed
			target:SetAbsOrigin(target_location)
			traveled_distance = traveled_distance + speed
			return 0.03
		else
			FindClearSpaceForUnit( target, target_location, false )
		end

	end)	
end
	