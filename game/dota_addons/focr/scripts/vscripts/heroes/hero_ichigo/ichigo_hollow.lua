function HollowActivate( keys )
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = keys.ability
	local thresholdptg = ability:GetLevelSpecialValueFor( "hp_trigger" , ability:GetLevel() - 1  )
	local health = caster:GetMaxHealth()
	local treshold = health/thresholdptg
	local dur = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )

	-- Apply the modifier
	Timers:CreateTimer( 0.03, function()	
		if caster:GetHealth() < treshold and not(caster:HasModifier("modifier_hollow")) and caster:IsAlive() and not(caster:HasModifier("modifier_bankai")) then
			ability:ApplyDataDrivenModifier( caster, caster, "modifier_hollow", { duration = dur })
			ability:ApplyDataDrivenModifier( caster, caster, "modifier_invulnerability", { duration = 1.0 })
			caster:Heal( health/5, caster )
			local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
			local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
			local targetFlag = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
			local unitOrder = FIND_ANY_ORDER
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 300.0, targetTeam,targetType, targetFlag, unitOrder, false)
	
			local target = math.random(0,#units)
			caster:MoveToTargetToAttack(units[target])
			
			caster:Purge( false, true, false, true, false)
		end
	end
	)
end

function HollowAttack ( keys )
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
	local unitOrder = FIND_ANY_ORDER
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 300.0, targetTeam,targetType, targetFlag, unitOrder, false)
	local target = math.random(0,#units)
	
	if caster:IsAttacking() then
		caster:SetAggroTarget(units[target])
	else
		caster:MoveToTargetToAttack(units[target])
	end
end

function HollowAttackBlink( keys )
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local target = keys.target
	local point = target:GetAbsOrigin()
	local direction = (point - casterPos):Normalized()
	
	ProjectileManager:ProjectileDodge(caster) 
	FindClearSpaceForUnit(caster, point, false)
	caster:SetForwardVector(direction)
end

function HollowKill( keys )
print("mr boi")
local target = keys.caster
	target:ForceKill( true )
end

function HollowSkillReplace( keys )
print("im checking for replacement")
local caster = keys.caster
local ability = keys.ability
local level = ability:GetLevel()

if level == 2 then
	print("IM REPLACING DA SKILL")
	caster:RemoveAbility(ability:GetAbilityName())
	local newAbility = caster:AddAbility("ichigo_hollow_reiatsu")
	caster:RemoveModifierByName("modifier_hollow_passive")
	newAbility:SetLevel(2)
	newAbility:SetAbilityIndex(4)
end
end