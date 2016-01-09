function duelStart()
for k,v in pairs(GameRules.heroList) do
	local additionalUnit = v:GetAdditionalOwnedUnits()
	if v:IsAlive() then
	GameRules.APPLIER:ApplyDataDrivenModifier(v, v, "modifier_duel_stop", {})
	else
	v:SetTimeUntilRespawn(0.0)
	GameRules.APPLIER:ApplyDataDrivenModifier(v, v, "modifier_duel_stop", {})
	--local respawnTime = v:GetRespawnTime() + 0.03
	--Timers:CreateTimer({
    --endTime = respawnTime,
    --callback = function()
	--GameRules.APPLIER:ApplyDataDrivenModifier(v, v, "modifier_duel_stop", {duration=6.0-respawnTime})
    --end
	--})
	end
	
	for k,v in pairs(additionalUnit) do
		GameRules.APPLIER:ApplyDataDrivenModifier(v, v, "modifier_duel_stop", {})
	end
end
print("duel commencing in 6seconds")
duelCommence()
DUEL = true
end

function duelCommence()
blueCount = 1
redCount = 1
blueDeathCount = 1
redDeathCount = 1
local redP = {}
local blueP = {}
redP[1] = Entities:FindByName( nil, "redDuel1" ):GetAbsOrigin()
redP[2] = Entities:FindByName( nil, "redDuel2" ):GetAbsOrigin()
redP[3] = Entities:FindByName( nil, "redDuel3" ):GetAbsOrigin()
redP[4] = Entities:FindByName( nil, "redDuel4" ):GetAbsOrigin()
redP[5] = Entities:FindByName( nil, "redDuel5" ):GetAbsOrigin()
blueP[1] = Entities:FindByName( nil, "blueDuel1" ):GetAbsOrigin()
blueP[2] = Entities:FindByName( nil, "blueDuel2" ):GetAbsOrigin()
blueP[3] = Entities:FindByName( nil, "blueDuel3" ):GetAbsOrigin()
blueP[4] = Entities:FindByName( nil, "blueDuel4" ):GetAbsOrigin()
blueP[5] = Entities:FindByName( nil, "blueDuel5" ):GetAbsOrigin()

	Timers:CreateTimer({
    endTime = 6.0,
    callback = function()
	for k,v in pairs(GameRules.heroList) do
		if v:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			FindClearSpaceForUnit(v, redP[redCount], false)
			v:Stop()
			local additionalUnit = v:GetAdditionalOwnedUnits()
			for k,v in pairs(additionalUnit) do
				FindClearSpaceForUnit(v, redP[redCount], false)
				v:Stop()
			end
		redCount = redCount + 1
		elseif v:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			FindClearSpaceForUnit(v, blueP[blueCount], false)
			v:Stop()
			local additionalUnit = v:GetAdditionalOwnedUnits()
			for k,v in pairs(additionalUnit) do
				FindClearSpaceForUnit(v, blueP[blueCount], false)
				v:Stop()
			end
		blueCount = blueCount + 1	
		end
    end
	Timers:CreateTimer({
	endTime = 0.03,
	callback = function()
	if blueCount == 1 or redCount == 1  then
		duelEnd("STALEMATE")
	end
	end
	})
	duelListener = ListenToGameEvent("entity_killed", duelInProgress, nil)
	end
	})
end

function duelInProgress(eventInfo)
if DUEL then 
local entity = EntIndexToHScript(eventInfo.entindex_killed)
local redP = {
	[1] = Entities:FindByName( nil, "redDuel1" ):GetAbsOrigin(),
	[2] = Entities:FindByName( nil, "redDuel2" ):GetAbsOrigin(),
	[3] = Entities:FindByName( nil, "redDuel3" ):GetAbsOrigin(),
	[4] = Entities:FindByName( nil, "redDuel4" ):GetAbsOrigin(),
	[5] = Entities:FindByName( nil, "redDuel5" ):GetAbsOrigin()
	}
	
local blueP = {
	[1] = Entities:FindByName( nil, "blueDuel1" ):GetAbsOrigin(),
	[2] = Entities:FindByName( nil, "blueDuel2" ):GetAbsOrigin(),
	[3] = Entities:FindByName( nil, "blueDuel3" ):GetAbsOrigin(),
	[4] = Entities:FindByName( nil, "blueDuel4" ):GetAbsOrigin(),
	[5] = Entities:FindByName( nil, "blueDuel5" ):GetAbsOrigin()
	}


if entity ~= nil then
if entity:IsRealHero() then
	if entity:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		entity:SetTimeUntilRespawn(0.03)
		Timers:CreateTimer({
		endTime = 0.12,
		callback = function()
		FindClearSpaceForUnit(entity, redP[redDeathCount], false)
		GameRules.APPLIER:ApplyDataDrivenModifier(entity, entity, "modifier_duel_dead", {})	
		redDeathCount = redDeathCount + 1
		end
		})
	elseif entity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		entity:SetTimeUntilRespawn(0.03)
		Timers:CreateTimer({
		endTime = 0.12,
		callback = function()
		FindClearSpaceForUnit(entity, blueP[blueDeathCount], false)
		GameRules.APPLIER:ApplyDataDrivenModifier(entity, entity, "modifier_duel_dead", {})	
		blueDeathCount = blueDeathCount + 1
		end
		})
	end
end
end

	Timers:CreateTimer({
    endTime = 0.15,
    callback = function()
	if redDeathCount == redCount then
		duelEnd(DOTA_TEAM_BADGUYS)
		StopListeningToGameEvent(duelListener)
	elseif blueDeathCount == blueCount then
		duelEnd(DOTA_TEAM_GOODGUYS)
		StopListeningToGameEvent(duelListener)
	end	
    end
	})
	
	Timers:CreateTimer({
    endTime = 120,
    callback = function()
	if DUEL then
		duelEnd("DRAW")
	end
    end
	})	
end
end

function duelEnd(loser)
local bluePoint = Entities:FindByName( nil, "blueSpawn" ):GetAbsOrigin()
local redPoint = Entities:FindByName( nil, "redSpawn" ):GetAbsOrigin()
DUEL = false 
for k,v in pairs(GameRules.heroList) do
	v:RemoveModifierByName("modifier_duel_dead")
	GameRules.APPLIER:ApplyDataDrivenModifier(v, v, "modifier_duel_stop", {duration=3.0})
	Timers:CreateTimer({
    endTime = 3.03,
    callback = function()
	if v:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		FindClearSpaceForUnit(v, bluePoint, false)
		v:Stop()
	elseif v:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		FindClearSpaceForUnit(v, redPoint, false)
		v:Stop()
	end
    end
	})	
end

	Timers:CreateTimer({
    endTime = 300,
    callback = function()
	duelStart()
    end
	})

if loser == DOTA_TEAM_BADGUYS then
--[[ money reward dll ]]--	
print("RED LOST")
elseif loser == DOTA_TEAM_GOODGUYS then
--[[money reward for blue]]--
print("BLUE LOST")
elseif loser == "DRAW" then
--[[draw]]--
elseif loser == "STALEMATE" then
--[[duel cant commence to due lack of player]]--
print("duel cannot commence due to lack of opponent")
end
end


--detect if no enemy actually present, send "no enemy", "duel cant commence" message


