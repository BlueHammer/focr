function UraRengeStart( keys )
local caster = keys.caster
local target = keys.target
local ability = keys.ability
local targetPos = target:GetAbsOrigin()

--constant values
local number_of_punches = 20
local height_minimum = 200
local height_maximum = 350
local radius_minimum = 100
local radius_maximum = 400

--initializing punch number_of_punches done
local punch_landed = 0

local dummy = CreateUnitByName( "npc_dummy_unit", targetPos, false, caster, caster, caster:GetTeamNumber() )
ability:ApplyDataDrivenModifier( caster, dummy, "modifier_ura_renge_dummy", {} )

local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
local duration_caster = duration + 0.10
local punch_interval = duration / number_of_punches
local casterPos = caster:GetAbsOrigin()

caster:AddEffects(EF_NODRAW)
Timers:CreateTimer( duration_caster, function()
	caster:RemoveEffects( EF_NODRAW )
	local model = caster:FirstMoveChild()
	while model ~= nil do
	if model:GetClassname() == "dota_item_wearable" then
		model:AddEffects(EF_NODRAW) -- Set model hidden
	end
	model = model:NextMovePeer()
	end
	
	dummy:ForceKill( true )
return nil
end
)

Timers:CreateTimer( punch_interval, function()
if punch_landed < 20 then
	local newPos = dummy:GetAbsOrigin()
	local angle_random = math.random(0,360)
	local radius_random = math.random(100,400)
	local height_random = math.random(200,350)
	local x_value = radius_random * math.cos( angle_random )
	local y_value = radius_random * math.sin( angle_random )
	
	newPos[3] = newPos[3] + height_random
	
	if angle_random < 91 then
		newPos[1] = newPos[1] + x_value
		newPos[2] = newPos[2] + y_value
	elseif angle_random < 181 then 
		newPos[1] = newPos[1] - x_value
		newPos[2] = newPos[2] + y_value	
	elseif angle_random < 271 then 
		newPos[1] = newPos[1] - x_value
		newPos[2] = newPos[2] - y_value
	else 
		newPos[1] = newPos[1] + x_value
		newPos[2] = newPos[2] - y_value
	end
	
	target:SetAbsOrigin(newPos)
	caster:SetAbsOrigin(newPos)
	
	local refPoint = dummy:GetAbsOrigin() + Vector( 0, 0, 275 )
	local direction = ( newPos - refPoint ):Normalized()
	local particle = ParticleManager:CreateParticle("particles/rocklee/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 1, newPos)
	ParticleManager:SetParticleControl(particle, 3, newPos)
	ParticleManager:SetParticleControlOrientation(particle, 3, direction, direction, direction)

	punch_landed = punch_landed + 1
	print("BOO")
	print(newPos)
	return punch_interval
else
	local targetCurrentPos = target:GetAbsOrigin()
	FindClearSpaceForUnit(target, targetCurrentPos, false)
	FindClearSpaceForUnit(caster, targetCurrentPos, false)
	return nil
end
end
)
end