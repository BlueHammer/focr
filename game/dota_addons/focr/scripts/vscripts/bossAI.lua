function bossmove(keys)
local caster = keys.caster
local attackstate = caster:GetAggroTarget()
if (functionOFF == nil) or (functionOFF == true) then 
	local functionOFF = true 
	if not(attackstate == nil) then
	functionOFF = false
		Timers:CreateTimer({
    endTime = 8.0,
    callback = function()
	local point = Entities:FindByName(nil, "bossspawn1"):GetAbsOrigin()
	caster:MoveToPosition(point)
	functionOFF = true
    end
})
	end
end
end

function bossmovea(keys)
local caster = keys.caster
local attackstate = caster:GetAggroTarget()
if (functionOFF == nil) or (functionOFF == true) then 
	local functionOFF = true 
	if not(attackstate == nil) then
	functionOFF = false
		Timers:CreateTimer({
    endTime = 8.0,
    callback = function()
	local point = Entities:FindByName(nil, "bossspawn2"):GetAbsOrigin()
	caster:MoveToPosition(point)
	functionOFF = true
    end
})
	end
end
end
