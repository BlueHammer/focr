function AgiSteal( keys )
local hero = keys.target
local caster = keys.caster
local ability = keys.ability
local AGIMultiplier = ability:GetLevelSpecialValueFor("agi_steal_multiplier", (ability:GetLevel() - 1))
local heroAGI = hero:GetLevel()
local AGIGain = heroAGI * AGIMultiplier
local currentAGI = caster:GetModifierStackCount("modifier_agility_bonus", ability)
local nextAGI = AGIGain + currentAGI 

if not caster:HasModifier("modifier_agility_bonus") then
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_agility_bonus", {})
end


caster:SetModifierStackCount("modifier_agility_bonus", caster, nextAGI)
end