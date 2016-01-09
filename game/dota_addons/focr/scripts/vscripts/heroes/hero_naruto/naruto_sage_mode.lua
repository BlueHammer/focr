function ModelSwapStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local model = keys.model
	--local oldAbility = caster:GetAbilityByIndex(3)
	local level = ability:GetLevel()
	--caster.ability_level = caster.main_ability:GetLevel()
	--caster.main_ability_name = caster.main_ability:GetAbilityName()

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	if caster.caster_model_scale == nil then
		caster.caster_model_scale = caster:GetModelScale()
	end

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetModelScale(1.30)
	
	--threaldeal
	caster:RemoveAbility("rubick_empty1")
	local newAbility = caster:AddAbility("naruto_odama_rasengan")
	newAbility:SetAbilityIndex(3)
	newAbility:SetLevel(level)
	
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
	
	--threaldeal
	--local oldAbility = caster:GetAbilityByIndex(3)
	--local cooldown = oldAbility:GetCooldownTimeRemaining()
	caster:RemoveAbility("naruto_odama_rasengan")
	local newAbility = caster:AddAbility("rubick_empty1")
	newAbility:SetAbilityIndex(3)
	--newAbility:StartCooldown(cooldown)
	--newAbility:SetLevel(caster.ability_level)
end