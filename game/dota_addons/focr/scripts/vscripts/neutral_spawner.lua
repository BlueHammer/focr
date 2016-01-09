function spawnNeutral1(trigger)
local point = Entities:FindByName( nil, "spawnerN1" ):GetAbsOrigin()
local unitChecker = #FindUnitsInRadius(DOTA_TEAM_NEUTRALS, point, nil, 1800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
local unitsToSpawn = 10
	if unitChecker <= 90  then
		for i=1, unitsToSpawn do
			local unit1 = CreateUnitByName("unit_infernal", point+RandomVector(RandomInt(100,1500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit1:SetHullRadius(70)
		end
	end
end



function spawnNeutral2(trigger)
local point = Entities:FindByName( nil, "spawnerN2" ):GetAbsOrigin()
local unitChecker = #FindUnitsInRadius(DOTA_TEAM_NEUTRALS, point, nil, 1900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
local unitsToSpawn = 2
	if unitChecker <= 36 then
		for i=1, unitsToSpawn do
			local unit1 = CreateUnitByName("unit_elder_drake", point+RandomVector(RandomInt(100,1700)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit1:SetHullRadius(70)
			local unit2 = CreateUnitByName("unit_ancient_behemoth", point+RandomVector(RandomInt(100,1700)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit2:SetHullRadius(70)			
		end
	end
end


function spawnNeutral3(trigger)
local point = Entities:FindByName( nil, "spawnerN3" ):GetAbsOrigin()
local unitChecker = #FindUnitsInRadius(DOTA_TEAM_NEUTRALS, point, nil, 1900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
local unitsToSpawn = 2
	if unitChecker <= 36 then
		for i=1, unitsToSpawn do
			local unit1 = CreateUnitByName("unit_elder_skeleton", point+RandomVector(RandomInt(100,1700)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit1:SetHullRadius(70)
			local unit2 = CreateUnitByName("unit_ancient_demon", point+RandomVector(RandomInt(100,1700)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit2:SetHullRadius(70)			
		end
	end
end

function spawnNeutral4(trigger)
local point = Entities:FindByName( nil, "spawnerN4" ):GetAbsOrigin()
local unitChecker = #FindUnitsInRadius(DOTA_TEAM_NEUTRALS, point, nil, 1800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
local unitsToSpawn = 3
	if unitChecker <= 90 then
		for i=1, unitsToSpawn do
			local unit1 = CreateUnitByName("unit_atropos", point+RandomVector(RandomInt(100,1500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit1:SetHullRadius(70)
			local unit2 = CreateUnitByName("unit_shiva", point+RandomVector(RandomInt(100,1500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit2:SetHullRadius(70)
			local unit3 = CreateUnitByName("unit_harpy", point+RandomVector(RandomInt(100,1500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit3:SetHullRadius(70)			
		end
	end
end
