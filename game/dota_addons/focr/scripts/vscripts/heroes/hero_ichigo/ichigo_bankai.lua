function BankaiActivateCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_bankai", {})
end

function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
end

function ModelSwapEnd( keys )
	local caster = keys.caster
	local model = keys.model

	caster:SetModel(model)
	caster:SetOriginalModel(model)
end

function SkillReplaceStart( keys )
local caster = keys.caster
local ability = keys.ability
local level = ability:GetLevel()
local originalability = caster:GetAbilityByIndex(0)

caster.caster_getsuga_level = originalability:GetLevel()
caster.caster_bankai_level = level

print("IM REPLACING DA SKILL")
if level <= 2 then 
	caster:RemoveAbility("ichigo_getsuga_tenshou")
	local newAbility = caster:AddAbility("ichigo_kuroi_getsuga_tenshou")
	newAbility:SetLevel(level)
	newAbility:SetAbilityIndex(0)
elseif level <= 4 then 
	caster:RemoveAbility("ichigo_getsuga_tenshou")
	local newAbility = caster:AddAbility("ichigo_double_kuroi_getsuga_tenshou")
	newAbility:SetLevel(level)
	newAbility:SetAbilityIndex(0)
elseif level == 5 then
	caster:RemoveAbility("ichigo_getsuga_tenshou")
	local newAbility = caster:AddAbility("ichigo_cero")
	newAbility:SetLevel(level)
	newAbility:SetAbilityIndex(0)
end
end

function SkillReplaceEnd( keys )
local caster = keys.caster
local originallevel = caster.caster_getsuga_level
local level = caster.caster_bankai_level


print("IM REPLACING DA SKILL")
if level <= 2 then 
	caster:RemoveAbility("ichigo_kuroi_getsuga_tenshou")
	local newAbility = caster:AddAbility("ichigo_getsuga_tenshou")
	newAbility:SetLevel(originallevel)
	newAbility:SetAbilityIndex(0)
elseif level <= 4 then
	caster:RemoveAbility("ichigo_double_kuroi_getsuga_tenshou")
	local newAbility = caster:AddAbility("ichigo_getsuga_tenshou")
	newAbility:SetLevel(originallevel)
	newAbility:SetAbilityIndex(0)
elseif level == 5 then
	caster:RemoveAbility("ichigo_cero")
	local newAbility = caster:AddAbility("ichigo_getsuga_tenshou")
	newAbility:SetLevel(originallevel)
	newAbility:SetAbilityIndex(0)
end
end