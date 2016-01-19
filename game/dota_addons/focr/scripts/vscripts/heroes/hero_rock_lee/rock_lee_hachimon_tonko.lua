LinkLuaModifier("modifier_hachimon_tonko_speed_lua", "scripts/vscripts/heroes/hero_rock_lee/modifiers/modifier_hachimon_tonko_speed.lua", LUA_MODIFIER_MOTION_NONE)
function ApplyHaste( keys )
local caster = keys.caster
local ability = keys.ability
local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
caster:AddNewModifier(caster, ability, "modifier_hachimon_tonko_speed_lua", {Duration = duration})
end

function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	if caster.caster_model_scale == nil then
		caster.caster_model_scale = caster:GetModelScale()
	end

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetModelScale(2.65)
	
	--applying particle
	caster.Hachimon_particle = ParticleManager:CreateParticle("particles/rocklee/dazzle_shallow_grave_halo_spiral.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	
end

function ModelSwapEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetModelScale(caster.caster_model_scale)
	
	ParticleManager:DestroyParticle( caster.Hachimon_particle, false )
	
end

function HachimonTonkoEnd( keys )
local caster = keys.caster
local health = caster:GetHealth()
local damage = health / 2
local damageTable =
{
	victim = caster,
	attacker = caster,
	damage = damage,
	damage_type = DAMAGE_TYPE_MAGICAL 
}
ApplyDamage( damageTable )
print("halfing hp")
print(health)
end