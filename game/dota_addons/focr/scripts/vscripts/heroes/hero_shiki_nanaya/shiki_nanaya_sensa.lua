function SensaBlink( keys )
local ability = keys.ability
local caster = keys.caster
local casterPos = caster:GetAbsOrigin()
local range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
local duration = ability:GetLevelSpecialValueFor("linger_duration", (ability:GetLevel() - 1))
local direction = caster:GetForwardVector()
local point = direction * 800 + casterPos
local dummy = CreateUnitByName( "npc_dummy_unit", casterPos, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy, "modifier_sensa_dummy", {} )

FindClearSpaceForUnit(caster, point, false)

Timers:CreateTimer( duration, function()
	if not caster:HasModifier("modifier_sensa_disable") then
		FindClearSpaceForUnit(caster, casterPos, false)
	end
	dummy:ForceKill( true )
	return nil
	end
)
end