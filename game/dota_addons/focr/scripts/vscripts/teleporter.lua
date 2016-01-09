function tpCR(trigger)
local point = Entities:FindByName( nil, "redC" ):GetAbsOrigin()
local target = trigger.activator
FindClearSpaceForUnit(target, point, false)
target:Stop()
end

function tpCB(trigger)
local point = Entities:FindByName( nil, "blueC" ):GetAbsOrigin()
local target = trigger.activator
FindClearSpaceForUnit(target, point, false)
target:Stop()
end

function tpBR(trigger)
local point = Entities:FindByName( nil, "particle4" ):GetAbsOrigin()
local target = trigger.activator
FindClearSpaceForUnit(target, point, false)
target:Stop()
end

function tpBL(trigger)
local point = Entities:FindByName( nil, "particle2" ):GetAbsOrigin()
local target = trigger.activator
FindClearSpaceForUnit(target, point, false)
target:Stop()
end

function tpTL(trigger)
local point = Entities:FindByName( nil, "particle1" ):GetAbsOrigin()
local target = trigger.activator
FindClearSpaceForUnit(target, point, false)
target:Stop()
end

function tpTR(trigger)
local point = Entities:FindByName( nil, "particle3" ):GetAbsOrigin()
local target = trigger.activator
FindClearSpaceForUnit(target, point, false)
target:Stop()
end