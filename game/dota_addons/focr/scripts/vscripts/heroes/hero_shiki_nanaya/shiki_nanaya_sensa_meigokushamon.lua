function MeigokushamonStart( keys )
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
	caster:RemoveModifierByName("modifier_sensa_meigokushamon_caster")
	target:RemoveModifierByName("modifier_sensa_meigokushamon_target")
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
	local damageTable =
	{
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
	return nil
	end
)
end