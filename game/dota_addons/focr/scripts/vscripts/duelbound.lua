function duelOFF(trigger)
local activator = trigger.activator:GetUnitName()
if not DUEL then
--	Timers:CreateTimer({
--    endTime = 0.03,
--    callback = function()
--	local unit = trigger.activator
--	local position = unit:GetAbsOrigin()
--	local newPos = position
--	newPos[2] = -2016
--	FindClearSpaceForUnit(unit, newPos, false)
--    end
--})
local unit = trigger.activator
local position = unit:GetAbsOrigin()
local newPos = position
local left_displacement = position[1] + 1600
local right_displacement = 1344 - position[1]
local top_displacement = -2752 - position[2]
if right_displacement >= left_displacement then
	if left_displacement >= top_displacement then
		newPos[2] = -2112
	else
		newPos[1] = -2240
	end
else
	if right_displacement >= top_displacement then
		newPos[2] = -2112
	else
		newPos[1] = 1984
	end
end
FindClearSpaceForUnit(unit, newPos, false)
end
end

function duelON(trigger)
if DUEL then 
	local unit = trigger.activator
	local position = unit:GetAbsOrigin()
	local newPos = position

	if position[1] <= -1600 then
	newPos[1] = -1550
	end
	
	if position[1] >= 1344 then
	newPos[1] = 1300
	end
	
	if position[2] >= -2752 then
	newPos[2] = -2800
	end
	
	if position[2] <= -4160 then
	newPos[2] = -4100
	end
	
	FindClearSpaceForUnit(unit, newPos, false)	
end
end
