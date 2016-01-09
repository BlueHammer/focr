function TatsumakiStart( keys )
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local ability = keys.ability
local dummy = CreateUnitByName( "npc_dummy_unit", casterPos, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy, "modifier_tatsumaki_dummy", {} )
ability:ApplyDataDrivenModifier( caster, dummy, "modifier_tatsumaki_dummy_thinker", {} )

Timers:CreateTimer( 2.5, function()
	dummy:ForceKill( true )
	dummy.Owner = nil
	end
)
end

function TatsumakiCheck( keys )
local caster = keys.caster
local dummy = keys.target
local dummyPos = dummy:GetAbsOrigin()
local ability = keys.ability
local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
dummy.Owner = caster

if dummy.InitialTime == nil then
	dummy.InitialTime = 2
end

dummy.InitialTime = dummy.InitialTime - 0.03

if dummy.InitialTime > 0 then
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local unitOrder = FIND_ANY_ORDER
	
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), dummyPos, nil, radius, targetTeam,
		targetType, targetFlag, unitOrder, false
	)
	
	for k,v in pairs(units) do
		if not(v:HasModifier("modifier_tatsumaki_cyclone")) then
			ability:ApplyDataDrivenModifier( dummy, v, "modifier_tatsumaki_cyclone", {duration = dummy.InitialTime})
		end
	end
else
	dummy:RemoveModifierByName("modifier_tatsumaki_dummy_thinker")
	dummy.InitialTime = nil
end
end


function TatsumakiCyclone( keys )
local target = keys.target
local targetPos = target:GetAbsOrigin()
local dummy = keys.caster
local dummyPos = dummy:GetAbsOrigin()

if target.InitialRange == nil then
	local difference = targetPos - dummyPos
	target.InitialRange = difference:Length2D()
end

if target.InitialAngle == nil then
	if (targetPos.x - dummyPos.x) >= 0 then
		if (targetPos.y - dummyPos.y) >= 0 then
			target.InitialAngle = math.atan((targetPos.y - dummyPos.y)/(targetPos.x - dummyPos.x))
		else
			target.InitialAngle = math.atan((dummyPos.y - targetPos.y)/(targetPos.x - dummyPos.x)) + 180
		end
	else
		if (targetPos.y - dummyPos.y) >= 0 then
			target.InitialAngle = math.atan((targetPos.y - dummyPos.y)/(dummyPos.x - targetPos.x)) + 90
		else
			target.InitialAngle = math.atan((dummyPos.y - targetPos.y)/(dummyPos.x - targetPos.x)) + 270
		end
	end
end

target.InitialAngle = target.InitialAngle + 0.5
local rvalue = target.InitialRange + 200 * target.InitialAngle / 360
local xvalue = rvalue*math.cos(target.InitialAngle)
local yvalue = rvalue*math.sin(target.InitialAngle)
local newVector = dummyPos + Vector(xvalue, yvalue, 400)
target:SetAbsOrigin(newVector)
end

function TatsumakiEnd( keys )
local target = keys.target
local targetPos = target:GetAbsOrigin()
local caster = keys.caster
local trueowner = caster.Owner
local ability = keys.ability
target.InitialAngle = nil
target.InitialRange = nil
ability:ApplyDataDrivenModifier( trueowner, target, "modifier_tatsumaki_cyclone_slam", {} )
target:SetAbsOrigin(targetPos + Vector(0,0, 400))
end

function TatsumakiSlam( keys )
local target = keys.target
local targetPos = target:GetAbsOrigin()
local newHeight = targetPos.z - 57
target:SetAbsOrigin(Vector(targetPos.x, targetPos.y, newHeight))
end

function TatsumakiSlamDamage( keys )
local target = keys.target
local targetPos = target:GetAbsOrigin()
local caster = keys.caster
local ability = keys.ability
local strength = caster:GetStrength()
local damage = strength*2
local damageType = ability:GetAbilityDamageType()
local damageTable =
{
	victim = target,
	attacker = caster,
	damage = damage,
	damage_type = damageType
}
ApplyDamage( damageTable )
FindClearSpaceForUnit(target, targetPos, false)
end
