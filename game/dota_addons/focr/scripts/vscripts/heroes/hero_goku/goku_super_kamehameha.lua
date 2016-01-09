function KamehamehaInitialize( keys )
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = keys.ability	
	local ability_level = ability:GetLevel() - 1
	local point = keys.target_points[1]

	-- Ability variables
	--[[ability.powershot_damage_percent = 0.0
	ability.powershot_traveled = 0
	ability.powershot_direction = (point - caster_location):Normalized()
	ability.powershot_source = caster_location
	ability.powershot_currentPos = caster_location
	ability.powershot_percent_movespeed = 100
	ability.powershot_units_array = {}
	ability.powershot_units_hit = {}

	ability.powershot_interval_damage =  ability:GetLevelSpecialValueFor("damage_per_interval", ability_level)
	ability.powershot_max_range = ability:GetLevelSpecialValueFor( "arrow_range", ability_level )
	ability.powershot_max_movespeed = ability:GetLevelSpecialValueFor( "arrow_speed", ability_level )
	ability.powershot_radius = ability:GetLevelSpecialValueFor( "arrow_width", ability_level )
	ability.powershot_vision_radius = ability:GetLevelSpecialValueFor( "vision_radius", ability_level )	
	ability.powershot_vision_duration = ability:GetLevelSpecialValueFor( "vision_duration", ability_level )
	ability.powershot_damage_reduction = ability:GetLevelSpecialValueFor( "damage_reduction", ability_level )
	ability.powershot_speed_reduction = ability:GetLevelSpecialValueFor( "speed_reduction", ability_level )
	ability.powershot_tree_width = ability:GetLevelSpecialValueFor("tree_width", ability_level) * 2 -- Double the radius because the original feels too small--]]
	
	caster.kamehameha_damage_percent = 0.0
	caster.kamehameha_direction = (point - casterPos):Normalized()
	caster.kamehameha_source = casterPos
	
	caster.kamehameha_original_damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	caster.kamehameha_interval_damage = ability:GetLevelSpecialValueFor("damage_per_interval", ability_level)
	caster.kamehameha_range = ability:GetLevelSpecialValueFor( "distance", ability_level )
	caster.kamehameha_radius = ability:GetLevelSpecialValueFor( "radius", ability_level )
	caster.kamehameha_speed = ability:GetLevelSpecialValueFor( "speed", ability_level )
	caster.kamehameha_ability = ability
	caster.kamehameha_damage_type = ability:GetAbilityDamageType()
	caster.modifier_duration = 0
	
	caster.kamehameha_particle = ParticleManager:CreateParticle("particles/goku/kamehameha_glow.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(caster.kamehameha_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster.kamehameha_particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
end

--[[
	Author: kritth
	Date: 01.10.2015.
	Init: Charge the damage per duration
]]
function KamehamehaCharge( keys )
	local caster = keys.caster
	if caster:HasModifier("modifier_super_saiyan") then
		local saiyan_modifier = caster:FindModifierByName("modifier_super_saiyan")
		caster.modifier_duration = saiyan_modifier:GetRemainingTime()
	else
		caster.modifier_duration = 0.0
	end
	
	-- Fail check
	if not caster.kamehameha_damage_percent then
		caster.kamehameha_damage_percent = 0.0
	end
	print(modifier_duration)
	if caster.modifier_duration >= 0.1 then
		caster.kamehameha_damage_percent = caster.kamehameha_damage_percent + caster.kamehameha_interval_damage
	else
		print("INTERRUPTING")
		caster:InterruptChannel()
		caster:Interrupt()
	end

end

--[[
	Author: kritth, Pizzalol
	Date: 01.10.2015.
	Main: Start traversing upon timer while providing vision, reducing damage and speed per units hit, and also destroy trees
]]
function KamehamehaProjectile( keys )
	-- Variables
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	--local ability = keys.ability
	local particlePoint = casterPos + caster.kamehameha_direction * 1200
	local particlePoint_ex = casterPos + caster.kamehameha_direction * 200
	
	-- Stop sound event and fire new one, can do this in datadriven but for continuous purpose, let's put it here
	ParticleManager:DestroyParticle( caster.kamehameha_particle, false )
	print("DESTROY DEM PARTICLUS")
	-- Create projectile
	local projectileTable =
	{
		EffectName = "particles/invisible.vpcf",
		Ability = caster.kamehameha_ability,
		vSpawnOrigin = caster.kamehameha_source,
		vVelocity = Vector(caster.kamehameha_direction.x * caster.kamehameha_speed, caster.kamehameha_direction.y * caster.kamehameha_speed, 0),
		fDistance = caster.kamehameha_range,
		fStartRadius = caster.kamehameha_radius,
		fEndRadius = caster.kamehameha_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		--iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		--iVisionRadius = ability.powershot_vision_radius,
		--iVisionTeamNumber = caster:GetTeamNumber()
	}
	caster.kamehameha_projectile = ProjectileManager:CreateLinearProjectile( projectileTable )
	local particle = ParticleManager:CreateParticle("particles/goku/kamehamehasuper.vpcf", PATTACH_ABSORIGIN, caster)
	--ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, casterPos + Vector(0,0,140))
	ParticleManager:SetParticleControl(particle, 2, particlePoint + Vector(0,0,140))
	
	
	local particle1 = ParticleManager:CreateParticle("particles/goku/kamehainvoker_tornado_trail_glow.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 3, particlePoint + Vector(0,0,140))
	
	local particle2 = ParticleManager:CreateParticle("particles/goku/superkameha_glow.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 3, particlePoint_ex + Vector(0,0,140))
	-- Register units around caster
end

--[[
	Author: kritth
	Date: 5.1.2015.
	Helper: Calculate distance between two points
]]
function KamehamehaDamage( keys )
local target = keys.target
local caster = keys.caster
--local ability = keys.ability
local damageType = caster.kamehameha_damage_type
local damageTable =
{
	victim = target,
	attacker = caster,
	damage = caster.kamehameha_original_damage + caster.kamehameha_damage_percent * caster.kamehameha_original_damage,
	damage_type = damageType
}
ApplyDamage( damageTable )
end