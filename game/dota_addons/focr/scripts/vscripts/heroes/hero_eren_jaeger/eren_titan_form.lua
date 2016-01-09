function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	if caster.caster_model_scale == nil then
		caster.caster_model_scale = caster:GetModelScale()
	end

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetModelScale(6.0)
end

function ModelSwapEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetModelScale(caster.caster_model_scale)
end

function TitanFormStomp( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local ability = keys.ability
local radius = ability:GetLevelSpecialValueFor( "knockback_aoe", ( ability:GetLevel() - 1 ) )
local strength = caster:GetStrength()
local damage = strength * 2
local damageType = ability:GetAbilityDamageType()
local units = FindUnitsInRadius( caster:GetTeamNumber(), casterPos, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
for k, v in pairs(units) do
	local damageTable =
	{
		victim = v,
		attacker = caster,
		damage = damage,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	ability:ApplyDataDrivenModifier(caster, v, "modifier_titan_knockback", {})
	local targetPos = v:GetAbsOrigin()
	v.knockback_direction = (targetPos - casterPos):Normalized()
	v.originalPos = targetPos
end
end

function TitanFormKnockback( keys )
local target = keys.target
local targetPos = target:GetAbsOrigin()
local absoluteTargetPos = target.originalPos
local caster = keys.caster
local direction = target.knockback_direction
local newPos = targetPos + direction * 12.5
local referencePoint = absoluteTargetPos + direction * 75
local heightOperator = ((targetPos - referencePoint):Length2D()) * ((targetPos - referencePoint):Length2D()) * -1
print(heightOperator)
local height = heightOperator / 50 + 112.5
target:SetAbsOrigin(Vector(newPos.x, newPos.y, absoluteTargetPos.z + height))
end

function TitanFormKnockbackEnd( keys )
local target = keys.target
local targetPos = target:GetAbsOrigin()
FindClearSpaceForUnit(target, targetPos, false)
end

function TitanFormStart( keys )
local caster = keys.caster
local ability = keys.ability
if not caster:HasModifier("modifier_titan_form") then
	local root = caster:GetAbilityByIndex(5)
	local rootlevel = root:GetLevel()
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	local ability3 = caster:GetAbilityByIndex(2)
	local ability4 = caster:GetAbilityByIndex(3)
	local ability5 = caster:GetAbilityByIndex(4)
	local ability6 = caster:GetAbilityByIndex(5)

	caster.ability1level = ability1:GetLevel()
	caster.ability2level = ability2:GetLevel()
	caster.ability3level = ability3:GetLevel()
	caster.ability4level = ability4:GetLevel()
	caster.ability5level = ability5:GetLevel()
	caster.ability6level = ability6:GetLevel()
	
	caster.ability6cooldown = ability6:GetCooldownTimeRemaining()

	caster:RemoveAbility("eren_one_edge_blade_strike")
	caster:RemoveAbility("eren_grappling_dash")
	caster:RemoveAbility("eren_determination")
	caster:RemoveAbility("eren_3d_maneuver_gear")
	caster:RemoveAbility("eren_titan_form")
	caster:RemoveAbility("rubick_empty1")
	
	local fury_scream_level = 0
	local overwhelming_hand_level = 0

	local newAbility1 = caster:AddAbility("eren_titan_boulder_throw")
	newAbility1:SetLevel(rootlevel)
	newAbility1:SetAbilityIndex(0)

	if rootlevel >= 2 then
		fury_scream_level = 1
	else
		fury_scream_level = 0
	end
		
	local newAbility2 = caster:AddAbility("eren_titan_fury_scream")
	newAbility2:SetLevel(fury_scream_level)
	newAbility2:SetAbilityIndex(1)
	
	if rootlevel < 3 then
		overwhelming_hand_level = 0
	elseif rootlevel == 3 then
		overwhelming_hand_level = 1
	elseif rootlevel == 4 then
		overwhelming_hand_level = 2
	end
	
	local newAbility3 = caster:AddAbility("eren_titan_overwhelming_hand")
	newAbility3:SetLevel(overwhelming_hand_level)
	newAbility3:SetAbilityIndex(2)	

	local newAbility4 = caster:AddAbility("eren_titan_jump")
	newAbility4:SetLevel(1)
	newAbility4:SetAbilityIndex(3)
	
	local newAbility5 = caster:AddAbility("eren_titan_ground_slam")
	newAbility5:SetLevel(1)
	newAbility5:SetAbilityIndex(4)
	
	local newAbility6 = caster:AddAbility("eren_titan_form")
	newAbility6:SetLevel(caster.ability6level)
	newAbility6:SetAbilityIndex(5)
	newAbility6:StartCooldown(caster.ability6cooldown)

end
end

function TitanFormEnd( keys )
local caster = keys.caster
local ability6 = caster:GetAbilityByIndex(5) --CHANGE THIS OK
caster.ability6cooldown = ability6:GetCooldownTimeRemaining()
caster:RemoveAbility("eren_titan_boulder_throw")
caster:RemoveAbility("eren_titan_fury_scream")
caster:RemoveAbility("eren_titan_overwhelming_hand")
caster:RemoveAbility("eren_titan_jump")
caster:RemoveAbility("eren_titan_ground_slam")
caster:RemoveAbility("eren_titan_form")
caster.PreviousPos = nil

local newAbility1 = caster:AddAbility("eren_one_edge_blade_strike")
newAbility1:SetLevel(caster.ability1level)
newAbility1:SetAbilityIndex(0)

local newAbility2 = caster:AddAbility("eren_grappling_dash")
newAbility2:SetLevel(caster.ability2level)
newAbility2:SetAbilityIndex(1)

local newAbility3 = caster:AddAbility("eren_determination")
newAbility3:SetLevel(caster.ability3level)
newAbility3:SetAbilityIndex(2)

local newAbility4 = caster:AddAbility("eren_3d_maneuver_gear")
newAbility4:SetLevel(caster.ability4level)
newAbility4:SetAbilityIndex(3)

local newAbility5 = caster:AddAbility("rubick_empty1")
newAbility5:SetLevel(caster.ability5level)
newAbility5:SetAbilityIndex(4)

local newAbility6 = caster:AddAbility("eren_titan_form")
newAbility6:SetLevel(caster.ability6level)
newAbility6:SetAbilityIndex(5)
newAbility6:StartCooldown(caster.ability6cooldown)

end

function StompCycleStart( keys )
local caster = keys.caster
Timers:CreateTimer( 0.03, function()
	if caster:HasModifier("modifier_titan_form") then
		print("cycle")
		local movespeed = caster:GetIdealSpeed()
		print(movespeed)
		local nextstomp = 200 / movespeed
		local casterPos = caster:GetAbsOrigin()
		local strength = caster:GetStrength()
		local damage = strength / 2
		if caster.PreviousPos == nil then
			caster.PreviousPos = casterPos
		end
		if caster.PreviousPos ~= casterPos and not caster:HasModifier("modifier_jump_dash") and not caster:IsIdle() then
			local particle = ParticleManager:CreateParticle("particles/eren_jaeger/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 1, Vector(300, 300, 300) )
			local particle2 = ParticleManager:CreateParticle("particles/eren_jaeger/espirit_spawn_groundburst2.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle2, 1, casterPos )
			Timers:CreateTimer( 1, function()
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:DestroyParticle( particle2, false )
			return nil
			end
			)
			local units = FindUnitsInRadius( caster:GetTeamNumber(), casterPos, caster, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
			for k, v in pairs(units) do
				local damageTable =
				{
					victim = v,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL
				}
			ApplyDamage( damageTable )
			end
		end
		caster.PreviousPos = casterPos
		return nextstomp
	else
	print("no cycle")
	return nil
	end
	end
)
end