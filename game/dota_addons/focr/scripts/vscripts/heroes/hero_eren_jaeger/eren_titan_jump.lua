function JumpStart( keys )
local caster = keys.caster
caster.JumpPoint = keys.target_points[1]
local ability = keys.ability
local damageType = ability:GetAbilityDamageType()
local strength = caster:GetStrength()
local strength_multiplier = ability:GetLevelSpecialValueFor("strength_multiplier", (ability:GetLevel() - 1))
local damage = strength * strength_multiplier
local casterPos = caster:GetAbsOrigin()
local radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
local particle = ParticleManager:CreateParticle("particles/eren_jaeger/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl( particle, 1, Vector(450, 450, 450) )
local particle2 = ParticleManager:CreateParticle("particles/eren_jaeger/espirit_spawn_groundburst2.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl( particle2, 1, casterPos )
Timers:CreateTimer( 1, function()
	ParticleManager:DestroyParticle( particle, false )
	ParticleManager:DestroyParticle( particle2, false )
	return nil
	end
)
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
end
end

function JumpDash( keys )
local caster = keys.caster
local point = caster.JumpPoint
local casterPos = caster:GetAbsOrigin()
local direction = caster:GetForwardVector()
if caster.absoluteCasterPos == nil then
	caster.absoluteCasterPos = casterPos
		Timers:CreateTimer( 0.33, function()
		caster.absoluteCasterPos = nil
		return nil
		end
	)
end
print(caster.absoluteCasterPos)
print(point)
print(range)
local range = ( point - caster.absoluteCasterPos ):Length2D()
local newPos = casterPos + direction * range / 10
local referencePoint = caster.absoluteCasterPos + direction * range / 2
local heightOperator = (Vector(casterPos.x, casterPos.y, referencePoint.z) - referencePoint):Length2D() * (Vector(casterPos.x, casterPos.y, referencePoint.z)  - referencePoint):Length2D() * -1
print(heightOperator)
local height = heightOperator / ( range * range / 350 / 4 )  + 350
caster:SetAbsOrigin(Vector(newPos.x, newPos.y, caster.absoluteCasterPos.z + height))
end

function JumpDashEnd( keys )
local caster = keys.caster
if caster:HasModifier("modifier_titan_form") then
	local ability = keys.ability
	local casterPos = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
	
	FindClearSpaceForUnit(caster, casterPos, false)
	
	local strength_multiplier = ability:GetLevelSpecialValueFor("strength_multiplier", (ability:GetLevel() - 1))
	local damageType = ability:GetAbilityDamageType()
	local strength = caster:GetStrength()
	local damage = strength * strength_multiplier
	
	Timers:CreateTimer( 0.12, function()	
		local particle = ParticleManager:CreateParticle("particles/eren_jaeger/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 1, Vector(450, 450, 450) )
		local particle2 = ParticleManager:CreateParticle("particles/eren_jaeger/espirit_spawn_groundburst2.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle2, 1, casterPos )
		Timers:CreateTimer( 1, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:DestroyParticle( particle2, false )
			return nil
			end
		)
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
		end
		return nil
		end
	)
else
	local casterPos = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, casterPos, false)
end
end