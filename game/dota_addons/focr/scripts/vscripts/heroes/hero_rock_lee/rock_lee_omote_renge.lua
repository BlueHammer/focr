function OmoteRengeStart( keys )
local ability = keys.ability
local caster = keys.caster
local target = keys.target
local casterPos = caster:GetAbsOrigin()
local targetPos = target:GetAbsOrigin()
local direction = caster:GetForwardVector()
local distance = (targetPos - casterPos):Length2D()
local point = direction * -180 + targetPos
local target_duration = ability:GetLevelSpecialValueFor("duration_target", (ability:GetLevel() - 1))

FindClearSpaceForUnit(caster, point, false)
target:AddEffects(EF_NODRAW)
Timers:CreateTimer( target_duration, function()
	target:RemoveEffects( EF_NODRAW )
	if target:IsRealHero() or (target:HasModifier("modifier_illusion") and target:IsConsideredHero()) then --PLEASE EVALUATE REQUIREMENT
		local model = target:FirstMoveChild()
		while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" then
			model:AddEffects(EF_NODRAW) -- Set model hidden
		end
		model = model:NextMovePeer()
		end
	end
	
	local particle = ParticleManager:CreateParticle("particles/rocklee/rubick_telekinesis_land_force.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	
	local particle1 = ParticleManager:CreateParticle("particles/rocklee/earthshaker_echoslam_start_cracks.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle1, 1, Vector(14, 0, 0))
return nil
end
)
end