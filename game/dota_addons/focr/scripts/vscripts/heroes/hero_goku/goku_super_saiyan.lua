function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model
	caster.main_ability = caster:GetAbilityByIndex(0)
	local cooldown = caster.main_ability:GetCooldownTimeRemaining()
	caster.ability_level = caster.main_ability:GetLevel()
	caster.main_ability_name = caster.main_ability:GetAbilityName()

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	if caster.caster_model_scale == nil then
		caster.caster_model_scale = caster:GetModelScale()
	end

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetModelScale(1.40)
	
	caster:RemoveAbility(caster.main_ability_name)
	local newAbility = caster:AddAbility("goku_super_kamehameha")
	newAbility:SetAbilityIndex(0)
	newAbility:StartCooldown(cooldown)
	newAbility:SetLevel(caster.ability_level)
	--[[caster:SwapAbilities(caster.main_ability_name, "goku_super_kamehameha", true, false)
	local newAbility = caster:GetAbilityByIndex(0)
	newAbility:StartCooldown(cooldown)
	newAbility:SetLevel(caster.ability_level)--]]
end

function ModelSwapEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetModelScale(caster.caster_model_scale)
	
	--[[local oldAbility = caster:GetAbilityByIndex(0)
	local cooldown = oldAbility:GetCooldownTimeRemaining()
	caster:SwapAbilities("goku_super_kamehameha", caster.main_ability_name, false, true)
	local newAbility = caster:GetAbilityByIndex(0)
	newAbility:StartCooldown(cooldown)
	newAbility:SetLevel(caster.ability_level)--]]
	
	local oldAbility = caster:GetAbilityByIndex(0)
	local cooldown = oldAbility:GetCooldownTimeRemaining()
	caster:RemoveAbility("goku_super_kamehameha")
	local newAbility = caster:AddAbility(caster.main_ability_name)
	newAbility:SetAbilityIndex(0)
	newAbility:StartCooldown(cooldown)
	newAbility:SetLevel(caster.ability_level)
end

function SuperSaiyanEffect( keys )
local caster = keys.caster
local ability = keys.ability
local level = ability:GetLevel()
if level == 1 then
	local particle = ParticleManager:CreateParticle("particles/goku/teleport_end_ground_flash_league.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle2, 1, Vector(200, 200, 200))
	print("EFFEKTO PATRONUS")
elseif level == 2 then 
	local particle = ParticleManager:CreateParticle("particles/goku/teleport_end_ground_flash_league.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle2, 1, Vector(400, 400, 400))
	local particle3 = ParticleManager:CreateParticle("particles/goku/teleport_end_ground_flash_leagu_extrae.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle3, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	print("EFFEKTO PATRONUS")
elseif level == 3 then
	local particle = ParticleManager:CreateParticle("particles/goku/teleport_end_ground_flash_league.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle2, 1, Vector(500, 500, 500))
	local particle3 = ParticleManager:CreateParticle("particles/goku/teleport_end_ground_flash_leagu_extrae.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle3, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	print("EFFEKTO PATRONUS")
end	
end 