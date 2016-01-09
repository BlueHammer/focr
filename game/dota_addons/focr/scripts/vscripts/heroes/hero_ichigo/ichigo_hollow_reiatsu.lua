function HollowReiatsuCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_hollow_reiatsu", {})
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