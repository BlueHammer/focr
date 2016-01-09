function KyokushiStart( keys )
local soundfx = keys.soundfx
local caster = keys.caster
local target = keys.target
local casterPos = caster:GetAbsOrigin()
local targetPos = target:GetAbsOrigin()
local ability = keys.ability
local speed = ability:GetLevelSpecialValueFor("run_speed", (ability:GetLevel() - 1))
local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
local damageType = ability:GetAbilityDamageType()
local distance = (targetPos - casterPos):Length2D()
local duration = distance / speed - 0.2
local direction = caster:GetForwardVector()
local point = direction * (distance - 30) + casterPos
ability:ApplyDataDrivenModifier(caster, caster, "modifier_sensa_disable", {})
caster:AddEffects(EF_NODRAW)

Timers:CreateTimer( duration, function()
	caster:RemoveModifierByName("modifier_kyokushi_caster")
	target:RemoveModifierByName("modifier_kyokushi_target")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sensa_disable", {})
	FindClearSpaceForUnit(caster, point, false)
	caster:RemoveEffects( EF_NODRAW )
	local model = caster:FirstMoveChild()
	while model ~= nil do
	if model:GetClassname() == "dota_item_wearable" then
		model:AddEffects(EF_NODRAW) -- Set model hidden
	end
    model = model:NextMovePeer()
	end
	local lethalFactor = math.random(100)
	if lethalFactor <= 3 then
		EmitSoundOn(soundfx, target)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_mid.vpcf", PATTACH_ABSORIGIN, target)
		target:ForceKill( true )
		Timers:CreateTimer( 2, function()
			ParticleManager:DestroyParticle( particle, false )
			StopSoundOn(soundfx, target)
			return nil
			end
		)
	else
		local damageTable =
		{
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
	end
	if target:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_kyokushi_mark", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kyokushi_mark_caster", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_kyokushi_stun", {})
	end
	return nil
	end
)
end

function KyokushiCrit( keys )
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local critchance = ability:GetLevelSpecialValueFor("crit_chance", (ability:GetLevel() - 1))
local killchance = ability:GetLevelSpecialValueFor("lethal_chance", (ability:GetLevel() - 1))

if target:HasModifier("modifier_kyokushi_mark") then
	local gambleFactor = math.random(10)
	if gambleFactor <= 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_kyokushi_crit", {})
	end
end
end

function KyokushiKill( keys )
local target = keys.target
if target:IsAlive() and target:HasModifier("modifier_kyokushi_mark") then
	target:ForceKill( true )
end
end
