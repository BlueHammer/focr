function ParticleAttach( keys )
local caster = keys.caster
local ability = keys.ability

caster.rasengan_Particle = ParticleManager:CreateParticle("particles/naruto/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(caster.rasengan_Particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack_rasengan", caster:GetAbsOrigin(), true)
end

function ParticleRemove( keys )
local caster = keys.caster
local ability = keys.ability

ParticleManager:DestroyParticle( caster.rasengan_Particle, true )
end

function RasenganStart(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() - 1))
	local aoe = ability:GetLevelSpecialValueFor("aoe", (ability:GetLevel() - 1))
	local direction = caster:GetForwardVector() * 2250 --speed

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	
	Timers:CreateTimer( 0.09, function()
		local projectileTable =
		{
			EffectName = "particles/naruto/morphling_waveform.vpcf",
			Ability = ability,
			vSpawnOrigin = point,
			vVelocity = direction,
			fDistance = distance,
			fStartRadius = aoe,
			fEndRadius = aoe,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			--iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			--iVisionRadius = ability.powershot_vision_radius,
			--iVisionTeamNumber = caster:GetTeamNumber()
		}
		local projectile = ProjectileManager:CreateLinearProjectile( projectileTable )
	return nil
	end
	)
	--local particle = ParticleManager:CreateParticle("particles/naruto/elder_titan_echo_stomp_impact_magical.vpcf", PATTACH_POINT_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	--ParticleManager:SetParticleControlOrientation(particle, 1, caster:GetForwardVector(), caster:GetForwardVector(), caster:GetForwardVector())
end